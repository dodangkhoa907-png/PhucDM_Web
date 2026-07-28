/* ================================================================
   Eight Tea — Migration: Customization cho giỏ hàng và đơn hàng
   SQL Server · database EightTea_DB
   File IDEMPOTENT: chạy lại nhiều lần không lỗi, không drop dữ liệu.

   Mục tiêu:
   Lưu lại lựa chọn Đường / Đá / Ghi chú của khách khi "Thêm vào giỏ"
   và sao chụp (snapshot) vào OrderDetails tại thời điểm đặt hàng.
   NULL = không chọn / không áp dụng (ví dụ: Topping không có Đường/Đá).

   LƯU Ý: file gốc (copy từ project "Nhiệt Đới Xanh") ghi nhầm
   "USE BanNuoc_Truc" — đó là database của project khác (Trúc), không phải
   database thật của Eight Tea. Vì ghi nhầm tên nên script này CHƯA TỪNG
   chạy đúng chỗ trên EightTea_DB — đây chính là nguyên nhân code Java
   (CartItemDaoImpl) đọc/ghi SugarLevel/IceLevel/DrinkNote nhưng cột đó
   không tồn tại, khiến /cart báo lỗi "Invalid column name 'SugarLevel'".
   Đã sửa lại đúng tên database bên dưới.
   ================================================================ */

USE EightTea_DB;
GO


/* ================================================================
   A. CartItems — thêm cột tuỳ chỉnh
   ================================================================ */
IF COL_LENGTH('dbo.CartItems', 'SugarLevel') IS NULL
BEGIN
    ALTER TABLE CartItems ADD SugarLevel NVARCHAR(20) NULL;
    PRINT N'Đã thêm cột CartItems.SugarLevel.';
END
GO

IF COL_LENGTH('dbo.CartItems', 'IceLevel') IS NULL
BEGIN
    ALTER TABLE CartItems ADD IceLevel NVARCHAR(30) NULL;
    PRINT N'Đã thêm cột CartItems.IceLevel.';
END
GO

IF COL_LENGTH('dbo.CartItems', 'DrinkNote') IS NULL
BEGIN
    ALTER TABLE CartItems ADD DrinkNote NVARCHAR(200) NULL;
    PRINT N'Đã thêm cột CartItems.DrinkNote.';
END
GO


/* ================================================================
   B. OrderDetails — snapshot tuỳ chỉnh tại thời điểm đặt hàng
   ================================================================ */
IF COL_LENGTH('dbo.OrderDetails', 'SugarLevel') IS NULL
BEGIN
    ALTER TABLE OrderDetails ADD SugarLevel NVARCHAR(20) NULL;
    PRINT N'Đã thêm cột OrderDetails.SugarLevel.';
END
GO

IF COL_LENGTH('dbo.OrderDetails', 'IceLevel') IS NULL
BEGIN
    ALTER TABLE OrderDetails ADD IceLevel NVARCHAR(30) NULL;
    PRINT N'Đã thêm cột OrderDetails.IceLevel.';
END
GO

IF COL_LENGTH('dbo.OrderDetails', 'DrinkNote') IS NULL
BEGIN
    ALTER TABLE OrderDetails ADD DrinkNote NVARCHAR(200) NULL;
    PRINT N'Đã thêm cột OrderDetails.DrinkNote.';
END
GO


/* ================================================================
   C. KIỂM TRA KẾT QUẢ
   ================================================================ */
PRINT N'';
PRINT N'BanNuoc_Truc — migration_cart_customization_v1 hoàn tất!';

SELECT
    COL_LENGTH('dbo.CartItems',    'SugarLevel') AS CartItems_SugarLevel,
    COL_LENGTH('dbo.CartItems',    'IceLevel')   AS CartItems_IceLevel,
    COL_LENGTH('dbo.CartItems',    'DrinkNote')  AS CartItems_DrinkNote,
    COL_LENGTH('dbo.OrderDetails', 'SugarLevel') AS OrderDetails_SugarLevel,
    COL_LENGTH('dbo.OrderDetails', 'IceLevel')   AS OrderDetails_IceLevel,
    COL_LENGTH('dbo.OrderDetails', 'DrinkNote')  AS OrderDetails_DrinkNote;
GO
