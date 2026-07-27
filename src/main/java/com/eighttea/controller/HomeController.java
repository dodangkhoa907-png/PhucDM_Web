package com.eighttea.controller;

import com.eighttea.dao.FeedbackDao;
import com.eighttea.dao.ProductDao;
import com.eighttea.dao.impl.FeedbackDaoImpl;
import com.eighttea.dao.impl.ProductDaoImpl;
import com.eighttea.model.Feedback;
import com.eighttea.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * GET / — trang chủ. Nạp 3 món "nổi bật" thật từ DB cho khu trình chiếu đầu trang.
 *
 * QUAN TRỌNG — bài học từ sự cố vỡ giao diện:
 * TUYỆT ĐỐI KHÔNG map servlet này vào "/" (default-servlet). Khi map "/", servlet này nhận MỌI
 * request tĩnh (/css/*, /js/*, ảnh...) và forward về JSP → trả HTML với Content-Type text/html;
 * kèm header nosniff, trình duyệt từ chối áp dụng CSS → giao diện vỡ hoàn toàn.
 *
 * Cách đúng: chỉ map "/index.jsp". Welcome-file (index.jsp trong web.xml) khiến request "/" được
 * container phân giải sang "/index.jsp" → khớp servlet này → forward tới /WEB-INF/views/home.jsp.
 * DefaultServlet thật của Tomcat vẫn phục vụ /css, /js, ảnh với đúng Content-Type.
 */
@WebServlet(name = "HomeController", urlPatterns = {"/index.jsp"})
public class HomeController extends HttpServlet {

    private static final int SLIDE_COUNT = 3;

    /**
     * Món muốn đẩy lên khu trình chiếu, theo thứ tự ưu tiên. Khớp theo tên (không dấu
     * hoa/thường) để đổi tên nhẹ trong DB không làm vỡ trang; thiếu món nào thì lấp
     * bằng món active bất kỳ.
     */
    private static final String[] SHOWCASE_PREFERENCE = {"ô long", "trà tắc", "đào cam sả"};

    /** Số món cho khu "Món tủ của quán" (Section 2). */
    private static final int HIGHLIGHT_COUNT = 3;

    /**
     * Section 2 ưu tiên lấy mỗi nhóm một món để khác hẳn khu trình chiếu đầu trang (vốn
     * toàn trà). Chọn theo NHÓM chứ không theo tên món: tên món trong DB có thể đổi,
     * còn nhóm thì ổn định hơn.
     */
    private static final String[] HIGHLIGHT_CATEGORIES = {"Latte", "Soda", "Sữa Chua & Sữa Tươi"};

    /**
     * Lấy rộng feedback công khai để tính điểm trung bình + tổng số trên cùng một tập dữ
     * liệu thật (FeedbackDao chưa có hàm tính sẵn). Chỉ vài trăm dòng nên rẻ hơn nhiều so
     * với việc thêm truy vấn tổng hợp mới.
     */
    private static final int FEEDBACK_SCAN = 200;
    private static final int FEEDBACK_QUOTES = 3;

    private ProductDao productDao;
    private FeedbackDao feedbackDao;

    @Override
    public void init() {
        productDao = new ProductDaoImpl();
        feedbackDao = new FeedbackDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Gọi DB một lần rồi dùng chung: pickHighlights cần loại trừ đúng các đối tượng
        // Product mà pickShowcase đã chọn (so sánh theo tham chiếu).
        List<Product> active = productDao.findAllActive();
        List<Product> hero = pickShowcase(active);

        req.setAttribute("heroSlides", hero);
        req.setAttribute("highlightPicks", pickHighlights(active, hero));

        List<Feedback> publicFeedback = feedbackDao.findPublic(FEEDBACK_SCAN);
        double avg = averageRating(publicFeedback);
        req.setAttribute("feedbackQuotes", publicFeedback.subList(0,
                Math.min(FEEDBACK_QUOTES, publicFeedback.size())));
        req.setAttribute("feedbackCount", publicFeedback.size());
        // avg < 0 nghĩa là chưa có đánh giá nào — view dùng feedbackQuotes rỗng để ẩn dải.
        req.setAttribute("feedbackAvg", avg < 0 ? null : String.format(java.util.Locale.US, "%.1f", avg));
        // Số sao tô đặc, làm tròn sẵn ở đây để JSP không phải tính toán trên chuỗi.
        req.setAttribute("feedbackStars", avg < 0 ? 0 : (int) Math.round(avg));

        // Forward tới view trong /WEB-INF (KHÔNG map servlet) để tránh vòng lặp với chính
        // urlPattern "/index.jsp" của servlet này.
        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
    }

    /**
     * Chọn {@value #HIGHLIGHT_COUNT} món cho Section 2, LOẠI TRỪ các món đã lên khu trình
     * chiếu để trang không khoe trùng một ly hai lần. Ưu tiên mỗi nhóm trong
     * {@link #HIGHLIGHT_CATEGORIES} một món, thiếu thì lấp bằng món còn lại bất kỳ.
     */
    private List<Product> pickHighlights(List<Product> active, List<Product> exclude) {
        List<Product> pool = new ArrayList<>();
        for (Product p : active) {
            if (p.getVariants() != null && !p.getVariants().isEmpty()
                    && !"Topping".equalsIgnoreCase(p.getCategoryName())
                    && !exclude.contains(p)) {
                pool.add(p);
            }
        }

        List<Product> picked = new ArrayList<>();
        for (String cat : HIGHLIGHT_CATEGORIES) {
            for (Product p : pool) {
                if (picked.size() >= HIGHLIGHT_COUNT) break;
                if (cat.equalsIgnoreCase(p.getCategoryName()) && !picked.contains(p)) {
                    picked.add(p);
                    break;
                }
            }
        }
        for (Product p : pool) {
            if (picked.size() >= HIGHLIGHT_COUNT) break;
            if (!picked.contains(p)) picked.add(p);
        }
        return picked;
    }

    /** Điểm trung bình 1..5, hoặc -1 nếu chưa có đánh giá nào có chấm điểm. */
    private static double averageRating(List<Feedback> list) {
        int sum = 0, n = 0;
        for (Feedback f : list) {
            if (f.getRating() != null) { sum += f.getRating(); n++; }
        }
        return n == 0 ? -1 : sum / (double) n;
    }

    /** Chọn tối đa {@value #SLIDE_COUNT} món có biến thể giá để trình chiếu. */
    private List<Product> pickShowcase(List<Product> active) {
        List<Product> pool = new ArrayList<>();
        for (Product p : active) {
            // Topping không có size, không phải "món" để trình chiếu.
            if (p.getVariants() != null && !p.getVariants().isEmpty()
                    && !"Topping".equalsIgnoreCase(p.getCategoryName())) {
                pool.add(p);
            }
        }

        List<Product> picked = new ArrayList<>();
        for (String want : SHOWCASE_PREFERENCE) {
            for (Product p : pool) {
                if (picked.size() >= SLIDE_COUNT) break;
                if (p.getName() != null && p.getName().toLowerCase().contains(want)
                        && !picked.contains(p)) {
                    picked.add(p);
                    break;
                }
            }
        }
        for (Product p : pool) {
            if (picked.size() >= SLIDE_COUNT) break;
            if (!picked.contains(p)) picked.add(p);
        }
        return picked;
    }
}
