
CREATE DATABASE SMARTCARE_PROJECT;
USE SMARTCARE_PROJECT;

-- Bảng users (Người dùng)
CREATE TABLE users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(255) UNIQUE NOT NULL,
    hashed_password NVARCHAR(255) NOT NULL,
    first_name NVARCHAR(255),
    last_name NVARCHAR(255),
    phone NVARCHAR(20) UNIQUE,
    mail NVARCHAR(255) UNIQUE,
    date_created DATETIME DEFAULT GETDATE(),
    date_modified DATETIME DEFAULT GETDATE(),
    role NVARCHAR(50) NOT NULL DEFAULT 'customer'
);

--  Bảng user_address (Địa chỉ người dùng)
CREATE TABLE user_address (
    address_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    address_line1 NVARCHAR(255),
    address_line2 NVARCHAR(255),
    city NVARCHAR(100),
    country NVARCHAR(100),
    telephone NVARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng user_payment (Thanh toán của người dùng)
CREATE TABLE user_payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    payment_type NVARCHAR(50),
    account_no NVARCHAR(50),
    expiry DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng product_category (Danh mục sản phẩm)
CREATE TABLE product_category (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL UNIQUE,
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE()
);

-- Bảng product_original (Xuất xứ sản phẩm)
CREATE TABLE product_original (
    origin_id INT PRIMARY KEY IDENTITY(1,1),
    name_country NVARCHAR(255) NOT NULL UNIQUE
);

--  Bảng product_packaging (Loại đóng gói)
CREATE TABLE product_packaging (
    packaging_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL UNIQUE,
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE()
);

-- Bảng product_discount (Giảm giá)
CREATE TABLE product_discount (
    discount_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255),
    description NVARCHAR(MAX),
    discount_percent DECIMAL(10,2) CHECK (discount_percent >= 0 AND discount_percent <= 100),
    active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE()
);

-- Bảng products (Sản phẩm chính)
CREATE TABLE products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name_product NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    SKU NVARCHAR(50) UNIQUE NOT NULL,
    category_id INT NULL,
    packaging_id INT NULL,
    price DECIMAL(10,2) CHECK (price >= 0),
    discount_id INT NULL,
    origin_id INT NULL,
    ingredient NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE(),
    state BIT DEFAULT 1,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (packaging_id) REFERENCES product_packaging(packaging_id) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (discount_id) REFERENCES product_discount(discount_id) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (origin_id) REFERENCES product_original(origin_id) 
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Bảng product_inventory (Kho hàng)
CREATE TABLE product_inventory (
    inventory_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT NOT NULL UNIQUE,
    quantity INT NOT NULL CHECK (quantity >= 0),
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng product_images (Hình ảnh sản phẩm)
CREATE TABLE product_images (
    image_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT NOT NULL,
    image_url NVARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng shopping_session (Giỏ hàng)
CREATE TABLE shopping_session (
    session_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NULL,
    total DECIMAL(10,2) DEFAULT 0 CHECK (total >= 0),
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) 
        ON DELETE SET NULL ON UPDATE CASCADE
);

--  Bảng cart_item (Sản phẩm trong giỏ hàng)
CREATE TABLE cart_item (
    cart_item_id INT PRIMARY KEY IDENTITY(1,1),
    session_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (session_id) REFERENCES shopping_session(session_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
update cart_item set check (quantity >=0);

CREATE TABLE order_details (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NULL,  -- Cho phép NULL nếu dùng SET NULL
    total DECIMAL(10,2) CHECK (total >= 0),
    payment_id INT NULL,
    status NVARCHAR(50) DEFAULT 'Chờ xác nhận',
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ,
    FOREIGN KEY (payment_id) REFERENCES user_payment(payment_id) 
	);

--  Bảng order_items (Sản phẩm trong đơn hàng)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES order_details(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng payment_details (Chi tiết thanh toán)
CREATE TABLE payment_details (
    payment_detail_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    amount DECIMAL(10,2) CHECK (amount >= 0),
    provider NVARCHAR(100),
    status NVARCHAR(20) DEFAULT 'pending',
    created_at DATETIME DEFAULT GETDATE(),
    modified_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES order_details(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO product_category (name, description) VALUES
(N'Thực phẩm chức năng', N'Các sản phẩm thực phẩm chức năng hỗ trợ sức khỏe'),
(N'Thiết Bị Y Tế', N'Các thiết bị y tế hỗ trợ chăm sóc sức khỏe'),
(N'Dược mỹ phẩm', N'Các sản phẩm dược mỹ phẩm hỗ trợ chăm sóc sức khỏe và sắc đẹp'),
(N'Chăm sóc cá nhân', N'Sản phẩm hỗ trợ vệ sinh cá nhân và chăm sóc sức khỏe hàng ngày'),
(N'Thuốc', N'Các loại thuốc chữa bệnh, hỗ trợ điều trị và bảo vệ sức khỏe');
INSERT INTO product_original (name_country) VALUES
(N'Hoa Kỳ'),
(N'Việt Nam'),
(N'Pháp'),
(N'Singapore'),
(N'Bulgaria'),
(N'Nhật Bản'),
(N'Trung Quốc'),
(N'Hàn Quốc'),
(N'Đài Loan'),
(N'Ý'),
(N'Đức'),
(N'Thụy Điển'),
(N'Liên Bang Nga'),
(N'Ấn Độ'),
(N'Pakistan'),
(N'Thái Lan'),
(N'Moldova'),
(N'Hy Lạp'),
(N'Úc');



INSERT INTO product_discount (name, description, discount_percent) VALUES
(N'Khuyến mãi 10%', N'Giảm giá 10% cho các sản phẩm', 10);


INSERT INTO product_packaging (name, description) VALUES
(N'Hộp', N'Đóng gói trong hộp giấy hoặc nhựa'),
(N'Tuýp', N'Đóng gói trong tuýp nhựa'),
(N'Chai', N'Đựng trong chai thủy tinh hoặc nhựa'),
(N'Gói', N'Đóng gói trong túi nhựa hoặc giấy bạc'),
(N'Cái','Đơn vị đếm những món đồ lẻ');



INSERT INTO products (name_product, description, SKU, category_id, packaging_id, price, discount_id, origin_id, ingredient) VALUES
(N'Viên uống NutriGrow Nutrimed bổ sung canxi, vitamin D3, vitamin K2, hấp thu canxi (60 viên)', 
 N'Nutrigrow bổ sung canxi, vitamin D3, vitamin K2, giúp tăng cường hấp thu canxi, giúp xương chắc khỏe. Hỗ trợ phát triển chiều cao cho trẻ.', 
 N'5809/2022/ĐKSP', 1, 1, 480000, 1, 1, 
 N'Calcium Citrate, Calcium Carbonate, Vitamin D3, Vitamin K2, Dibasic Calcium Phosphate, Magie oxide, Kẽm oxide, boron citrate, Đồng Oxit'),

(N'Siro Canxi + D3K2 Hatro bổ sung canxi giúp xương, răng chắc khỏe (120ml)', 
 N'Siro Canxi + D3K2 Hatro bổ sung canxi giúp xương, răng chắc khoẻ. Giúp giảm nguy cơ loãng xương ở người cao tuổi, bổ sung canxi cho phụ nữ có thai, cho con bú.', 
 N'4455/2022/ĐKSP', 1, 3, 144000, 1, 2, 
 N'Lipocal, Vitamin D3, Vitamin K2 MK7'),

(N'Viên uống Dr. Caci Ocavill giúp xương và răng chắc khỏe (60 viên)', 
 N'Dr.Caci Ocavill bổ sung canxi, magie, vitamin D3 và vitamin K2 MK-7 cho cơ thể, giúp xương và răng chắc khỏe. Hỗ trợ trẻ em, thanh thiếu niên trong giai đoạn phát triển. Hỗ trợ giảm nguy cơ loãng xương ở người lớn.', 
 N'3/2022/ĐKSP', 1, 1, 570000, 1, 3, 
 N'Canxi bisglycinate, Vitamin D3, Vitamin K2, Magie oxide'),

(N'Viên uống Mega-Cal 1000 Vitamins For Life giúp bổ sung canxi, chống loãng xương (60 viên)', 
 N'Mega-Cal 1000 giúp bổ sung canxi, vitamin D3 và vitamin K2 cho cơ thể, giúp xương và răng chắc khỏe. Hỗ trợ phát triển chiều cao ở trẻ em, thanh thiếu niên. Hỗ trợ giảm nguy cơ loãng xương ở người lớn.', 
 N'344/2021/ĐKSP', 1, 1, 320000, 1, 1, 
 N'Vitamin D3, Vitamin A, Magnesium, Calcium, Vitamin C, Vitamin K2'),

(N'Viên sủi Kudos Kids Multivitamins Plus Calcium & D3 hương dưa hấu giúp bổ sung calci và vitamin cho cơ thể (20 viên)', 
 N'Kudos Kids Multivitamins Plus Calcium & D3 hương dưa hấu giúp bổ sung canxi và vitamin (A, C, D3, E, B1, B2, B3, B5, B6, B8, B9, B12) thiết yếu cho cơ thể.', 
 N'3805/2023/ĐKSP', 1, 2, 135150, 1, 4, 
 N'Calci carbonat, Vitamin C, Niacin, Vitamin E, Acid pantothenic, Vitamin B6, Vitamin B2, Vitamin B1, Vitamin A, Acid folic, Biotin, Vitamin D3, Vitamin B12'),

(N'Viên sủi Kudos Daily Vitamins Plus Biotin & Ginseng hương cam giúp bổ sung vitamin cho cơ thể (20 viên)', 
 N'Kudos Daily Vitamins Plus Biotin & Ginseng hương cam giúp bổ sung vitamin (A, C, D, E, B1, B2, B3, B5, B6, B8, B9, B12) cho cơ thể.', 
 N'3806/2023/ĐKSP', 1, 2, 118150, 1, 4, 
 N'Vitamin C, Chiết xuất nhân sâm, Niacin, Vitamin E, Acid pantothenic, Vitamin B2, Vitamin B6, Vitamin B1, Vitamin A, Acid folic, Biotin, Vitamin D3, Vitamin B12'),

(N'Dung dịch Feginic bổ sung sắt cho người thiếu máu do thiếu sắt (4 vỉ x 5 ống x 5ml)', 
 N'Feginic giúp bổ sung sắt hữu cơ, hỗ trợ giảm nguy cơ thiếu máu ở phụ nữ có thai, cho con bú, trẻ em tuổi dậy thì, phụ nữ trong thời kỳ kinh nguyệt do thiếu sắt.', 
 N'292/2018/ĐKSP', 1, 1, 108000, 1, 2, 
 N'Sắt, Inulin, Acid folic, Vitamin B12, Vitamin B6'),
(N'Viên uống Multivitamin +Zn +D3 Royal Care hỗ trợ tăng cường sức khỏe, nâng cao sức đề kháng (60 viên)', 
 N'Multivitamin +Zn +D3 Royal Care hỗ trợ tăng cường sức khỏe, nâng cao sức đề kháng, giảm mệt mỏi.', 
 N'2081/2022/ĐKSP', 1, 1, 175000, 1, 2, 
 N'Vitamin B1, Vitamin C, Aquamin F, Kẽm Gluconat, Đông trùng hạ thảo, Magnesium oxide, Thái tử sâm, Vitamin E, Vitamin PP, Iron ferronyl, Vitamin H, Vitamin B6, Vitamin B5, Mangan gluconat, Crom picolinat, Selen 2000ppm, Vitamin K, Vitamin B9, Vitamin B12, Vitamin A, Vitamin D3, Vitamin B2'),

(N'Viên uống Omexxel 3-6-9 Premium hỗ trợ tốt cho não và mắt (100 viên)', 
 N'Omexxel 3-6-9 Premium hỗ trợ tốt cho não và mắt.', 
 N'6800/2023/ĐKSP', 1, 1, 453000, 1, 1, 
 N'Omega 3, Omega 6, Omega 9, Tinh dầu tỏi, Vitamin A, Vitamin E'),

(N'Viên uống Rama Bổ Phổi hỗ trợ bổ phổi, giảm ho (30 viên)', 
 N'Rama Bổ Phổi hỗ trợ bổ phổi, hỗ trợ giảm ho, giảm đờm, giảm đau rát họng, khản tiếng do viêm họng, viêm phế quản.', 
 N'1714/2022/ĐKSP', 1, 1, 132000, 1, 2, 
 N'Cao hỗn hợp thảo mộc, Chiết xuất Mạch môn, chiết xuất cúc tím, Chiết xuất gừng, Chiết xuất xuyên tâm liên, Chiết xuất Trần bì, Chiết xuất Huyết giác, Chiết xuất Đông trùng hạ thảo, Vitamin C, Fucoidan 80%'),

(N'Nước giải rượu bia Ladodetox Nosamin Ladophar hỗ trợ giải rượu, bia, giảm khó chịu (10 gói x 15ml)', 
 N'Ladodetox Nosamin hỗ trợ giải rượu, bia, giảm khó chịu do rượu, bia. Hỗ trợ bảo vệ tế bào gan.', 
 N'1474/2019/ĐKSP', 1, 1, 390000, 1, 2, 
 N'Dịch chiết trà xanh, Cao đặc Ưng bất bạc, Cao đặc hoa Actisô, Cao đặc lá Actisô, Đảng Sâm'),

(N'Siro Ginkid GINIC thanh nhiệt mát gan (4 vỉ x 5 ống x 10ml)', 
 N'Ginkid Thanh Nhiệt Mát Gan giúp thanh nhiệt, giải độc gan, mát gan, hỗ trợ tăng cường chức năng gan. Hỗ trợ giảm các triệu chứng như dị ứng, mẩn ngứa, nổi mày đay, mụn nhọt do chức năng gan kém.', 
 N'71/2020/ĐKSP', 1, 1, 92000, 1, 2, 
 N'Thổ phục linh, Rau má, Sài đất, Bồ Công Anh, Thương nhĩ tử, Cam thảo, Chiết xuất Actisô, Kim ngân hoa'),

(N'Viên uống Si-Liver Naga Vesta giúp tăng cường miễn dịch, phục hồi và bảo vệ gan (60 viên)', 
 N'Si-Liver Naga với sự kết hợp của các thành phần Cao Artiso, Cao Cà gai leo, Milk thistle, Curcumin nano, Vitamin C, L-Carnitin, DL-methionin giúp tăng cường miễn dịch, phục hồi và bảo vệ gan. Giúp bảo vệ và phục hồi tế bào gan.', 
 N'747/2019/ÐKSP', 1, 1, 225000, 1, 2, 
 N'DL-Methionine, Artiso, Nano Curcumin, Milk thistle, L-Carnitine, Cao cà gai leo'),

(N'Viên uống SkillMax Ocavill hỗ trợ tăng cường thị lực, cải thiện các triệu chứng khô mắt, mỏi mắt (2 vỉ x 15 viên)', 
 N'SkillMax Ocavill hỗ trợ tăng cường thị lực, hỗ trợ cải thiện các triệu chứng khô mắt, mỏi mắt. Hỗ trợ giảm nguy cơ đục thủy tinh thể và thoái hóa điểm vàng.', 
 N'9658/2021/ĐKSP', 1, 1, 670000, 1, 5, 
 N'Dầu nhuyễn thể, Lutein, Zeaxanthin, Vitamin A, Eicosapentaenoic acid, Astaxanthin, Phospholipids'),

(N'Viên uống Kaki Ekisu Tohchukasou Kenkan hỗ trợ tăng cường sinh lý nam giới (60 viên)', 
 N'Kenkan Kaki Ekisu Tohchukasou hỗ trợ tăng cường sinh lý nam giới.', 
 N'5400/2022/ĐKSP', 1, 1, 515000, 1, 6, 
 N'Chiết xuất bột Maca, Chiết xuất nấm men, Bột chiết xuất nấm đông trùng hạ thảo, Bột chiết xuất từ thịt hàu'),

(N'Viên uống LéAna Ocavill hỗ trợ cân bằng nội tiết tố (60 viên)', 
 N'Léana Ocavill hỗ trợ cân bằng nội tiết tố. Hỗ trợ cải thiện các triệu chứng thời kỳ tiền mãn kinh, mãn kinh do suy giảm nội tiết tố. Hỗ trợ hạn chế quá trình lão hóa, giúp đẹp da.', 
 N'9677/2021/ĐKSP', 1, 1, 544000, 1, 5, 
 N'Tinh dầu hoa anh thảo, Vitamin E, Nhân Sâm, Lepidium meyenii, Trinh nữ'),

(N'Viên uống Bifido Plus Jpanwell bổ sung các lợi khuẩn tăng cường sức khỏe đại tràng (30 viên)', 
 N'Bifido Plus bổ sung lợi khuẩn tăng cường sức khỏe đại tràng; giúp giảm thiểu các chứng bệnh hay mắc ở đại tràng. Giảm nguy cơ rối loạn tiêu hóa, cải thiện các triệu chứng ăn uống kém, đầy hơi, khó tiêu, chướng bụng và táo bón.', 
 N'9918/2021/ÐKSP', 1, 1, 990000, 1, 6, 
 N'Chất xơ hòa tan, oligosaccharides trong sữa, Lactic acid bacteria, Bifidobacterium BB536'),

(N'Viên uống Active Legs hỗ trợ điều trị suy giãn tĩnh mạch chân (15 viên)', 
 N'Active Legs giúp tăng cường lưu thông tuần hoàn máu, tăng sức bền tĩnh mạch, hạn chế hình thành huyết khối, phòng ngừa và hỗ trợ điều trị suy giãn tĩnh mạch chân, giảm các triệu chứng đau chân, nặng chân, tê chân, gân xanh nổi ở chân…', 
 N'1888/2019/ÐKSP', 1, 1, 272000, 1, 7, 
 N'Hạt tiêu đen, Chiết xuất nho, Chiết xuất vỏ thông Pháp, Tá dược vừa đủ, Vitamin C'),

(N'Viên uống Lipitas Jpanwell giúp giảm mỡ, cholesterol và triglyceride trong máu (60 viên)', 
 N'Viên uống Lipitas JpanWell giúp giảm mỡ, Cholesterol và Triglyceride trong máu, hỗ trợ giảm nguy cơ hình thành huyết khối, hỗ trợ giảm huyết áp do Cholesterol, tốt cho tim mạch.', 
 N'10274/2019/ÐKSP', 1, 1, 995000, 1, 6, 
 N'Nattokinase, Inulin, Kế sữa, L-Cystine, Quercetin, Vitamin E, Selenium, Bột Gừng, Tá dược vừa đủ, Coenzym Q10, Monascus, Bột vỏ hành tây, Bột nấm ngưu chương chi'),
 -- thiet bi y te
(N'Máy đo huyết áp bắp tay tự động Omron HEM-7120', 
 N'Máy đo huyết áp Omron Hem-7120 sử dụng công nghệ Intellisense mới tự động hoàn toàn, cảm biến vượt trội cho kết quả nhanh và chính xác.', 
 N'220000634/PCBB-BYT', 2, 1, 940000, 1, 6, N'Nhựa'),

(N'Máy đo huyết áp điện tử bắp tay Yuwell YE680B', 
 N'Máy đo huyết áp điện tử bắp tay Yuwell YE680B có chức năng cảnh báo rung nhĩ, ngăn ngừa đột quỵ, đo nhanh và chính xác cao.', 
 N'240001221/PCBB-HCM', 2, 1, 872000, 1, 7, N'Nhựa'),

(N'Máy đo huyết áp điện tử bắp tay Yuwell YE610D', 
 N'Máy đo huyết áp điện tử Yuwell YE610D dễ dàng kiểm tra huyết áp chỉ với 1 nút bấm, cho kết quả chính xác.', 
 N'240001222/PCBB-HCM', 2, 1, 616000, 1, 7, N'Nhựa'),

(N'Que thử đường huyết Nipro Premier (25 que)', 
 N'Que thử đường huyết Nipro Premier hoạt động với máy đo đường huyết Nipro Premier để đo định lượng đường trong máu.', 
 N'220000085/PCB-HCM', 2, 1, 205000, 1, 8, N'Que thử đường huyết'),

(N'Combo 3 hộp que thử đường huyết Easy Max (25 que)', 
 N'Que thử đường huyết Easy Max với công nghệ cảm biến sinh học tiên tiến, cho kết quả chuẩn xác chỉ trong vòng 5 giây.', 
 N'15775NK/BYT-TB-CT', 2, 1, 559200, 1, 9, N'Que thử đường huyết, Máy đo đường huyết'),

(N'Máy đo đường huyết tự động MediUSA GM3300', 
 N'Máy đo đường huyết MediUSA GM3300 kiểm soát đường huyết tự động mã hóa, đo nhanh trong 6 giây.', 
 N'1692-ADJVINA/170000008/PCBPL-BYT', 2, 1, 911200, 1, 1, N'Máy đo đường huyết'),

(N'Kim Lancet lấy máu BL-28 (100 cái)', 
 N'Kim lấy máu Lancet Carefine BL-28G dùng cho máy đo đường huyết Easy Max, Nipro Premier Alpha.', 
 N'220000013/PCBB-BYT', 2, 1, 32000, 1, 7, N'Kim loại'),

(N'Đầu kim tiểu đường PIC Insupen Original (100 cái)', 
 N'Đầu kim tiểu đường Insupen giúp thao tác tiêm thoải mái, giảm đau.', 
 N'220000365/PCBB-HCM', 2, 1, 250000, 1, 10, N'Thép không gỉ'),

(N'Kim luồn Braun 22 hỗ trợ truyền dịch (1 cái)', 
 N'Kim luồn 22 Braun giúp đưa dịch truyền, thuốc vào cơ thể nhanh chóng.', 
 N'84/170000047/PCBPL-BYT', 2, 5, 17500, 1, 11, N'Nhựa PP, FEP-Teflon'),

(N'Băng keo cá nhân Elastic Fabric Ace Band-F', 
 N'Băng keo cá nhân vải dùng để bảo vệ vết thương hở nhỏ.', 
 N'190000005/PCBA-LA', 2, 1, 56000, 1, 8, N'Sợi vải co giãn Viscose, Polyamide, vải không dệt, Acrylic'),

(N'Bông y tế Quick Nurse 1kg', 
 N'Bông y tế Quick Nurse 1kg được làm từ 100% cotton, đạt tiêu chuẩn an toàn.', 
 N'200000029/PCBA-ĐN', 2, 4, 210000, 1, 2, N'Cotton'),

(N'Cồn 70 độ Vĩnh Phúc 1000ml', 
 N'Cồn 70 độ Vĩnh Phúc dùng để diệt khuẩn dụng cụ y tế, bề mặt trong y tế.', 
 N'VNDP-HC-155-11-17', 2, 3, 48000, 1, 2, N'Ethanol'),

(N'Chai xịt giảm đau Safefit Jet Spray 110ml', 
 N'Chai xịt giảm đau Safefit Jet Spray giúp giảm đau, kháng viêm.', 
 N'220000065/PCBA-LA', 2, 3, 165000, 1, 2, N'Methyl Salicylat, L-menthol, Propylen glycol'),

(N'Kim lấy máu MediUSA MM3300 (25 cái)', 
 N'Kim lấy máu MediUSA MM3300 sử dụng cho máy đo đường huyết, đã qua tiệt trùng.', 
 N'20200603-ADJVINA/170000008/PCBPL-BYT', 2, 5, 1200, 1, 1, N'Thép không gỉ, Nhựa'),

(N'Kim tiêm tiểu đường B.Braun Omnican 1ml/40 I.U', 
 N'Ống tiêm insulin kèm kim tiêm tích hợp sử dụng 1 lần, dùng cho người bệnh tiểu đường.', 
 N'2100688ĐKLH/BYT-TB-CT', 2, 1, 329000, 1, 11, N'Nhựa, Thép không gỉ'),

(N'Găng tay cao su y tế nhám không bột VGlove Size M (100 cái)', 
 N'Găng tay cao su y tế VGlove không bột, phù hợp trong y tế, thực phẩm, nha khoa.', 
 N'170000062/PCBA-BD', 2, 1, 80000, 1, 2, N'Cao su thiên nhiên'),

(N'Túi chườm đa năng Medione', 
 N'Túi chườm đa năng giúp giảm đau, giữ ấm, làm mát.', 
 N'01-2019/HD', 2, 1, 130000, 1, 2, N'Bộ túi chườm đa năng'),

(N'Bông y tế Bảo Thạch 6cm x 6cm (500g)', 
 N'Bông y tế Bảo Thạch làm sạch vết thương, thấm máu và dịch tiết.', 
 N'170000045/PCBA-BD', 2, 4, 99000, 1, 2, N'Bông tự nhiên'),

(N'Miếng dán hạ sốt Licokid', 
 N'Miếng dán hạ sốt Licokid giúp làm mát tự nhiên, hạ sốt, giảm đau.', 
 N'190000213/PCBA-HCM', 2, 4, 9000, 1, 7, N'Aluminium glycinate, Glycerin, Sodium Polyacrylate, Menthol, Eucalyptol, Nước tinh khiết'),

(N'Khẩu trang sợi hoạt tính Kissy For Kids', 
 N'Khẩu trang Kissy For Kids chống khí ô nhiễm, dùng cho trẻ em.', 
 N'TCCS 01:2017/NĐH', 2, 1, 42000, 1, 2, N'Vải cotton, sợi hoạt tính'),

 -- duoc my pham
 (N'Dầu Dừa Tươi Raw Virgin Coconut Oil Coboté 50ml', 
 N'Dầu dừa tươi Coboté Raw Virgin Coconut Oil sử dụng hiệu quả cho cả da, tóc và răng miệng.', 
 N'DM001', 3, 1, 90000, 1, 2, N'100% dầu dừa tươi, MCTs, Lauric, Caprylic, Capric acid'),

(N'Gel chấm mụn, mờ thâm Decumar Advance THC 20g', 
 N'Gel chấm mụn, mờ thâm Decumar Advance THC giúp dưỡng ẩm da, giúp da mềm mịn.', 
 N'DM002', 3, 1, 105000, 1, 2, N'Purified water, Niacinamide, Glycerin, Allium Cepa Bulb Extract, Propylene Glycol'),

(N'Dung dịch vệ sinh vùng kín Bimunica 250ml', 
 N'Dung dịch vệ sinh Bimunica giúp làm sạch vùng kín, duy trì hàng rào bảo vệ tự nhiên.', 
 N'DM003', 3, 3, 179400, 1, 12, N'Aqua, Cocamidopropyl, Betaine, Sodium Coco-sulfate, Glycerin, Aloe Barbadensis Extract'),

(N'Sữa tắm gội em bé Gentle Wash 500ml La Beauty', 
 N'Sữa tắm gội em bé Gentle Wash giúp chăm sóc và bảo vệ da cho bé, ngăn ngừa rôm sảy.', 
 N'DM004', 3, 3, 127200, 1, 2, N'Water, Cocamidopropyl betaine, Decyl glucoside, Glycerin, Olive Oil, Centella Asiatica Extract'),

(N'Gel Rosette Gommage Clear Peel 180g', 
 N'Tẩy tế bào chết Rosette Gommage Clear Peel giúp làm mềm lớp sừng, loại bỏ tế bào da chết.', 
 N'DM005', 3, 2, 135050, 1, 6, N'Water, Steertrimonium chloride, Carbomer, Alcohol, Kaolin, Lactic Acid, Citric Acid'),

(N'Mặt nạ Marine Luminous Pearl Deep Moisture Mask Peal 30ml', 
 N'JMsolution Marine Luminous Pearl Deep Moisture Mask giúp dưỡng ẩm và làm trắng da.', 
 N'DM006', 3, 5, 21840, 1, 8, N'Water, Glycerin, Sea water, Butylene glycol, Hydrolyzed Collagen, Pearl Extract'),

(N'Sáp dưỡng ẩm Vaseline Fobelife 50g', 
 N'Sáp dưỡng ẩm Vaseline giúp dưỡng môi mềm mịn, làm dịu da khi bị khô rát, nứt nẻ.', 
 N'DM007', 3, 1, 68000, 1, 2, N'Petrolatum, Paraffinum Liquidum, Cetearyl Alcohol, Hydrogenated Olive Oil, Panthenol'),

(N'Kem thoa da Tiacortisol 8g', 
 N'Kem thoa da Tiacortisol giúp dưỡng ẩm, làm mềm dịu vùng da bị khô.', 
 N'DM008', 3, 1, 12000, 1, 2, N'Water, Glycerin, Stearic Acid, Propylene Glycol, Tocopheryl Acetate, Panthenol, Sodium Hydroxide'),

(N'Gel Neothera Acnes 15ml', 
 N'Gel giảm mụn thâm, sẹo mụn Neothera Acnes giúp làm dịu nốt mụn, phục hồi da sáng khỏe.', 
 N'DM009', 3, 1, 135200, 1, 2, N'Propanediol, Malic Acid, Propylene Glycol, Glycolic Acid, Rhamnose, Urea, Glucose'),

(N'Sữa rửa mặt On: The Body Rice Therapy 150ml', 
 N'Sữa rửa mặt giúp làm sạch sâu, loại bỏ dầu nhờn, không gây khô da.', 
 N'DM010', 3, 2, 165000, 1, 8, N'Water, Glycerin, Myristic Acid, Lauric Acid, Glycol Distearate, Disodium Cocoamphodiacetate'),

(N'Nước tẩy trang JMsolution Water Luminous S.O.S Ringer Cleansing Water 500ml', 
 N'Nước tẩy trang giúp làm sạch bụi bẩn, dầu thừa và lớp trang điểm trên da.', 
 N'DM011', 3, 3, 199000, 1, 8, N'Water, PEG-6 Caprylic, Butylene Glycol, Decyl Glucoside, PEG-40 Hydrogenated Castor Oil'),

(N'Son dưỡng lành tính Omi Menturm 3.6g', 
 N'Son dưỡng dành cho môi nhạy cảm giúp cấp ẩm, ngăn ngừa môi khô, nứt nẻ.', 
 N'DM012', 3, 2, 99000, 1, 6, N'Mineral Oil, Squalane, Paraffin, Lanolin, Jojoba Seed Oil, Tocopheryl Acetate'),

(N'Nước dưỡng tóc tinh dầu bưởi Cocoon 310ml', 
 N'Nước dưỡng tóc từ tinh dầu vỏ bưởi giúp giảm gãy rụng, nuôi dưỡng da đầu.', 
 N'DM013', 3, 1, 325000, 1, 2, N'Aqua, Citrus Grandis Peel Oil, Glycerin, Arginine, Lactic Acid, Xylitylglucoside'),

(N'Kem dưỡng ẩm mềm da cho bé Kutieskin 30g', 
 N'Kem dưỡng ẩm chứa tinh chất yến mạch, bơ hạt mỡ giúp da mềm mịn.', 
 N'DM014', 3, 1, 58000, 1, 2, N'Purified water, Butyrospermum Parkii Butter, Vaseline, Glycerin, Yến Mạch, Vitamin E'),

(N'Kem Fixderma Skarfix-TX Cream 30g', 
 N'Kem giúp làm mờ vết thâm, đốm đen, nám, dưỡng trắng da hiệu quả.', 
 N'DM015', 3, 1, 436800, 1, 12, N'Aqua, Tranexamic acid, Kojic Dipalmitate, Alpha Arbutin, Vitamin C, Ethoxydiglycol'),

(N'Kem dưỡng ẩm Cerave Moisturising Cream 340g', 
 N'Kem dưỡng ẩm giúp duy trì độ ẩm và phục hồi hàng rào bảo vệ da.', 
 N'DM016', 3, 1, 422750, 1, 1, N'Aqua, Petrolatum, Glycerin, Ceramide NP, Ceramide AP, Sodium hyaluronate, Cholesterol'),

(N'Dầu gội chống gàu Selsun Anti-Dandruff Shampoo 250ml', 
 N'Dầu gội chống gàu với 1% Selenium Sulfide giúp ngăn ngừa nấm gây gàu.', 
 N'DM017', 3, 3, 178400, 1, 6, N'Selenium Sulfide, Dimethicone, Hydroxypropyl methylcellulose, Cocamide DEA'),

(N'Dầu gội dược liệu Nguyên Xuân Nâu 200ml', 
 N'Dầu gội dược liệu giúp làm sạch gàu, giảm tóc gãy rụng, nuôi dưỡng da đầu.', 
 N'DM018', 3, 3, 68000, 1, 2, N'Bồ kết, Cỏ mần trầu, Dâu tằm, Hà thủ ô, Bạch quả, Tinh dầu hương nhu'),

(N'Kem dưỡng Eucerin Hyaluron-Filler Eye SPF15 15ml', 
 N'Kem dưỡng giúp điều trị nếp nhăn vùng da quanh mắt, chống lão hóa.', 
 N'DM019', 3, 2, 1080000, 1, 11, N'Diethylamino hydroxybenzoyl hexyl benzoate, Cetyl palmitate, Chiết xuất Glycine Soja'),

(N'Mặt nạ xông hơi mắt MegRhythm KAO 5 miếng', 
 N'Mặt nạ xông hơi giúp thư giãn đôi mắt, giảm quầng thâm.', 
 N'DM020', 3, 1, 140000, 1, 6, N'Tinh dầu hoa oải hương, Hơi ấm 40 độ C'),


 -- cham soc ca nhan

(N'Kem đánh răng Sensodyne Repair And Protect Deep Repair Whitening 100g', 
 N'Kem đánh răng giúp phục hồi răng nhạy cảm, làm chắc răng với công nghệ NOVAMIN.', 
 N'CSCN001', 4, 2, 90000, 1, 1, N'Glycerin, Peg-8, Hydrated silica, Calcium, Sodium fluoride'),

(N'Bàn chải đánh răng điện Oral-B Pro 500 Crossaction', 
 N'Bàn chải điện với công nghệ xoay rung 3D giúp loại bỏ mảng bám hiệu quả.', 
 N'CSCN002', 4, 1, 874500, 1, 1, N'PIN, TPE, POM, Nhựa ASA, Polypropylen, Polyamide'),

(N'Tăm chỉ kẽ răng Okamura 90 cây', 
 N'Tăm chỉ nha khoa giúp làm sạch thức ăn dư thừa trong kẽ răng.', 
 N'CSCN003', 4, 4, 33000, 1, 6, N'Polyester, Nhựa Hips'),

(N'Tinh dầu Thảo Nguyên hương sả chanh 200ml', 
 N'Tinh dầu giúp khử khuẩn, chống virus, thanh lọc không khí.', 
 N'CSCN004', 4, 3, 95200, 1, 2, N'Camphene, Limonene, Eucalyptol, Linalool, Menthone, Menthol'),

(N'Khăn ướt Living Chok Chok Aloe Vera 10 miếng', 
 N'Khăn ướt mềm mại, không xơ, giữ ẩm nhưng không làm nhớt da.', 
 N'CSCN005', 4, 4, 9500, 1, 8, N'Polyester, Nước tinh khiết, Lô hội, Caprylyl glycol, Sodium benzoate'),

(N'Tinh dầu tràm Bách Linh 50ml', 
 N'Tinh dầu tràm giúp giữ ấm cơ thể, giảm ngạt mũi, ho, cảm lạnh.', 
 N'CSCN006', 4, 3, 135000, 1, 2, N'Tinh dầu tràm'),

(N'Tinh dầu xông Thảo Nguyên 500ml', 
 N'Tinh dầu xông giúp thải độc, ngừa bệnh lây qua đường hô hấp.', 
 N'CSCN007', 4, 3, 132300, 1, 2, N'Tinh dầu khuynh diệp, Tinh dầu hương nhu, Tinh dầu tràm, Tinh dầu hương thảo'),

(N'Kem tẩy lông Veet Pure 50g', 
 N'Kem tẩy lông công thức bơ hạt mỡ giúp da mịn màng.', 
 N'CSCN008', 4, 1, 70000, 1, 15, N'Aqua, Cetearyl Alcohol, Potassium Thioglycolate, Calcium Hydroxide'),

(N'Dao cạo râu Gillette Super Thin 2 cái', 
 N'Dao cạo râu cán vàng với lưỡi dao sắc bén giúp cạo sát, giảm trầy xước.', 
 N'CSCN009', 4, 4, 15000, 1, 1, N'Nhựa, Thép không gỉ'),

(N'Dầu dưỡng ẩm mát xa Johnson''s Baby Oil 50ml', 
 N'Dầu dưỡng ẩm mát xa giữ ẩm hoàn hảo cho bé.', 
 N'CSCN010', 4, 3, 40000, 1, 1, N'Mineral oil, Fragrance'),

(N'Tăm bông kháng khuẩn KamiCare 200 que', 
 N'Tăm bông kháng khuẩn làm từ bông cotton, dùng để vệ sinh tai, mũi.', 
 N'CSCN011', 4, 1, 25600, 1, 2, N'Chitosan, Polyvinyl alcohol, Bông cotton, Giấy'),

(N'Gel rửa tay khô Natural Hand Sanitizer 250ml', 
 N'Gel rửa tay giúp làm sạch vi khuẩn, bụi bẩn, ngăn ngừa lây nhiễm.', 
 N'CSCN012', 4, 3, 55000, 1, 2, N'Propylene glycol, Myristyl Alcohol, Triethanolamine, Glycerin, Chiết xuất quế, Trà xanh'),

(N'Bao cao su Okamoto Crown 3 cái', 
 N'Bao cao su siêu mỏng, mềm mại, đảm bảo an toàn tối đa.', 
 N'CSCN013', 4, 1, 50400, 1, 6, N'Cao su thiên nhiên'),

(N'Bao cao su Okamoto 0.03 Platinum 3 cái', 
 N'Bao cao su trong suốt, mềm mại, ôm sát.', 
 N'CSCN014', 4, 1, 132300, 1, 6, N'Cao su thiên nhiên'),

(N'Gel bôi dưỡng ẩm Bix For Gentleman 30ml', 
 N'Gel dưỡng ẩm hỗ trợ sinh lý nam giới với chiết xuất thiên nhiên.', 
 N'CSCN015', 4, 2, 350000, 1, 16, N'Aqua, Mật Nhân (Tongkat Ali), Nhân Sâm, Rau má, Nha đam'),

(N'Tinh dầu cho bé sơ sinh Thảo Nguyên 50ml', 
 N'Tinh dầu giúp phòng cảm lạnh, giữ ấm phổi, chống muỗi.', 
 N'CSCN016', 4, 3, 73780, 1, 2, N'Alpha-pinene, Camphene, Limonene, Menthol, Beta-sesquiphellandrene'),

(N'Máy tăm nước cầm tay Halio Professional', 
 N'Máy tăm nước giúp loại bỏ mảng bám, bảo vệ răng miệng.', 
 N'CSCN017', 4, 1, 1420000, 1, 1, N'Nhựa'),

(N'Đầu chải răng người lớn Oral-B Ultrathin EB60', 
 N'Đầu bàn chải thay thế giúp làm sạch mảng bám, chăm sóc nướu.', 
 N'CSCN018', 4, 1, 286000, 1, 1, N'Nhựa'),

(N'Dung dịch vệ sinh phụ nữ Daily Lady Moist And Fresh 100ml', 
 N'Dung dịch vệ sinh giúp làm sạch, khử mùi, dưỡng ẩm.', 
 N'CSCN019', 4, 1, 99000, 1, 2, N'Aqua, Sodium Laureth Sulfate, Cocamidopropyl Betaine, Mentha Piperita Extract, Lô hội'),

(N'Đường ăn kiêng Sweet''n Low 100 gói', 
 N'Sweet’N Low giúp thay thế đường mía, phù hợp cho người béo phì, tiểu đường.', 
 N'CSCN020', 4, 1, 56000, 1, 1, N'Saccharin 3.6%, Dextrose 94.5%, Calcium 0.5%, Cream of Tartar'),

 -- thuoc

(N'Thuốc Exopadin 60mg Trường Thọ', 
 N'Thuốc điều trị viêm mũi dị ứng, mày đay.', 
 N'THUOC001', 5, 2, 60000, 1, 2, N'Fexofenadin Hydroclorid'),

(N'Thuốc Vomina Plus 50mg Medipharco', 
 N'Thuốc phòng và điều trị triệu chứng buồn nôn, chóng mặt khi say tàu xe.', 
 N'THUOC002', 5, 2, 100000, 1, 2, N'Dimenhydrinate'),

(N'Siro Aerius 60ml Organon', 
 N'Thuốc giảm viêm mũi dị ứng, hắt hơi, sổ mũi, ngứa mũi, sung huyết.', 
 N'THUOC003', 5, 3, 87000, 1, 1, N'Desloratadine'),

(N'Thuốc chống say tàu xe Momvina Hadiphar', 
 N'Thuốc phòng và điều trị chứng buồn nôn, nôn, chóng mặt.', 
 N'THUOC004', 5, 2, 100000, 1, 2, N'Dimenhydrinate'),

(N'Tinh dầu trẻ em Nasomom-4 Reliv', 
 N'Tinh dầu giúp giảm triệu chứng nghẹt mũi, sổ mũi, khò khè, cảm cúm.', 
 N'THUOC005', 5, 3, 39000, 1, 14, N'Natri clorid, Eucalytol'),

(N'Thuốc ho người lớn OPC', 
 N'Thuốc điều trị viêm nhiễm đường hô hấp, ho gió.', 
 N'THUOC006', 5, 3, 32000, 1, 2, N'Cineol, Hoàng cầm, Bạch linh, Thiên môn đông, Tang bạch bì, Tiền hồ, Bách bộ, Cát cánh, Tỳ bà lá, Menthol, Cam thảo'),

(N'Thuốc Rutin-Vitamin C Mekophar', 
 N'Thuốc hỗ trợ điều trị các hội chứng chảy máu, xơ cứng.', 
 N'THUOC007', 5, 1, 240, 1, 2, N'Rutin, Vitamin C'),

(N'Thuốc Hoạt Huyết Dưỡng Não Traphaco', 
 N'Thuốc điều trị suy giảm trí nhớ, căng thẳng thần kinh.', 
 N'THUOC008', 5, 2, 95000, 1, 2, N'Bạch quả, Đinh lăng'),

(N'Thuốc Henex 500mg Abbott', 
 N'Thuốc điều trị suy tĩnh mạch - mạch bạch huyết, cơn trĩ cấp.', 
 N'THUOC009', 5, 2, 240000, 1, 1, N'Diosmin, Hesperidin'),

(N'Thuốc Alzental 400mg Shinpoong Daewoo', 
 N'Thuốc điều trị nhiễm một hoặc nhiều loại ký sinh trùng đường ruột.', 
 N'THUOC010', 5, 1, 4000, 1, 2, N'Albendazol'),

(N'Viên nén Mebendazole 500mg Mekophar', 
 N'Thuốc điều trị nhiễm một hay nhiều loại giun.', 
 N'THUOC011', 5, 1, 2200, 1, 2, N'Mebendazole'),

(N'Thuốc Fugacar 500mg Janssen', 
 N'Thuốc điều trị nhiễm giun.', 
 N'THUOC012', 5, 1, 22000, 1, 1, N'Mebendazole'),

(N'Thuốc Đại Tràng Trường Phúc', 
 N'Thuốc điều trị viêm loét đại tràng, rối loạn tiêu hóa.', 
 N'THUOC013', 5, 2, 105000, 1, 2, N'Hoàng liên, Mộc hương, Bạch truật, Bạch thược, Ngũ bội tử, Hậu phác, Cam thảo, Xa tiền tử, Hoạt thạch'),

(N'Viên đặt âm đạo Timbov Farmaprim', 
 N'Thuốc điều trị nhiễm khuẩn âm đạo, viêm âm đạo kèm huyết trắng.', 
 N'THUOC014', 5, 1, 205000, 1, 17, N'Clotrimazole'),

(N'Dầu gió xanh Con Ó Eagle Brand Medicated Oil', 
 N'Dầu xoa giúp giảm nhức đầu, cảm cúm, đau lưng, viêm khớp.', 
 N'THUOC015', 5, 3, 74999, 1, 4, N'Methyl salicylate, Eucalyptus oil, Menthol'),

(N'Thuốc Paincerin 50mg Diacerein Pharmanel', 
 N'Thuốc điều trị triệu chứng thoái hóa khớp hông, gối.', 
 N'THUOC016', 5, 2, 360000, 1, 18, N'Diacerein'),

(N'Thuốc Cardioton Lipa Pharmaceuticals', 
 N'Thuốc điều trị suy tim, tăng huyết áp, thiếu máu cơ tim.', 
 N'THUOC017', 5, 2, 230000, 1, 19, N'Ubidecarenone, D-alpha tocopherol'),

(N'Thuốc Caldihasan Hasan', 
 N'Thuốc phòng và điều trị thiếu hụt vitamin D, canxi.', 
 N'THUOC018', 5, 1, 700, 1, 2, N'Cholecalciferol, Calci carbonat'),

(N'Thuốc mỡ bôi da Agiclovir 5% Agimexpharm', 
 N'Thuốc điều trị nhiễm Herpes simplex, Herpes zoster, Herpes sinh dục.', 
 N'THUOC019', 5, 2, 10000, 1, 2, N'Excipients q.s, Aciclovir'),

(N'Thuốc Azoltel 400mg Stella', 
 N'Thuốc điều trị nhiễm một hoặc nhiều loại ký sinh trùng đường ruột.', 
 N'THUOC020', 5, 1, 4800, 1, 2, N'Albendazol');



 INSERT INTO product_images(product_id, image_url) VALUES 
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804359/hgvbvgdk5ptx5l7ycpcc.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804358/xhgrs6hdwblelkbi8qah.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804358/h7xvq3w1mykkhuowod8z.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804357/nwaoyucmhsfpe31wmbpi.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804356/pmv7u5t7ur6i6mxsgkfg.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804356/vrwmuznqltfaffih8ryj.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804355/qqwerr7qwptwnekrudsk.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804354/twbyne9xqwqxfizvull3.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804354/j4k2etr4lf9ydigwd04f.png'),
 (1, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804352/ynpclow2p8rc7n5ghhzs.png'),
 (2, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804274/cfidrwltogdpt8gj5twk.png'),
 (2, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804273/ec41r4sfqeevkqmnrupa.png'),
 (2, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804273/imnc5ethv0d938f6cqhg.png'),
 (2, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804272/uhb4xesqq1yx0ltirlii.png'),
 (2, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804271/v3k6gthxhlhlhfxdgzzb.png'),
 (2, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804271/ggiogyzm1oyx9mhobmze.png'),
 (3, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804278/hbzeq4vmbbe5mswvkrv3.png'),
 (3, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804277/ellrppexhfk7laeff5fe.png'),
 (3, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804277/zy5bauikzzo87dqylgog.png'),
 (3, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804276/saqmsaguitvccx7haoo1.png'),
 (3, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804275/gte5a4svixavlgmu6hzq.png'),
 (3, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804275/vm6lz33o0hi2vfjibxj8.png'),
 (4, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804282/iblityhnmtq29gwyylb9.png'),
 (4, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804281/ocnu4hjl5ldkb77gpa2c.png'),
 (4, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804280/nfwkdmsalggjioomkmhs.png'),
 (4, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804280/bxzid2aajyrc8fdnyjg0.png'),
 (4, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804279/adyiucwclyfuuov8aver.png'),
 (5, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804352/ukfqzbikmupfv8ermhqx.png'),
 (5, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804351/uqetom6oufhnorlrvpih.png'),
 (5, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804351/vh1k7yt28xk6m0tcgfoq.png'),
 (5, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804350/rbtsevlwsof2hsa8w7ve.png'),
 (5, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804350/esi7utr5xstukf82o0uk.png'),
 (5, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804349/aroy6hq7ns8incotbire.png'),
 (5, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804348/jsefocsbzoh1kfueomjy.png'),
 (6, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804347/djpavw7br7t4hmfknmph.png'),
 (6, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804346/exq5rkoydvz0y0ykvpii.png'),
 (6, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804346/vm0mbliv4t7p0eslyc8l.png'),
 (6, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804345/rgdkfnb08pjloqktvz0y.png'),
 (6, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804344/xxrgal7mqgzwctrfdwzd.png'),
 (6, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804343/dqrjxmwng3kovow7ezof.png'),
 (7, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804343/i2u7r6kimtqtgscwddje.jpg'),
 (7, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804342/ix5hfaili6g9nomdykmw.png'),
 (7, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804341/ikzfotti1dqvqfvmgjjs.png'),
 (7, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804340/yi22pmzlqpj6cfufga9m.png'),
 (7, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804340/axiw07mbwkbls6rsloix.png'),
 (7, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804339/xdl8bicrgsollejhlq9r.png'),
 (7, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804338/ovbfpjgoxqdh1r33xzz6.png'),
 (8, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804285/suups6xfhc7ivupgm10r.png'),
 (8, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804285/zl7hs1bibizsyh3z8bzr.png'),
 (8, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804284/qvzpcskx8hfy648eqevc.png'),
 (8, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804283/loueld9ytdchfjpbv2ro.png'),
 (8, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804283/nlcow4fsnioppsord9qy.png'),
 (9, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804290/jqq7bapxtmfjfjev6vba.png'),
 (9, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804289/xoziwuhgyqayw8xcyt0h.png'),
 (9, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804288/a4qnwoqmuelh8kmstxrd.png'),
 (9, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804287/rpzpzixykzarq3rsozuy.png'),
 (9, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804286/imnyw4axxh0tggmpfsar.png'),
 (9, 'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804286/et9gidi1obc1xduskbkf.png'),
 (10,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804294/ahtjz2lbkachspbodfmg.png'),
 (10,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804294/fyy1lwn3fgm748sdldgu.png'),
 (10,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804293/h9a0ru3r4sfwzbq0oe9y.png'),
 (10,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804293/pbihsvep538bpecpjkp5.png'),
 (10,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804292/yvkdjjxqd5dixgcmfd1a.png'),
 (10,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804291/dakwhnfudwbwovuegx8w.png'),
 (11,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804298/pmhdan2rioqmdvzthe1m.png'),
 (11,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804297/menjuukleru5ntr78ths.png'),
 (11,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804297/wnhjg98tteghs5s5xrb7.png'),
 (11,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804296/bthe6me1wjhdtunospbr.png'),
 (11,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804295/kx40fv9fyjg9mif4namt.png'),
 (12,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804302/yn36xght8lvvvzo3kqli.png'),
 (12,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804302/agzinuyauvqmwkdslhho.png'),
 (12,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804302/zl0yzujxv0z6wz4isrca.png'),
 (12,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804300/x2jgms9h55alo1ju7896.png'),
 (12,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804299/wie8nygqep2s9scsu8c9.png'),
 (13,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804338/xvdii5cu5ivebugjvcnr.png'),
 (13,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804337/lmpsisp4rtibn2widpqa.png'),
 (13,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804337/kvwfeujplxdj0wr7u4d8.png'),
 (13,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804335/ripnujlwgkfkjhekrfkg.png'),
 (13,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804335/xc5n40u2o9qwfev6jnnz.png'),
 (13,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804334/uy3klwu7ka3zbthwet7o.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804333/dvqvijbzzs8bihiczpzo.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804333/vao5mdfuoex6wrelsbjm.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804332/lctzft2ocyozgkcaixi0.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804331/d18mkpijpmd3euywgvlr.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804330/bv6hcwotc2g0mugjifoo.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804330/n1icm2kucmc9l1nek6nh.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804329/lvcvyn4i5irizqxpkwxk.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804328/iitml2zyv03ilbrl2gz8.png'),
 (14,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804327/mqr3a15o1zv76njattcb.png'),
 (15,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804327/puciq03unliv7bhbwjoz.png'),
 (15,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804327/vpjjybdbchfmu5sikhay.png'),
 (15,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804325/ymqk1e6yjgjslpsofr6h.png'),
 (15,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804325/acffi2vk3xoo550zclcz.png'),
 (15,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804324/v5fo4e7wt58p3cjcjgcs.png'),
 (15,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804323/m8m9fhx6adbn5uhjcfap.png'),
 (15,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804322/lwlalzjwn0vrr727bxks.png'),
 (16,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804321/lon3ss6msezz6gmgx5fh.png'),
 (16,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804320/ivbdhtxqjwcltoytuvod.png'),
 (16,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804320/wgekffa0aeli134nmxjn.png'),
 (16,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804319/kjtohamlizbgfyzutjdy.png'),
 (16,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804318/bmmyycaaxh8iolxjvpvk.png'),
 (16,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804317/tosrblndcslrq1iosuge.png'),
 (16,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804317/qsadbht5gvrqsjw0yz6f.png'),
 (16,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804317/dm7swmfva5okrqfm1ff4.png'),
 (17,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804316/y7ibmodqopc9dpl2xnru.png'),
 (17,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804315/nztjmnzoplqftuhike1e.png'),
 (17,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804314/vhdpe8bvnsfzbnev18yx.png'),
 (17,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804313/apebb2hyqwwh9cxjng2l.png'),
 (17,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804313/qmrq8rq5uzuvdzyhiemt.png'),
 (17,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804312/hsfec1jrypesttkwtamv.png'),
 (18,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804269/q8zt72zizahkzxcosziw.webp'),
 (18,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804269/meeuj43vnqovrqzuvzqk.webp'),
 (18,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804268/n1k2apvmc2fqyh7aoi5g.webp'),
 (18,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804268/loxgjqbvl1kt65eepx0z.webp'),
 (18,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804267/gtdpnfyygqrlyapl4xgt.webp'),
 (19,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804305/hwpk36y17o9cv2o2g7oa.png'),
 (19,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804305/k18rcaiksb7ydwg0fmda.png'),
 (19,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804304/d7lsheqbssxolwqwplmm.png'),
 (19,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804303/ftclbf5bcca8gf1xwsft.png'),
 (20,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804266/pdbzguqte5qi7valfcwo.jpg'),
 (20,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804265/jokcgz6m8gnl2gjposf5.webp'),
 (21,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804264/cf7neovmg0uif7bygmin.webp'),
 (21,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804264/dp90ko3w4u7vofq0imfr.webp'),
 (22,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804263/i9dwbudj6sqo1vhrszoo.webp'),
 (22,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804262/nyewhajd0b6eiyked5hh.webp'),
 (22,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804262/abdwu9yhtk2gcsvadt7z.webp'),
 (23,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804261/nwkavck3tizjjbbzlhpc.webp'),
 (23,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804260/qqnjwlshyev0418bpwrm.webp'),
 (24,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804260/pprij9lac7fwxgjo7zoc.webp'),
 (24,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804259/enqu9rqdjvlbie9i5ioy.webp'),
 (25,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804255/tgtx5h5kytvz6gwtain8.jpg'),
 (25,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804255/jajstgiag9ovjwtzeac1.webp'),
 (25,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804253/mlbbszyfrs0zynviypgh.webp'),
 (25,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804253/nv5ekhg4ovmrgngopuvs.webp'),
 (25,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804252/gioupyexomy8awcowv3s.webp'),
 (26,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804258/au2ufjwv04gbaajfrofg.webp'),
 (26,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804257/hfi63b2g9j1flvck5lcg.webp'),
 (26,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804257/zeftzrrqivtryoxa4rch.webp'),
 (26,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804256/k7ngsnw6whqmqynu2ya9.webp'),
 (26,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804255/ravljolmyovoetjn91sp.webp'),
 (27,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804251/phgpmfx78vfbicp9772f.jpg'),
 (27,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804251/ovaow15pztildt4xds4g.webp'),
 (27,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804250/l63dz4rudrbsprwqjg4m.webp'),
 (27,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804249/dirktlmtazldxp0fpvgl.webp'),
 (27,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804248/aq5wd2tweqs9xkdkerhx.webp'),
 (27,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804248/xjvdmyl7ayjvgedfavsr.webp'),
 (28,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804247/xyarslzdp8p5nzyzvsb4.webp'),
 (29,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804246/kcvg802cfw4akbxdbpyt.webp'),
 (29,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804246/igrnjyzti3ymnltxbuns.webp'),
 (29,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804245/phe6pojfp65rm08p2fbw.webp'),
 (29,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804244/l4vqwwutnlov3pubmhgy.webp'),
 (29,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804243/nf0in8tczqfn5enep2n1.webp'),
 (30,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804243/w4cxm52ru5noe1xm24go.webp'),
 (30,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804242/fkwps4umnlxejlzr4e7t.webp'),
 (30,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804242/rlkzaljr3qffhcbbmrsv.webp'),
 (30,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804241/hlgrfvsvyl8aej2z8fh8.webp'),
 (31,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804240/e5zbujnrqzcuilbzubh3.webp'),
 (31,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804239/kosuq0d65vochxcxzkqt.webp'),
 (31,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804239/hszhweykzjmj5iisnu28.webp'),
 (31,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804238/icg040pmavkmoi2nophz.webp'),
 (31,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804238/eqcowxitvmuxqdniqwrg.webp'),
 (32,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804237/f6zqfouyjllsv3tir8oe.jpg'),
 (32,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804236/zeqm8vqh2dxqz0r7foct.webp'),
 (32,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804235/eoyo6yz8ww9zruajdnvp.webp'),
 (32,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804234/trtd3l2nnjyzsqmmxoki.webp'),
 (32,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804234/pcwvpap95liingga4bqz.webp'),
 (33,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804233/wuldonwdfobn2bxmslkw.webp'),
 (33,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804232/rd9epmzpttqu9ynz8gsk.webp'),
 (33,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804232/pslpjkuyanpoj8ycpfct.webp'),
 (33,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804231/b1zkqkbif9u2dfaoz3sk.webp'),
 (33,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804231/ykpaiivgjleojb4h7nsg.webp'),
 (34,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804230/jakwfdkhxfo9mjmieudf.webp'),
 (34,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804229/x4bauk1ghl7onuoej179.webp'),
 (34,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804229/lvz7mgxo4ya2dcpwfhpo.jpg'),
 (34,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804227/xmllo5pyuoleefbpuxlk.webp'),
 (34,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804227/cjzcia7mwkfk4v2hdjlb.webp'),
 (35,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804226/jwerk4fujyjbhahefqqq.webp'),
 (36,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804226/nebaqtljdotldr1dz6q1.jpg'),
 (36,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804225/fpo2am3yrobbgacdzvli.jpg'),
 (36,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804224/o1sqacdfjhwp7fvnqaez.jpg'),
 (37,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804224/iu7ved1inzdibdecsykf.webp'),
 (38,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804222/gnnowf4pb9cb9ph1mk7x.webp'),
 (38,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804222/owv31zuxn0i3dxq8ikn0.webp'),
 (38,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804221/vx90yvwhm4femqqn5inp.webp'),
 (38,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804221/rcbsdiymhh8pglrna9yo.webp'),
 (38,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804219/ixhzo7hot5urusskebqp.webp'),
 (38,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804219/cs2ne1vruzmk2aiz1lno.webp'),
 (39,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804218/xfpnawz9ikt2a3fclmvk.webp'),
 (39,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804217/hsf43imodxeezm5rffbe.webp'),
 (39,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804217/ehusvirj749mlft6clgd.webp'),
 (39,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804216/yk5btnsymb7mgz7uxnla.webp'),
 (39,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804216/lvkb1t0lcsnaovmvo6il.webp'),
 (40,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804215/mqohso1hps1mjc72d0wc.png'),
 (40,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804214/t3k7wa17trzrjyds0p7r.png'),
 (40,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804214/eyo6wkuhpcocwzauadui.png'),
 (40,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804212/zfigvbyx5kayerlvkqo6.png'),
 (40,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804212/xvtqylyyvboewkbuo9jm.png'),
 (41,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804211/mdal6pq9qi0zcc9npbuc.png'),
 (41,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804210/mmxp9asl9zadn28hxafq.png'),
 (41,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804210/odkkhdfq7oldm58m8lxg.png'),
 (41,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804209/vqigbiohxwahac1dzclm.png'),
 (41,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804208/wb5nse9d8krw7fs89stz.png'),
 (42,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804203/ksuqbmxeatyjor98y3nh.png'),
 (42,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804202/xufedwmo6p5qqaztgwmz.png'),
 (42,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804201/cbcwztvjlroxwgvhme41.png'),
 (42,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804200/nytxsoqh10hqudxqmiqm.png'),
 (43,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804205/yo6jkztqteweo0uqatcz.png'),
 (43,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804204/g6zdwnza6f3qsx8xoza8.png'),
 (43,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804203/dupasfuda03c6uev3smz.png'),
 (44,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804207/ezbuk3iowyw8s5mfwqlm.png'),
 (44,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804207/cccveleefxv1gaqtk07c.png'),
 (44,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804206/qiovnfobcbww8bluuia2.png'),
 (44,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804205/h8zwfawnerzfcro5fasj.png'),
 (45,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804200/blmm03d7a8qcfngvp0qc.png'),
 (45,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804199/undiahv9fwkabmhnlqex.png'),
 (45,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804198/ka1bskis3ccrmcnn6m0c.png'),
 (45,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804198/ovw3sjyrhkjy95i7ploo.png'),
 (46,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804197/k5lqf5fncm6xqq7cqmjk.png'),
 (46,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804196/sp2rtnavcuu4wc3dgxk8.png'),
 (46,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804196/awzwpeazrjpsmgbcw8pd.png'),
 (46,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804195/gnikwrvlmyzb9gpu8h9y.png'),
 (47,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804194/aat4cccxambkjfzn7pc2.png'),
 (47,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804194/sb7cz65l7xlzo7rj12ng.png'),
 (47,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804193/xctiy4yijfeyxtuwzqex.png'),
 (47,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804192/in6skgvjc74vqmrdm6eh.png'),
 (47,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804191/cppm91zpvgsgqnizeqpm.png'),
 (48,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804190/pwg5gukel2bxix38tjd9.png'),
 (48,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804190/c1weg8n8fpvkwxsqoj89.png'),
 (48,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804189/get9it6oghyeivluuufu.png'),
 (48,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804188/hzzmej9vja0239zqx2og.png'),
 (48,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804188/tofx7wq9astfd8cuw78r.png'),
 (49,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804187/i7cdid2sipmmwp4ifaje.png'),
 (49,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804186/admusbmosks0y9rrj8hz.png'),
 (49,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804186/esnpkai09qr7c1emx9d8.png'),
 (49,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804185/skkm4ihjtjh8jkbhfjm9.png'),
 (50,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804186/plwowvrzjzygp07olcyd.png'),
 (50,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804183/fdeguauwkmwi64jgv4da.png'),
 (50,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804183/gc1qblpos7j3cxw206ja.png'),
 (50,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804182/zogxundi8ny1vd0bx3xj.png'),
 (51,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804181/a9qdpl3qx5fwhkkwdfuo.png'),
 (51,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804181/vfvajzub8qevapmsqabp.png'),
 (51,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804180/ppw48dxgcajsebvsblln.png'),
 (51,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804179/fcwee2dyz43gzsxqmknr.png'),
 (52,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804178/ztoe98vd6nza79mmvh1w.png'),
 (52,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804178/bzfoemqy9oua9kn8yqmk.png'),
 (53,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804177/gydghdmdf4uptxylb6et.png'),
 (53,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804177/dxfwsafljqhj1qgz5w35.png'),
 (53,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804176/aj9pcjakkb279kldwzgi.png'),
 (53,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804175/hdiydey7vsbho9p1qasb.png'),
 (53,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804174/plundnwdrrbod8jp5wb6.png'),
 (53,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804174/s0jo8gntck9qwpuekhci.png'),
 (54,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804173/g8ec2da4sgp4dfjjbyob.png'),
 (54,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804172/anfbolinpl6w2wtchllz.png'),
 (54,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804172/umeyrwgtzaoqrndke0ey.png'),
 (54,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804171/fnr8h1q3kryblphhlspg.png'),
 (54,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804170/q9rndjgkdx8i6omerqu7.png'),
 (54,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804170/ibsjyxa4azup5jsimsaw.png'),
 (54,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804169/tovrlzd0tc0dpkfn9uln.png'),
 (55,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804168/gjzjuifm6x2ljn1v8c6b.png'),
 (55,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804167/xso54eq2kp3l7wypjam5.png'),
 (55,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804167/uwqgwhnn5uxb3x4ewajm.png'),
 (55,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804166/jeyevuu5h5pqjmws9gs5.png'),
 (55,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804165/ebcxcwf5tnn4fnkmmprm.png'),
 (56,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804164/hr3zz3bx0zamlspjztb8.png'),
 (56,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804164/tfot1boggcbsj7xjy0nn.png'),
 (56,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804163/zuj1rt6t9a1lmartnn1e.png'),
 (56,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804162/l0tljtngqoukuleiyjwu.png'),
 (56,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804162/x0kaqly76xuh6un0cog7.png'),
 (56,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804161/webtikj4hmltuulcor7k.png'),
 (57,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804160/ziepgjv7ugoatp9ci1wi.webp'),
 (57,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804160/zblvbjkb0ylrti2pb67x.webp'),
 (57,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804159/kunueffosryhmhx2jydk.webp'),
 (57,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804158/zxooszi0h9jfsejdj1gp.webp'),
 (58,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804158/hmghc2pwlczdtmhf9kgf.webp'),
 (58,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804157/lc2k1yotf1gb9syip8hx.webp'),
 (58,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804156/dmo35evujo5xlbn1rt8w.webp'),
 (58,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804155/p7uwxkaprgcsmxxqo5w4.webp'),
 (58,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804155/hsliivlurwohnvnud1d5.webp'),
 (59,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804154/pctfp2kh5z6pfvc1fnfq.webp'),
 (59,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804154/pe62qkf9ysvlmmfvmtqg.webp'),
 (59,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804152/ysml6iq8u0dilgz7dwry.webp'),
 (59,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804152/mwocr9byr3le2myni9h7.webp'),
 (59,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804152/lqz4rqpa1w25kllofypq.webp'),
 (60,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804151/gymyvufkyeu2iur3gmm5.webp'),
 (60,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804150/jezdfaby1otanwnmzoje.webp'),
 (60,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804149/laekb8hqki21rlsqxset.webp'),
 (60,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804148/stxzvwzg7zjqccozsnhq.webp'),
 (60,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804148/m9ycziqqdinbljreetgs.webp'),
 (61,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804148/usjzdou5hpnhjd6r2rz2.webp'),
 (61,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804147/eti8w6f2wjajl95trgoh.webp'),
 (61,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804146/ny5cmhql58dp3qp8wvwv.webp'),
 (61,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804145/k9iy5uarsih661shzikp.webp'),
 (62,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804144/ehczcye7tduozsb5pysl.webp'),
 (62,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804144/dg9cznxpz5meaoxaa2mw.webp'),
 (62,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804143/qbemnnkkyphz8sdf5gqz.webp'),
 (62,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804142/hofbtvx7ulexgzv4ptms.webp'),
 (62,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804142/ilokmgbpz7ahfx9vpqir.webp'),
 (63,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804141/hge83sa9je7ud9zcv4qr.webp'),
 (63,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804140/tcpi45xl2bhzzidead9p.webp'),
 (63,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804139/fcpfoby6qv3d4onf9hxa.webp'),
 (63,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804139/epuha3wilwcsv4wblku1.webp'),
 (63,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804138/ewashc4btpfb27puczdq.webp'),
 (64,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804137/bfdtilaxewb5gc1ct5lm.webp'),
 (64,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804137/apwmzdwc42jntohp8w85.webp'),
 (64,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804136/omv87tnepwquri3ans6o.webp'),
 (65,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804135/luuhpwxtfmfvio1o3jer.webp'),
 (65,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804135/vt88iqq2nys2mvrmwyuj.webp'),
 (65,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804134/ckvcckp89q8bjbmehh76.webp'),
 (65,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804133/fhexuj39bfsuytibuplw.webp'),
 (65,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804133/jy0bafqmb3pjzxo87553.webp'),
 (66,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804132/ur19688wksxrvg8s0j4w.webp'),
 (66,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804131/ijxzq2746wyp1e0d5rll.webp'),
 (66,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804131/enavqrerxeoiezpmuard.webp'),
 (66,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804130/ynb7c7jn0bnachicevft.webp'),
 (66,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804129/qsmdhzsrinu6hcxzq0pz.webp'),
 (67,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804128/pz5roe7vywru8udb5oow.jpg'),
 (67,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804127/nncxyx0whla0efmsvikg.webp'),
 (67,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804127/z3rtdzdvelkzogljfzuq.webp'),
 (67,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804126/oxxkzrhbhzdhn3ryuizr.webp'),
 (67,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804125/ejqplqac0rihherwo4x2.webp'),
 (68,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804122/gn109tff7bjcsjic7jo1.webp'),
 (68,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804121/d2tlttpyfvhw9rhmtmag.webp'),
 (68,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804121/hoeh2qq2rym1jcmbsktj.webp'),
 (68,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804120/lgtkhmptzrs56m7clzuz.webp'),
 (68,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804119/wetdrce2xboozfukgusu.webp'),
 (69,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804125/timkpuo9gfq0juigzsn5.webp'),
 (69,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804124/q97qcv2rx2vgtqucki8l.webp'),
 (69,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804123/vabtd0qs7lre3qrznqgl.webp'),
 (69,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804123/au22e81g0iducdeqelkx.webp'),
 (70,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804119/xyviffngwwze7l5ube6q.webp'),
 (70,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804118/dpkvlk73cugdjf69kek1.jpg'),
 (70,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804117/d3qtetj1iptdxztoydsm.webp'),
 (70,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804116/oig6lnxuz810yc7zfvm5.webp'),
 (70,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804116/b4llz8hlsfwk6qdipppu.webp'),
 (71,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804113/c75ugtxtapfbixkpmf0b.webp'),
 (71,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804114/yruhfsl6rnaznlzyidmd.webp'),
 (71,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804114/xbhoqh32dvxcou6j0wpp.webp'),
 (71,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804115/hqeuayrmfunuf0l4vih7.webp'),
 (72,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804111/ah4du673br8jgymbp8ju.webp'),
 (72,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804111/q8f02gv1plx5v5r39asd.webp'),
 (72,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804110/ygcj3rqxhwcz5g2o6umo.webp'),
 (72,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804109/isz3iflvcl0qf61f4axl.webp'),
 (72,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804112/cz7gkimg2iljtiqso0ib.webp'),
 (73,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804108/oebukcthuqixs9abp6ur.webp'),
 (73,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804107/scog0z5gef3lixihk3bx.webp'),
 (73,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804108/v05538xlggidzel2nqtz.webp'),
 (73,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804106/titn6hfi5iycujftyr2n.webp'),
 (73,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804108/p7zy7ek4n3alnh4ilex9.webp'),
 (74,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804105/uwqfo0xmwjpbijjgadlz.webp'),
 (74,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804105/dfznhqp6fxnmj0usqnta.webp'),
 (74,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804104/acc9ftg4va9kzszjbhn6.jpg'),
 (74,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804103/vuqm7iva1pqy5reey9e0.webp'),
 (74,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804102/zmwpr0ayyw3hrvja5dr4.jpg'),
 (75,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804101/sdtsjicsscnbj60epx4g.webp'),
 (75,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804101/unlxyoxc8wmybset80fp.webp'),
 (75,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804100/vnunt6nxn3dwqt1lth6j.webp'),
 (75,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804100/z29gsnp7xgiitqxjjnas.webp'),
 (76,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804099/nn4vvynesitjpqbdtfk7.webp'),
 (76,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804098/ntwsxuhsfgcf8rwvdrnc.webp'),
 (76,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804097/yxaw6hayepbxy3hullxr.jpg'),
 (76,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804097/cesykpl6p71fxcsdtsfg.jpg'),
 (76,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804096/xv3yznzq1ksplnwrnqxl.jpg'),
 (77,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804095/hjav9bnxoavk0dwkoaqs.webp'),
 (77,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804095/hjloavbpyiyvavrb2w1p.webp'),
 (77,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804094/maroevyy003tq7nodnt9.webp'),
 (77,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804093/sqmt9bz1nxic6uc3ybqn.webp'),
 (77,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804092/xryqv26dkakksmzio3tc.webp'),
 (78,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804092/c7c5ejilepolvyxauzvq.jpg'),
 (78,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804091/tkrvjtu0tixzzxgoxngh.webp'),
 (78,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804091/jnc1ty7vgvzmccl5cpth.webp'),
 (78,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804090/jxdzeguavpdsuqctgt5y.webp'),
 (78,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804089/yjdg7qpj5gfzdh5ztmxw.webp'),
 (78,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804088/wtcfac4ejafjomfldo8p.webp'),
 (79,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804087/ovgduxlcwdjdj24hh1tg.jpg'),
 (79,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804087/rb1y7g6enoivomyxwtwt.webp'),
 (79,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804086/thgnjz4q6cfef7uk5mdg.webp'),
 (79,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804085/jaoy7gzw0da3lgeaetxf.webp'),
 (79,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804085/dtosvxdnun0qicvglrdw.webp'),
 (79,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804084/cs0bzfqkwdvu243aogmj.webp'),
 (80,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804056/el2p1kr9wgkblnmhp5z5.jpg'),
 (80,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804054/xi2wgjtc3bxqizigzq8n.webp'),
 (80,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804053/r7vvlpnwempaej6uj5o3.webp'),
 (80,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804052/nocyjmghvewtvmmw7pem.webp'),
 (80,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804055/uqcdjbnglaj9iqwlravj.jpg'),
 (80,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804055/abwemyjqbhnh3ehwatym.jpg'),
 (81,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804714/l8smgv833qnje4u4s4qq.webp'),
 (81,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804712/gle7bpuwo0glh9ze0akp.webp'),
 (81,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804711/wotuua59oevc0odjsult.webp'),
 (81,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804710/qvqoclnxtgumnwcmearl.webp'),
 (81,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804708/l0819jnok5dp70txo5ex.webp'),
 (82,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804727/ufudxf83fe6kl1drpbdi.jpg'),
 (83,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804751/lrnywktyulnjpcthaybu.webp'),
 (83,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804750/aq7akju9yf0jmwpruchr.webp'),
 (83,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804748/e933oc25s1jxfokbx4tw.webp'),
 (83,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804746/ha4yotvw7mspc3z8vvfg.webp'),
 (83,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804745/akbbwfpchzhf0er5lvhe.webp'),
 (84,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804760/netpa20v4giastzwsba5.webp'),
 (84,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804759/jrjul841ub7jhnphgzcu.webp'),
 (84,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804757/tezuobmevy2kejgxeynw.webp'),
 (84,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804755/x4rvspsvvrkxg7bcgzpf.webp'),
 (84,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804762/cah92pbtqdhrliaj0cak.webp'),
 (85,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804777/xox3n767nqdcsjesgnqu.webp'),
 (85,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804773/x3rpdcidxm9381hfikdl.webp'),
 (85,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804771/cvyb51rzxr0wswwidbli.webp'),
 (85,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804770/wvdixurabozvobrz2gmy.webp'),
 (85,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804775/yronfui6t7kg7odkhu2g.webp'),
 (86,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804067/xkejmwyrna4dn4txu2q7.png'),
 (86,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804065/kvm4agkqcjj8c7lblwkh.png'),
 (86,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804064/ccs4dr0fmhyxjg8h2ucs.png'),
 (86,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804064/ohfm7qtjjbsdb72jc6cw.png'),
 (86,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804067/henjyxnm6avxvh3qqwl6.png'),
 (87,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804071/qf6flynzfcmgmffkohcm.png'),
 (87,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804070/i2lw67k1twnigkff6o8d.png'),
 (87,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804069/noojhsfnwofsuzwma4ft.png'),
 (87,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804069/w140mdjnsmfilnr5dc6g.png'),
 (87,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804068/hfv56vde7bkxhudbiy5d.png'),
 (88,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804074/bbgiq1yyyttmhg48uedo.png'),
 (88,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804074/j95yxzptg5bblhjvlpfy.png'),
 (88,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804073/lrxqyut5hcrbchdvv1ua.png'),
 (88,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804072/mgwdeetdyayog9evtdcy.png'),
 (88,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804071/pzhqasqzy043sfwnegyb.png'),
 (89,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804075/ai3bxw3ndrjpcu7o2zik.png'),
 (90,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804079/bu9kgicheg1pugodante.png'),
 (90,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804077/sf2b5nagalkmpmxtf0y5.png'),
 (90,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804077/hr368w769k8pxojm0gtk.png'),
 (90,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804076/vxlvmetzrbfwdinmn2j0.png'),
 (90,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804079/yhrwcfjnyyyqyzggomut.png'),
 (91,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804083/h4wd6zjnflqcourtchdr.png'),
 (91,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804082/foavitbeety85pr4rlln.png'),
 (91,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804082/xexfixhngqnyjjip9nca.png'),
 (91,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804081/nbpq7ugokpifkyuicx5p.png'),
 (91,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804080/xsxnwsqozhb2wtefb2sb.png'),
 (91,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804080/m7jsqv35av5ttymwskwn.png'),
 (92,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804057/zmqq670yrj6wee0y9iar.png'),
 (92,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804058/y5jksb1vpjl9xkqnidbd.png'),
 (92,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804058/ffzkgrmm8orgqy3bxdkw.png'),
 (92,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804059/ch78fupajuihgbfjw8kj.png'),
 (92,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804060/m0gmcikk7dti5lnw0bgo.png'),
 (92,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804061/u0xza6yzlmt0cvbsnu2x.png'),
 (92,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804062/vbfg27osif21slpion1j.png'),
 (92,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804063/eahlxa3lbgdw8axna1vz.png'),
 (93,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804036/brune8unix4qupmwqmgz.png'),
 (94,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804036/rz7rfqodfyb68ctwigin.png'),
 (94,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804034/caohhfyila1uxw0kflig.png'),
 (94,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804034/has5ge8bctlgqrun8uux.png'),
 (94,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804033/rd5v274ij3aoegbouks7.png'),
 (94,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804032/yc6hlrddkw5jfrnxloou.png'),
 (95,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804027/k00qdlxmgqjbwhtkim4a.png'),
 (96,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804028/s2skdlrloybggdv7whfj.png'),
 (96,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804023/cov1f1jwvfgysmdchdyk.png'),
 (96,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804022/rkkv0xefv4j7ycpcoraa.png'),
 (96,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804021/avvv9x7tkn7zwyzmtqg3.png'),
 (96,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804020/n9uiq1tzwtb4fzpqefcl.png'),
 (96,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804019/yu7ywizgotwurjjntboi.png'),
 (96,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804018/bapd1vf0pwozlwjcdg1m.png'),
 (96,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804018/b4hmoh30bbfmjlnahkht.png'),
 (97,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804017/efa5juqc2ifauhz4cqbp.jpg'),
 (97,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804014/o8q3wnhokjrhetbb91p7.jpg'),
 (97,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804016/wuxzk6kytawm0n4phqlp.jpg'),
 (97,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804016/ltd2ezihlozjduumtj01.webp'),
 (97,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804014/gwnpppxx3w49mgh9wwhz.jpg'),
 (97,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804014/hffciyachjdnrop1mjlf.jpg'),
 (98,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804027/kn2gn8vjubq5sevxdble.jpg'),
 (98,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804027/uowjdoki6teara0icysb.jpg'),
 (98,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804025/mvq0i9uoypz2mtbd4lub.webp'),
 (98,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804024/sj9w9si2tvfs8zehhzwx.webp'),
 (98,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804025/vkughpae7u7a7gjyxo8j.jpg'),
 (99,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804028/hjbbgcdtuojmekqn76z4.jpg'),
 (99,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804029/pcfdygvuebbee24cwggo.webp'),
 (99,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804030/dbpfqwod1qwvtusmao7o.webp'),
 (99,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804031/fcjrbny3usmlnzkmfnkr.jpg'),
 (99,'https://res.cloudinary.com/dymj7rvrd/image/upload/v1741804032/xuocpghk18hk7pltdnba.jpg');
 /*
  user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(255) UNIQUE NOT NULL,
    hashed_password NVARCHAR(255) NOT NULL,
    first_name NVARCHAR(255),
    last_name NVARCHAR(255),
    phone NVARCHAR(20) UNIQUE,
    mail NVARCHAR(255) UNIQUE,
    date_created DATETIME DEFAULT GETDATE(),
    date_modified DATETIME DEFAULT GETDATE(),
    role NVARCHAR(50) NOT NULL DEFAULT 'customer'
	*/
 INSERT INTO users(username, hashed_password, first_name, last_name , phone, mail , role) values 
 ('admin', 'admin123', 'admin' , 'admin' , '0325886004', 'quannade180782@fpt.edu.vn', 'admin'),
 ('admin1', 'admin123', 'admin' , 'admin' , '012348234324', 'tanphong0730@gmail.com', 'admin'),
 ('hoangviet', 'customer123', 'hoang' , 'viet' , '010234234324', 'vietthde180482@fpt.edu.vn', 'customer'),
 ('tanphong', 'customer123', 'tan' , 'phong' , '012336424324', 'phongttde180770@fpt.edu.vn', 'customer'),
 ('anhquan', 'customer123', 'anh' , 'quan' , '01234244324', 'vietthde1804882@fpt.edu.vn', 'customer'),
 ('dinhtien', 'customer123', 'dinh' , 'tien' , '01232424324', 'vietthde18340482@fpt.edu.vn', 'customer'),
 ('sinhvien', 'customer123', 'sinh' , 'vien' , '01234234324', 'vietthde1820482@fpt.edu.vn', 'customer')

ALTER TABLE users ADD  verification_token VARCHAR(255);
ALTER TABLE users ADD  verified bit DEFAULT 0;

update users set verified = 0;
alter table products add views int default 0;
select * from users

DECLARE @i INT = 1;

WHILE @i <= 99
BEGIN
    INSERT INTO product_inventory(product_id, quantity, created_at, modified_at)
    VALUES (
        @i, -- user_id, có thể thay thế bằng user_id thực tế nếu có
        ROUND(RAND() * (200 - 50) + 50, 2), -- total, giá trị ngẫu nhiên trong khoảng từ 50 đến 200
        GETDATE(), -- created_at
        GETDATE()  -- modified_at
    );

    SET @i = @i + 1;  -- Tăng i lên 1 để thực hiện chèn cho sản phẩm tiếp theo
END;