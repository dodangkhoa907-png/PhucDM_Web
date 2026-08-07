package com.eighttea.controller;

import com.eighttea.dao.CategoryDao;
import com.eighttea.dao.ProductDao;
import com.eighttea.dao.impl.CategoryDaoImpl;
import com.eighttea.dao.impl.ProductDaoImpl;
import com.eighttea.model.Category;
import com.eighttea.model.Product;
import com.eighttea.util.ProductSort;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * Khu sản phẩm khách hàng:
 * - GET /thuc-don            — route cũ, đã gộp vào /san-pham. Redirect 301 giữ nguyên ?danhmuc=
 *                              để không phá link cũ (bookmark, kết quả tìm kiếm...).
 * - GET /san-pham            — khu sản phẩm (lọc danh mục + tìm kiếm + sắp xếp).
 * - GET /san-pham/chi-tiet   — chi tiết 1 sản phẩm theo ?id=.
 */
@WebServlet(name = "ProductController", urlPatterns = {"/thuc-don", "/san-pham", "/san-pham/chi-tiet"})
public class ProductController extends HttpServlet {

    private CategoryDao categoryDao;
    private ProductDao productDao;

    @Override
    public void init() {
        categoryDao = new CategoryDaoImpl();
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        switch (path) {
            case "/thuc-don" -> handleThucDonRedirect(req, resp);
            case "/san-pham" -> handleShopList(req, resp);
            case "/san-pham/chi-tiet" -> handleShopDetail(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * "Thực Đơn" đã gộp vào "Sản Phẩm" (dự án bán cây/decor, không phải F&amp;B).
     * Redirect an toàn sang /san-pham, giữ lại ?danhmuc= nếu có để không phá link cũ.
     */
    private void handleThucDonRedirect(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String catParam = req.getParameter("danhmuc");
        String target = req.getContextPath() + "/san-pham";
        if (catParam != null && !catParam.isBlank()) {
            try {
                int categoryId = Integer.parseInt(catParam.trim());
                target += "?danhmuc=" + categoryId;
            } catch (NumberFormatException ignored) {
                // Tham số không hợp lệ — bỏ qua, redirect về /san-pham không lọc.
            }
        }
        resp.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
        resp.setHeader("Location", target);
    }

    /** Khu sản phẩm mới — lọc danh mục + tìm kiếm + sắp xếp, tất cả xử lý server-side. */
    private void handleShopList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Category> categories = categoryDao.findAll();

        Integer categoryId = null;
        String catParam = req.getParameter("danhmuc");
        if (catParam != null && !catParam.isBlank()) {
            try {
                categoryId = Integer.parseInt(catParam.trim());
            } catch (NumberFormatException ignored) {
                categoryId = null;
            }
        }

        String keyword = req.getParameter("q");
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.length() > 100) keyword = keyword.substring(0, 100);
            if (keyword.isEmpty()) keyword = null;
        }

        ProductSort sort = ProductSort.fromParam(req.getParameter("sort"));

        // Lọc danh mục chuyển sang client-side (JS ẩn/hiện theo data-category-id) để chuyển tab
        // tức thì, không reload trang — server chỉ còn lọc theo từ khóa + sắp xếp. categoryId vẫn
        // được giữ lại làm "activeCategoryId" để JS biết tab nào cần bật sẵn lúc tải trang.
        List<Product> products = productDao.findActiveForShop(null, keyword, sort);

        // Số "món pha theo đơn" hiển thị ở hero: chỉ tính đồ uống thật, không tính Topping
        // (trân châu, phô mai viên...) — topping không phải một món uống độc lập.
        long drinkCount = products.stream()
                .filter(p -> !"Topping".equalsIgnoreCase(p.getCategoryName()))
                .count();

        // Query string dùng lại (không đổi danh mục) khi search/sort đổi — build sẵn ở server, JSP không tự ghép URL.
        String keepQuerySuffix = buildQuerySuffix(keyword, sort);

        req.setAttribute("categories", categories);
        req.setAttribute("products", products);
        req.setAttribute("drinkCount", drinkCount);
        req.setAttribute("activeCategoryId", categoryId);
        req.setAttribute("keyword", keyword);
        req.setAttribute("activeSort", sort.getParam());
        req.setAttribute("keepQuerySuffix", keepQuerySuffix);
        req.setAttribute("currentPage", "products");
        req.getRequestDispatcher("/WEB-INF/views/product-list.jsp").forward(req, resp);
    }

    private String buildQuerySuffix(String keyword, ProductSort sort) {
        StringBuilder sb = new StringBuilder();
        if (keyword != null && !keyword.isBlank()) {
            sb.append("&q=").append(java.net.URLEncoder.encode(keyword, java.nio.charset.StandardCharsets.UTF_8));
        }
        if (sort != null && sort != ProductSort.DEFAULT) {
            sb.append("&sort=").append(java.net.URLEncoder.encode(sort.getParam(), java.nio.charset.StandardCharsets.UTF_8));
        }
        return sb.toString();
    }

    /** Chi tiết sản phẩm — chỉ hiển thị sản phẩm active, chặn id không hợp lệ/không tồn tại. */
    private void handleShopDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        Integer productId = null;
        if (idParam != null && !idParam.isBlank()) {
            try {
                productId = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException ignored) {
                productId = null;
            }
        }

        Optional<Product> productOpt = (productId != null)
                ? productDao.findActiveById(productId)
                : Optional.empty();

        if (productOpt.isEmpty()) {
            req.setAttribute("errorMessage", "Sản phẩm không tồn tại hoặc đã ngừng kinh doanh.");
            req.setAttribute("currentPage", "products");
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            req.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(req, resp);
            return;
        }

        Product product = productOpt.get();
        req.setAttribute("product", product);
        req.setAttribute("otherProducts", findOtherProducts(product));
        // Topping là sản phẩm thật riêng trong DB (mỗi topping một VariantID) — trang chi tiết
        // cần danh sách này để khách tick thêm, giống hệt cách khu sản phẩm đang làm.
        req.setAttribute("toppings", findToppings(product));
        req.setAttribute("currentPage", "products");
        req.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(req, resp);
    }

    private static final int OTHER_PRODUCTS_LIMIT = 4;

    private static final String TOPPING_CATEGORY = "Topping";

    /**
     * Danh sách topping để thêm kèm. Bản thân topping cũng là một sản phẩm nên khi đang xem
     * đúng trang một topping thì không tự liệt kê lại chính nó.
     */
    private List<Product> findToppings(Product current) {
        List<Product> result = new java.util.ArrayList<>();
        for (Product p : productDao.findActiveForShop(null, null, ProductSort.NAME_ASC)) {
            if (!TOPPING_CATEGORY.equalsIgnoreCase(p.getCategoryName())) continue;
            if (p.getProductId() == current.getProductId()) continue;
            if (p.getVariants() == null || p.getVariants().isEmpty()) continue;
            result.add(p);
        }
        return result;
    }

    /**
     * Sản phẩm khác cho khách chọn thêm ngay dưới trang chi tiết — ưu tiên cùng danh mục,
     * bù thêm sản phẩm bất kỳ (khác danh mục) nếu danh mục hiện tại không đủ số lượng.
     */
    private List<Product> findOtherProducts(Product current) {
        List<Product> sameCategory = productDao.findActiveForShop(current.getCategoryId(), null, ProductSort.DEFAULT);
        List<Product> result = new java.util.ArrayList<>();
        for (Product p : sameCategory) {
            if (p.getProductId() != current.getProductId()) result.add(p);
            if (result.size() >= OTHER_PRODUCTS_LIMIT) return result;
        }

        List<Product> anyCategory = productDao.findActiveForShop(null, null, ProductSort.DEFAULT);
        for (Product p : anyCategory) {
            if (p.getProductId() == current.getProductId()) continue;
            // Topping (Milk Foam, trân châu...) không phải món uống độc lập — không gợi ý ở đây.
            if (TOPPING_CATEGORY.equalsIgnoreCase(p.getCategoryName())) continue;
            if (result.stream().anyMatch(r -> r.getProductId() == p.getProductId())) continue;
            result.add(p);
            if (result.size() >= OTHER_PRODUCTS_LIMIT) break;
        }
        return result;
    }
}
