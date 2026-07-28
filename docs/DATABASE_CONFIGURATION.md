# Database Configuration — Eight Tea

## Tóm tắt

Ứng dụng kết nối SQL Server qua HikariCP (class `Database`).  
Cấu hình được đọc theo thứ tự ưu tiên: **biến môi trường → db.properties (local only)**.

---

## Biến môi trường (production / Docker / Render / Railway)

| Biến | Ví dụ giá trị | Bắt buộc |
|------|--------------|----------|
| `DB_URL` | `jdbc:sqlserver://host:1433;databaseName=EightTea_DB;encrypt=true;trustServerCertificate=true` | Có |
| `DB_USERNAME` | `sa` | Có |
| `DB_PASSWORD` | `...` | Có |
| `DB_DRIVER` | `com.microsoft.sqlserver.jdbc.SQLServerDriver` | Không (đã có default) |

Nếu `DB_URL` không được đặt và không tìm thấy `db.properties`, ứng dụng ném `IllegalStateException` khi khởi động.

---

## Local dev — db.properties

1. Copy file mẫu:
   ```
   cp src/main/resources/db.properties.example src/main/resources/db.properties
   ```
2. Điền giá trị thật vào `db.properties`.
3. **KHÔNG commit** `db.properties` — file này đã được `.gitignore` chặn.

---

## PayOS (tùy chọn)

Đặt qua biến môi trường hoặc thêm vào `db.properties` (xem `db.properties.example`).  
Nếu bỏ trống, tùy chọn PayOS bị ẩn ở trang checkout, COD vẫn hoạt động bình thường.

---

## Lưu ý bảo mật

- `db.properties` chứa mật khẩu thật → **không bao giờ commit**.
- Nếu đã lỡ commit, cần **xoay mật khẩu SQL Server** ngay và dọn git history (hoặc tạo repo mới).
- File `.gitignore` có rule `**/db.properties` và `src/main/resources/db.properties`.
