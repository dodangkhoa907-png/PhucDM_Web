-- ================================================================
-- Dữ liệu mẫu cho dải đánh giá ở trang chủ (Section 2 — Món tủ của quán)
--
-- Trang chủ đọc qua FeedbackDao.findPublic(), tức là CHỈ lấy dòng có
--     Status = 'RESOLVED' AND Rating IS NOT NULL
-- Feedback ở trạng thái NEW/SEEN sẽ KHÔNG hiện ra ngoài — đúng ý đồ
-- "phải duyệt mới công khai". Vì vậy script này chèn thẳng RESOLVED.
--
-- Chạy một lần trong SSMS. Chạy lại sẽ tạo thêm bản ghi trùng nội dung,
-- nên nếu cần làm lại thì xoá theo câu lệnh ở cuối file.
-- ================================================================

USE BanNuoc;
GO

INSERT INTO dbo.Feedback (UserID, Name, Phone, Email, Rating, Message, Status, CreatedAt)
VALUES
(NULL, N'Minh Thư',   N'0901234567', NULL, 5,
 N'Ô long nướng thơm thật, hậu vị khói nhẹ chứ không ngọt gắt như mấy chỗ khác. Giao tới còn lạnh nguyên.',
 'RESOLVED', DATEADD(DAY, -3, GETDATE())),

(NULL, N'Đăng Khoa',  N'0912345678', NULL, 5,
 N'Đặt lúc 9h tối, 20 phút sau có ly trên bàn. Nắp ép màng kín, để trong cặp đi học không đổ giọt nào.',
 'RESOLVED', DATEADD(DAY, -6, GETDATE())),

(NULL, N'Khánh Linh', N'0987654321', NULL, 4,
 N'Giá hợp túi tiền sinh viên mà vị không bị loãng. Mình hay chọn 30% đường, quán làm đúng y yêu cầu.',
 'RESOLVED', DATEADD(DAY, -9, GETDATE()));
GO

PRINT N'Da chen 3 feedback mau (RESOLVED). Tai lai trang chu de xem dai danh gia.';
GO

-- Muốn gỡ dữ liệu mẫu này:
-- DELETE FROM dbo.Feedback WHERE Phone IN (N'0901234567', N'0912345678', N'0987654321');
