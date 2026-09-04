-- =========================================================================
-- SCRIPT NẠP 50 SẢN PHẨM ĐIỆN THOẠI (IPHONE, SAMSUNG, XIAOMI, OPPO, VIVO)
-- Database: bt01 (SQL Server)
-- =========================================================================

USE [bt01];
GO

SET NOCOUNT ON;

-- 1. ĐẢM BẢO DANH MỤC (CATEGORIES) ĐƯỢC THIẾT LẬP ĐẦY ĐỦ
-- Cập nhật danh mục id = 1 nếu đang là test/dd, hoặc đảm bảo có các hãng
IF EXISTS (SELECT 1 FROM categories WHERE CategoryId = 1)
BEGIN
    UPDATE categories 
    SET CategoryName = N'Apple (iPhone)', 
        Images = N'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=600&q=80',
        status = 1
    WHERE CategoryId = 1;
END
ELSE
BEGIN
    SET IDENTITY_INSERT categories ON;
    INSERT INTO categories (CategoryId, CategoryName, Images, status)
    VALUES (1, N'Apple (iPhone)', N'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=600&q=80', 1);
    SET IDENTITY_INSERT categories OFF;
END;

IF NOT EXISTS (SELECT 1 FROM categories WHERE CategoryName = N'Samsung Galaxy')
BEGIN
    INSERT INTO categories (CategoryName, Images, status)
    VALUES (N'Samsung Galaxy', N'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=600&q=80', 1);
END;

IF NOT EXISTS (SELECT 1 FROM categories WHERE CategoryName = N'Xiaomi')
BEGIN
    INSERT INTO categories (CategoryName, Images, status)
    VALUES (N'Xiaomi', N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1);
END;

IF NOT EXISTS (SELECT 1 FROM categories WHERE CategoryName = N'OPPO')
BEGIN
    INSERT INTO categories (CategoryName, Images, status)
    VALUES (N'OPPO', N'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=600&q=80', 1);
END;

IF NOT EXISTS (SELECT 1 FROM categories WHERE CategoryName = N'Vivo')
BEGIN
    INSERT INTO categories (CategoryName, Images, status)
    VALUES (N'Vivo', N'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=600&q=80', 1);
END;
GO

-- 2. XÓA DỮ LIỆU CŨ TRONG BẢNG PRODUCTS ĐỂ ID BẮT ĐẦU CHUẨN XÁC TỪ 1 ĐẾN 50
TRUNCATE TABLE products;
GO

-- 3. NẠP 50 SẢN PHẨM ĐIỆN THOẠI
DECLARE @catApple INT = (SELECT TOP 1 CategoryId FROM categories WHERE CategoryName LIKE N'%Apple%' OR CategoryName LIKE N'%iPhone%');
DECLARE @catSamsung INT = (SELECT TOP 1 CategoryId FROM categories WHERE CategoryName LIKE N'%Samsung%');
DECLARE @catXiaomi INT = (SELECT TOP 1 CategoryId FROM categories WHERE CategoryName LIKE N'%Xiaomi%');
DECLARE @catOppo INT = (SELECT TOP 1 CategoryId FROM categories WHERE CategoryName LIKE N'%OPPO%');
DECLARE @catVivo INT = (SELECT TOP 1 CategoryId FROM categories WHERE CategoryName LIKE N'%Vivo%');

-- ====== NHÓM 1: APPLE (IPHONE) - 15 SẢN PHẨM ======
INSERT INTO products (productName, description, price, images, status, createDate, categoryId) VALUES
(N'iPhone 16 Pro Max 256GB', 
 N'Màn hình Super Retina XDR OLED 6.9 inch 120Hz. Chip Apple A18 Pro 3nm mạnh mẽ nhất. Camera chính 48MP Fusion, Telephoto 5x. Khung viền Titan sa mạc đẳng cấp, pin 4685 mAh, sạc nhanh MagSafe 25W.', 
 34990000, N'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -10, GETDATE()), @catApple),

(N'iPhone 16 Pro 128GB', 
 N'Màn hình Super Retina XDR OLED 6.3 inch 120Hz ProMotion. Chip Apple A18 Pro, Nút Camera Control cảm ứng lực mới. Camera 48MP, quay video 4K 120fps Dolby Vision, cổng USB-C chuẩn 3.0.', 
 28990000, N'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -20, GETDATE()), @catApple),

(N'iPhone 16 Plus 128GB', 
 N'Màn hình lớn 6.7 inch Super Retina XDR OLED. Chip Apple A18 tiết kiệm điện năng vượt trội. Cụm camera kép 48MP 2x zoom quang, hỗ trợ chụp ảnh không gian Spatial Photos.', 
 25990000, N'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -30, GETDATE()), @catApple),

(N'iPhone 16 128GB', 
 N'Thiết kế cụm camera dọc tinh tế, màn hình OLED 6.1 inch. Chip A18 thế hệ mới, phím tác vụ Action Button và Camera Control. Mặt kính pha màu siêu bền, hỗ trợ Apple Intelligence.', 
 22490000, N'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -40, GETDATE()), @catApple),

(N'iPhone 15 Pro Max 256GB', 
 N'Khung viền Titan tự nhiên siêu nhẹ và bền. Chip Apple A17 Pro hỗ trợ Ray Tracing đồ họa game đỉnh cao. Camera tiềm vọng 5x zoom quang học, màn hình Dynamic Island 120Hz ProMotion.', 
 29490000, N'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -50, GETDATE()), @catApple),

(N'iPhone 15 Pro 128GB', 
 N'Màn hình 6.1 inch OLED 120Hz, viền màn hình siêu mỏng. Chip A17 Pro, camera 48MP chi tiết vượt trội. Cổng sạc USB-C tốc độ cao, pin tối ưu cho cả ngày dài làm việc.', 
 24990000, N'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -60, GETDATE()), @catApple),

(N'iPhone 15 Plus 128GB', 
 N'Màn hình 6.7 inch Super Retina XDR với Dynamic Island thông minh. Camera chính nâng cấp lên 48MP. Thời lượng pin cực trâu lên tới 26 giờ phát video liên tục.', 
 22190000, N'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -70, GETDATE()), @catApple),

(N'iPhone 15 128GB', 
 N'Màn hình Dynamic Island hiện đại, mặt lưng kính nhám sang trọng. Chip A16 Bionic mượt mà, camera kép 48MP chụp đêm ấn tượng, kết nối USB-C tiện lợi.', 
 19490000, N'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -80, GETDATE()), @catApple),

(N'iPhone 14 Pro Max 128GB', 
 N'Đột phá với màn hình Dynamic Island đầu tiên, Always-On Display. Chip A16 Bionic 6 nhân, cảm biến camera 48MP, quay video chế độ điện ảnh Cinematic 4K.', 
 26490000, N'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -90, GETDATE()), @catApple),

(N'iPhone 14 Pro 128GB', 
 N'Kích thước 6.1 inch nhỏ gọn, viền thép không gỉ sáng bóng. Màn hình ProMotion 120Hz, tính năng Dynamic Island đa nhiệm, camera chuyên nghiệp 3 ống kính.', 
 22990000, N'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -100, GETDATE()), @catApple),

(N'iPhone 14 Plus 128GB', 
 N'Màn hình lớn 6.7 inch chuẩn điện ảnh, trọng lượng siêu nhẹ. Chip A15 Bionic 5 nhân GPU, pin cực khỏe dùng trọn vẹn 2 ngày cho tác vụ cơ bản.', 
 18990000, N'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -110, GETDATE()), @catApple),

(N'iPhone 14 128GB', 
 N'Thiết kế nhôm nguyên khối bền bỉ, màn hình Retina OLED sắc nét. Camera selfie tự động lấy nét TrueDepth, tính năng phát hiện va chạm Crash Detection an toàn.', 
 16990000, N'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -120, GETDATE()), @catApple),

(N'iPhone 13 128GB', 
 N'Chiếc iPhone quốc dân bán chạy nhất. Màn hình Super Retina XDR sắc sảo, chip A15 Bionic bền bỉ. Camera kép đặt chéo độc đáo, chống rung cảm biến Sensor-Shift.', 
 13790000, N'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -130, GETDATE()), @catApple),

(N'iPhone 12 64GB', 
 N'Khởi đầu thiết kế viền vuông sang trọng, màn hình OLED sắc màu rực rỡ. Chip A14 Bionic tốc độ cao, hỗ trợ mạng 5G siêu tốc và sạc không dây MagSafe.', 
 11490000, N'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -140, GETDATE()), @catApple),

(N'iPhone 11 64GB', 
 N'Giá cực kỳ dễ tiếp cận cho học sinh sinh viên. Màn hình Liquid Retina 6.1 inch, camera kép góc siêu rộng 120 độ, pin dung lượng cao đáp ứng trọn vẹn cả ngày.', 
 8490000, N'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -150, GETDATE()), @catApple);

-- ====== NHÓM 2: SAMSUNG GALAXY - 15 SẢN PHẨM ======
INSERT INTO products (productName, description, price, images, status, createDate, categoryId) VALUES
(N'Samsung Galaxy S24 Ultra 5G 256GB', 
 N'Khung viền Titan bền bỉ, tích hợp bút S-Pen quyền năng. Màn hình Dynamic AMOLED 2X 6.8 inch phẳng chống chói. Chip Snapdragon 8 Gen 3 for Galaxy, Galaxy AI thông minh toàn diện, camera 200MP zoom 100x.', 
 29990000, N'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -160, GETDATE()), @catSamsung),

(N'Samsung Galaxy S24+ 5G 256GB', 
 N'Màn hình 6.7 inch Quad HD+ 120Hz siêu sáng 2600 nits. Trợ lý trí tuệ nhân tạo Galaxy AI phiên dịch trực tiếp. Camera 50MP chuyên nghiệp, pin lớn 4900 mAh kèm sạc nhanh 45W.', 
 22990000, N'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -170, GETDATE()), @catSamsung),

(N'Samsung Galaxy S24 5G 256GB', 
 N'Thiết kế nhỏ gọn sang trọng viền nhôm Armor Aluminum. Màn hình 6.2 inch AMOLED 120Hz mượt mà. Hệ sinh thái Galaxy AI đa năng, hiệu năng đỉnh cao xử lý mọi tác vụ.', 
 17990000, N'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -180, GETDATE()), @catSamsung),

(N'Samsung Galaxy Z Fold6 5G 256GB', 
 N'Tuyệt tác màn hình gập mỏng nhẹ nhất dòng Fold, kháng nước kháng bụi IP48. Màn hình trong 7.6 inch, màn hình phụ 6.3 inch. Chip Snapdragon 8 Gen 3, hỗ trợ Galaxy AI đa màn hình.', 
 41990000, N'https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -190, GETDATE()), @catSamsung),

(N'Samsung Galaxy Z Flip6 5G 256GB', 
 N'Điện thoại gập vỏ sò thời thượng, màn hình phụ FlexWindow 3.4 inch độc đáo. Camera nâng cấp 50MP sắc nét, tản nhiệt buồng hơi Vapor Chamber lần đầu xuất hiện trên dòng Flip, pin 4000 mAh.', 
 26990000, N'https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -200, GETDATE()), @catSamsung),

(N'Samsung Galaxy S23 Ultra 5G 256GB', 
 N'Camera 200MP bắt trọn màn đêm Nightography, zoom quang học 10x và Space Zoom 100x. Chip Snapdragon 8 Gen 2 for Galaxy tối ưu hóa chơi game mượt mà, bút S-Pen gắn trong thân máy.', 
 21990000, N'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -210, GETDATE()), @catSamsung),

(N'Samsung Galaxy S23 FE 5G 128GB', 
 N'Phiên bản Fan Edition chuẩn Flagship với giá tốt. Màn hình Dynamic AMOLED 2X 6.4 inch 120Hz, camera chính 50MP chống rung OIS, khung viền kim loại cao cấp và chuẩn kháng nước IP68.', 
 12490000, N'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -220, GETDATE()), @catSamsung),

(N'Samsung Galaxy Z Fold5 5G 256GB', 
 N'Bản lề Flex gập không khe hở tinh tế. Màn hình lớn mở ra không gian làm việc đa nhiệm tới 3 ứng dụng cùng lúc. Hiệu năng đỉnh cao Snapdragon 8 Gen 2, độ sáng tối đa 1750 nits.', 
 32990000, N'https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -230, GETDATE()), @catSamsung),

(N'Samsung Galaxy Z Flip5 5G 128GB', 
 N'Màn hình ngoài Flex Window 3.4 inch đa năng xem thông báo, trả lời tin nhắn không cần mở máy. Thiết kế gập nhỏ gọn bỏ vừa túi áo, màu sắc trẻ trung phong cách.', 
 16490000, N'https://images.unsplash.com/photo-1585060544812-6b45742d762f?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -240, GETDATE()), @catSamsung),

(N'Samsung Galaxy A55 5G 8GB/128GB', 
 N'Thiết kế khung viền kim loại và mặt lưng kính Gorilla Glass Victus+ cao cấp. Chip Exynos 1480 có GPU đồ họa AMD RDNA. Màn hình Super AMOLED 6.6 inch 120Hz, bảo mật Samsung Knox Vault.', 
 9690000, N'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -250, GETDATE()), @catSamsung),

(N'Samsung Galaxy A35 5G 8GB/128GB', 
 N'Màn hình tràn viền Infinity-O 6.6 inch 120Hz sống động. Camera 50MP chống rung OIS cho video cực kỳ ổn định. Kháng nước kháng bụi IP67 chuẩn mực, pin 5000 mAh bền bỉ.', 
 7690000, N'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -260, GETDATE()), @catSamsung),

(N'Samsung Galaxy A25 5G 6GB/128GB', 
 N'Màn hình Super AMOLED 6.5 inch 120Hz sắc nét rực rỡ, độ sáng 1000 nits. Camera chính 50MP OIS, loa kép âm thanh vòm Stereo Dolby Atmos sống động, pin 5000 mAh sạc nhanh 25W.', 
 6290000, N'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -270, GETDATE()), @catSamsung),

(N'Samsung Galaxy A15 5G 8GB/128GB', 
 N'Kết nối mạng 5G tốc độ cao trong tầm giá phổ thông. Màn hình Super AMOLED 90Hz mượt mắt. Chip MediaTek Dimensity 6100+, viên pin 5000 mAh dùng thoải mái 2 ngày.', 
 4990000, N'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -280, GETDATE()), @catSamsung),

(N'Samsung Galaxy A05s 4GB/128GB', 
 N'Lựa chọn hàng đầu cho phân khúc giá rẻ. Màn hình lớn 6.7 inch Full HD+ 90Hz, vi xử lý Snapdragon 680 ổn định, camera 50MP chi tiết rõ nét và pin 5000 mAh.', 
 3590000, N'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -290, GETDATE()), @catSamsung),

(N'Samsung Galaxy M54 5G 8GB/256GB', 
 N'Dung lượng pin khủng 6000 mAh dùng xả láng không lo sạc. Màn hình Super AMOLED Plus 6.7 inch 120Hz mỏng nhẹ. Camera chống rung OIS 108MP chụp ảnh siêu nét.', 
 8990000, N'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -300, GETDATE()), @catSamsung);

-- ====== NHÓM 3: XIAOMI - 10 SẢN PHẨM ======
INSERT INTO products (productName, description, price, images, status, createDate, categoryId) VALUES
(N'Xiaomi 14 Ultra 5G 512GB', 
 N'Đỉnh cao nhiếp ảnh di động hợp tác cùng Leica. Hệ thống 4 camera 50MP cảm biến 1 inch khẩu độ vô cấp F1.63-F4.0. Chip Snapdragon 8 Gen 3, màn hình AMOLED 2K 120Hz 3000 nits, sạc 90W.', 
 29990000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -310, GETDATE()), @catXiaomi),

(N'Xiaomi 14 5G 256GB', 
 N'Flagship nhỏ gọn cầm nắm hoàn hảo, ống kính quang học Leica Summilux cao cấp. Màn hình OLED CrystalRes 120Hz viền siêu mỏng, chip Snapdragon 8 Gen 3, sạc siêu tốc HyperCharge 90W.', 
 19990000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -320, GETDATE()), @catXiaomi),

(N'Xiaomi 13T Pro 5G 512GB', 
 N'Ống kính chuyên nghiệp Leica, màn hình CrystalRes AMOLED 144Hz siêu mượt. Vi xử lý MediaTek Dimensity 9200+ 4nm cực mạnh, công nghệ sạc thần tốc 120W nạp đầy pin chỉ 19 phút.', 
 14990000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -330, GETDATE()), @catXiaomi),

(N'Xiaomi 13T 5G 256GB', 
 N'Nhiếp ảnh Leica trong phân khúc cận cao cấp. Màn hình AMOLED 1.5K 144Hz sống động, chip Dimensity 8200-Ultra, kháng nước IP68, pin 5000 mAh và sạc nhanh Turbo Charge 67W.', 
 10990000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -340, GETDATE()), @catXiaomi),

(N'Redmi Note 13 Pro+ 5G 256GB', 
 N'Màn hình cong AMOLED 1.5K 120Hz tuyệt đẹp, mặt lưng giả da sang trọng. Camera khủng 200MP chống rung OIS, chuẩn kháng nước bụi IP68, chip Dimensity 7200-Ultra, sạc 120W siêu tốc.', 
 9990000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -350, GETDATE()), @catXiaomi),

(N'Redmi Note 13 Pro 4G 128GB', 
 N'Camera 200MP siêu rõ nét phân khúc tầm trung. Màn hình AMOLED 120Hz viền siêu mỏng, chip MediaTek Helio G99-Ultra, loa kép Dolby Atmos, pin 5000 mAh sạc nhanh 67W.', 
 6490000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -360, GETDATE()), @catXiaomi),

(N'Redmi Note 13 6GB/128GB', 
 N'Vua phân khúc giá rẻ với màn hình AMOLED 120Hz sắc nét. Camera chính 108MP 3x zoom chất lượng cao, chip Snapdragon 685 mát mẻ tiết kiệm điện, pin 5000 mAh kèm sạc 33W.', 
 4490000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -370, GETDATE()), @catXiaomi),

(N'Redmi 13C 4GB/128GB', 
 N'Thiết kế trẻ trung mặt lưng bóng bẩy. Màn hình lớn 6.74 inch 90Hz bảo vệ mắt chứng nhận TÜV Rheinland, camera AI 50MP, pin trâu 5000 mAh dùng cả ngày.', 
 2890000, N'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -380, GETDATE()), @catXiaomi),

(N'POCO F6 Pro 5G 512GB', 
 N'Cỗ máy gaming đỉnh cao trang bị chip Snapdragon 8 Gen 2, tản nhiệt LiquidCool 4.0 buồng hơi IceLoop. Màn hình WQHD+ 120Hz 4000 nits, sạc HyperCharge 120W.', 
 14490000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -390, GETDATE()), @catXiaomi),

(N'POCO X6 Pro 5G 256GB', 
 N'Hiệu năng dẫn đầu phân khúc với chip Dimensity 8300-Ultra đạt hơn 1.4 triệu điểm AnTuTu. Màn hình AMOLED CrystalRes 1.5K 120Hz, hệ điều hành Xiaomi HyperOS mượt mà.', 
 8990000, N'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -400, GETDATE()), @catXiaomi);

-- ====== NHÓM 4: OPPO - 6 SẢN PHẨM ======
INSERT INTO products (productName, description, price, images, status, createDate, categoryId) VALUES
(N'OPPO Find N3 5G 512GB', 
 N'Kiệt tác điện thoại gập mỏng nhẹ cao cấp nhất của OPPO. Bản lề uốn linh hoạt nếp gấp gần như vô hình. Hệ thống camera Hasselblad đỉnh cao, chip Snapdragon 8 Gen 2, sạc nhanh SUPERVOOC 67W.', 
 41990000, N'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -410, GETDATE()), @catOppo),

(N'OPPO Find N3 Flip 5G 256GB', 
 N'Điện thoại gập dọc trang bị 3 camera Hasselblad đầu tiên trên thế giới. Màn hình ngoài trực quan đa ứng dụng, bản lề giọt nước siêu bền, sạc nhanh SUPERVOOC 44W.', 
 19990000, N'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -420, GETDATE()), @catOppo),

(N'OPPO Reno12 Pro 5G 512GB', 
 N'Chuyên gia chân dung AI với các tính năng xóa vật thể AI Eraser, tách nền thông minh. Màn hình vô cực 4 cạnh cong 120Hz, camera selfie 50MP tự động lấy nét, sạc 80W.', 
 17990000, N'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -430, GETDATE()), @catOppo),

(N'OPPO Reno12 5G 256GB', 
 N'Thiết kế dòng chảy bạc tương lai chống va đập chuẩn quân đội. Kết nối không cần mạng BeaconLink, chip Dimensity 7300-Energy, pin 5000 mAh và sạc siêu tốc 80W.', 
 12490000, N'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -440, GETDATE()), @catOppo),

(N'OPPO Reno11 F 5G 256GB', 
 N'Mặt lưng vân kim sa lấp lánh hút mắt, chuẩn kháng nước IP65. Màn hình AMOLED 120Hz không viền, camera siêu nét 64MP, pin 5000 mAh sạc SUPERVOOC 67W.', 
 8490000, N'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -450, GETDATE()), @catOppo),

(N'OPPO A79 5G 256GB', 
 N'Thiết kế lông vũ phát sáng thời thượng, loa kép công suất 300% siêu lớn. Màn hình FHD+ 90Hz sắc nét, kết nối 5G mượt mà, pin 5000 mAh sạc nhanh 33W.', 
 6990000, N'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -460, GETDATE()), @catOppo);

-- ====== NHÓM 5: VIVO - 4 SẢN PHẨM ======
INSERT INTO products (productName, description, price, images, status, createDate, categoryId) VALUES
(N'Vivo X100 Pro 5G 512GB', 
 N'Chuẩn mực nhiếp ảnh chuyên nghiệp cùng ZEISS. Cảm biến 1 inch Sony IMX989, ống kính tiềm vọng ZEISS APO đạt tiêu chuẩn quang học cao nhất. Chip Dimensity 9300, sạc nhanh 100W.', 
 22990000, N'https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -470, GETDATE()), @catVivo),

(N'Vivo V30 Pro 5G 512GB', 
 N'Đột phá với đèn Aura Light điều chỉnh nhiệt độ màu thông minh và bộ 3 camera sau 50MP tinh chỉnh bởi ZEISS. Thiết kế siêu mỏng nhẹ 7.45mm, màn hình cong 3D 1.5K 120Hz.', 
 15990000, N'https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -480, GETDATE()), @catVivo),

(N'Vivo V30e 5G 256GB', 
 N'Màn hình cong 3D AMOLED 120Hz thời thượng, camera chân dung cảm biến Sony IMX882 sắc nét cùng vòng sáng Aura 2.0. Pin siêu trâu 5500 mAh mỏng nhẹ nhất phân khúc.', 
 9490000, N'https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -490, GETDATE()), @catVivo),

(N'Vivo Y200 5G 128GB', 
 N'Màn hình AMOLED 120Hz siêu sáng 1200 nits, chip Snapdragon 4 Gen 2 5G mát mẻ, chuẩn kháng nước bụi IP54, loa stereo kép sống động và sạc siêu tốc 80W.', 
 6790000, N'https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=600&q=80', 1, DATEADD(minute, -500, GETDATE()), @catVivo);

GO

-- =========================================================================
-- KIỂM TRA TỔNG KẾT SAU KHI NẠP DỮ LIỆU
-- =========================================================================
SELECT c.CategoryId, c.CategoryName, COUNT(p.productId) AS SoLuongSanPham
FROM categories c
LEFT JOIN products p ON c.CategoryId = p.categoryId
GROUP BY c.CategoryId, c.CategoryName
ORDER BY c.CategoryId;

SELECT COUNT(*) AS TongSoLuongSanPham FROM products;
GO
