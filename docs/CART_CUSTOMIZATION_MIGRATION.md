# Cart Customization Migration — Eight Tea

## Tóm tắt

Thêm khả năng lưu lựa chọn **Đường / Đá / Ghi chú** của khách xuyên suốt:
Product Detail → Giỏ hàng → Checkout → Chi tiết đơn hàng.

---

## Yêu cầu trước khi deploy

**Bắt buộc chạy migration SQL trước khi deploy WAR mới.**  
Nếu deploy code mới mà chưa chạy SQL, `SELECT c.*` trong CartItemDaoImpl sẽ thiếu cột và gây lỗi runtime.

---

## 1. Chạy migration SQL

```sql
-- File: sql/migration_cart_customization_v1.sql
-- Idempotent: chạy nhiều lần không lỗi
```

Kết nối vào SQL Server (SSMS hoặc sqlcmd), chọn database `BanNuoc_Truc`, chạy file trên.

Kiểm tra kết quả — tất cả 6 cột phải trả về giá trị khác NULL:

```
CartItems_SugarLevel | CartItems_IceLevel | CartItems_DrinkNote |
OrderDetails_SugarLevel | OrderDetails_IceLevel | OrderDetails_DrinkNote
```

---

## 2. Schema thay đổi

### CartItems

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| `SugarLevel` | `NVARCHAR(20) NULL` | "0%", "30%", "70%", "100%" — NULL cho topping |
| `IceLevel`   | `NVARCHAR(30) NULL` | "Nóng / Ít đá", "50% đá", "100% đá" — NULL cho topping |
| `DrinkNote`  | `NVARCHAR(200) NULL` | Ghi chú tự do tối đa 200 ký tự |

Unique constraint `UQ_CartItems_User_Variant (UserID, VariantID)` giữ nguyên. Khi user thêm lại cùng một variant, `Quantity` cộng dồn và `SugarLevel/IceLevel/DrinkNote` cập nhật theo lần thêm gần nhất.

### OrderDetails

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| `SugarLevel` | `NVARCHAR(20) NULL` | Snapshot tại thời điểm đặt hàng |
| `IceLevel`   | `NVARCHAR(30) NULL` | Snapshot |
| `DrinkNote`  | `NVARCHAR(200) NULL` | Snapshot |

---

## 3. Code thay đổi (đã thực hiện)

| File | Thay đổi |
|------|----------|
| `CartItem.java` | Thêm `sugarLevel`, `iceLevel`, `note` |
| `CartLineItemDto.java` | Thêm `sugarLevel`, `iceLevel`, `note` |
| `OrderDetail.java` | Thêm `sugarLevel`, `iceLevel`, `note` |
| `CartItemDao.java` | `insertOrUpdate` có thêm 3 tham số customization |
| `CartItemDaoImpl.java` | UPDATE + INSERT CartItems bao gồm cả 3 cột; `mapRow` và `mapLineItem` đọc cột mới; `LINE_ITEM_SELECT` liệt kê tường minh |
| `CartController.java` | Đọc `sugar`/`ice`/`note` từ request, validate whitelist, truyền xuống DAO |
| `OrderDaoImpl.java` | `placeOrder` và `placeOrderPayOS` INSERT OrderDetails bao gồm 3 cột snapshot; `findOrderById` mapping đọc 3 cột |
| `cart.js` | `addToCart(variantId, qty, btn, customization)` — tham số thứ 4 mới |
| `product-detail.jsp` | `submitAdd()` đọc `pdSugar`, `pdIce`, `pdNote` và truyền vào `addToCart` |
| `cart.jsp` | Hiển thị `sugarLevel`, `iceLevel`, `note` trong `cart-item-meta` |
| `checkout.jsp` | Hiển thị `sugarLevel`, `iceLevel`, `note` trong `checkout-summary-item-meta` |
| `web.xml` | `assetVer` 53 → 54 |

---

## 4. Whitelist validation (server-side)

`CartController.sanitizeSugar` / `sanitizeIce` / `sanitizeNote` từ chối giá trị ngoài danh sách cho phép. Giá trị không hợp lệ lưu thành NULL (không báo lỗi — toppings hợp lệ không gửi đường/đá).

| Field | Giá trị hợp lệ |
|-------|---------------|
| Sugar | `0%`, `30%`, `70%`, `100%` |
| Ice   | `Nóng / Ít đá`, `50% đá`, `100% đá` |
| Note  | Bất kỳ string, truncate tại 200 ký tự |

---

## 5. Thứ tự deploy

1. **Chạy** `sql/migration_cart_customization_v1.sql` trên DB
2. **Build**: `mvn clean package -DskipTests`
3. **Deploy** WAR lên Tomcat (hoặc redeploy)
4. **Kiểm tra**: Vào trang sản phẩm, chọn đường/đá/ghi chú, thêm giỏ → Vào `/cart` xác nhận hiển thị → Checkout → Đặt hàng → Vào admin xem chi tiết đơn, xác nhận snapshot

---

## 6. Dữ liệu cũ

Các dòng CartItems và OrderDetails tạo trước migration sẽ có `NULL` ở 3 cột mới. UI hiển thị đúng — `<c:if test="${not empty item.sugarLevel}">` bỏ qua khi NULL.
