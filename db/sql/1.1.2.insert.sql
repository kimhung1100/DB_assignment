
-- BOOKS TABLES

-- CATEGORY

INSERT INTO CATEGORY (category_name) VALUES
    ('Văn học'),
    ('Khoa học Kỹ thuật'),
    ('Sách giáo khoa'),
    ('Kinh tế'),
    ('Lịch sử - Địa Lý - Tôn giáo'),
    ('Nuôi dạy con'),
    ('Chính trị - Pháp lý - Triết học'),
    ('Từ điển'),
    ('Văn hoá - Nghệ thuật - Du lịch'),
    ('Thể dục thể thao - Giải trí'),
    ('Âm nhạc - Mỹ thuật - Thời Trang'),
    ('Báo - Tạp chí'),
    ('Giáo trình'),
    ('Làm vười - Thú nuôi');

# SELECT * FROM CATEGORY;

-- BOOK
CREATE TABLE BOOK (
    ISBN VARCHAR(13) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    book_cover ENUM('hardcover', 'paperback') NOT NULL,
    description LONGTEXT NOT NULL,
    dimensions VARCHAR(20) NOT NULL,
    print_length INT NOT NULL,
    price INT NOT NULL,
    publication_date DATE NOT NULL,
    publisher INT NOT NULL,
    FOREIGN KEY (publisher) REFERENCES PUBLISHER(publisher_id)
);

INSERT INTO BOOK (ISBN, title, book_cover, description, dimensions, print_length, price, publication_date, publisher)
VALUES
    ('8935092820392', 'Phương Pháp Giải Các Chủ Đề Căn Bản Đại Số 10 (Biên Soạn Theo Chương Trinh GDPT Mới) (Dùng Chung Cho Các Bộ SGK Hiện Hành)',
     'paperback', 'Phương Pháp Giải Các Chủ Đề Căn Bản Đại Số 10 (Biên Soạn Theo Chương Trinh GDPT Mới) (Dùng Chung Cho Các Bộ SGK Hiện Hành)

Nhằm mục đích giúp các bạn học sinh lớp 10, lớp 11, lớp 12 có nền tảng Toán căn bản ngay từ lúc vào THPT, bắt đầu lớp 10 nhiều bỡ ngỡ về kiến thức và cách giảng dạy rồi lên lớp 11, lớp 12 chuẩn bị thi Tốt nghiệp, tuyển sinh Cao đẳng, Đại học.

Từ nền Toán căn bản này các bạn có thể nâng cao dần dần, bổ sung và mở rộng kiến thức và phương pháp giải Toán, rèn luyện kỹ năng làm bài và từng bước giải đúng, giải gọn các bài tập, các bài toán kiểm tra, thi cử.

Cuốn Phương Pháp Giải Các Chủ Đề Căn Bản Đại Số 10 có 17 chủ đề với nội dung là phân dạng Toán, tóm tắt kiến thức và phương pháp giải, các chú ý, phần tiếp theo là các bài toán chọn lọc căn bản minh họa với nhiều dạng loại và mức độ, phần cuối là 8 bài tập có hướng dẫn hay đáp số.

Mã hàng	8935092820392
Nhà Cung Cấp	CÔNG TY CỔ PHẦN SÁCH VÀ VĂN HÓA PHẨM MIỀN NAM
Tác giả	Lê Hoành Phò
NXB	Đại Học Quốc Gia Hà Nội
Năm XB	2022
Trọng lượng (gr)	332
Kích Thước Bao Bì	24 x 17 x 1.2 cm
Số trang	323
Hình thức	Bìa Mềm
Sản phẩm bán chạy nhất	Top 100 sản phẩm Tham Khảo Lớp 10 bán chạy của tháng
Giá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...
Chính sách khuyến mãi trên Fahasa.com không áp dụng cho Hệ thống Nhà sách Fahasa trên toàn quốc
Phương Pháp Giải Các Chủ Đề Căn Bản Đại Số 10 (Biên Soạn Theo Chương Trinh GDPT Mới) (Dùng Chung Cho Các Bộ SGK Hiện Hành)

Nhằm mục đích giúp các bạn học sinh lớp 10, lớp 11, lớp 12 có nền tảng Toán căn bản ngay từ lúc vào THPT, bắt đầu lớp 10 nhiều bỡ ngỡ về kiến thức và cách giảng dạy rồi lên lớp 11, lớp 12 chuẩn bị thi Tốt nghiệp, tuyển sinh Cao đẳng, Đại học.

Từ nền Toán căn bản này các bạn có thể nâng cao dần dần, bổ sung và mở rộng kiến thức và phương pháp giải Toán, rèn luyện kỹ năng làm bài và từng bước giải đúng, giải gọn các bài tập, các bài toán kiểm tra, thi cử.

Cuốn Phương Pháp Giải Các Chủ Đề Căn Bản Đại Số 10 có 17 chủ đề với nội dung là phân dạng Toán, tóm tắt kiến thức và phương pháp giải, các chú ý, phần tiếp theo là các bài toán chọn lọc căn bản minh họa với nhiều dạng loại và mức độ, phần cuối là 8 bài tập có hướng dẫn hay đáp số.',
     '24 x 17 x 1.2 cm', 323, 93500, '2022-01-01', 1);

INSERT INTO BOOK VALUES ('9786043216899', 'Ôn Tập Và Kiểm Tra Tiếng Anh 12 - Tập 2',
                         'paperback', 'CẤU TRÚC SÁCH:

 Bộ sách Ôn tập và kiểm tra tiếng Anh 12 được chia làm 2 tập:

- Tập 1 có nội dung bám sát chương trình sách giáo khoa học kì 1

- Tập 2 có nội dung bám sát chương trình sách giáo khoa học kì 2.

NỘI DUNG SÁCH:

Phần 1: Chương trình sách giáo khoa mới

Phần 2: Chương trình sách giáo khoa hiện hành

* Mỗi Unit trong cuốn Ôn tập và kiểm tra tiếng Anh 12 bao gồm:

I. Vocabulary (Từ vựng)

II. Structures (Cấu trúc)

III. Grammar (Ngữ pháp)

IV. Practice exercises (Bài tập thực hành)

Test 1 (Bài tự luận)

Test 2 (Bài trắc nghiệm)

Ngoài ra, cuốn sách còn cả nội dung ôn tập cho các bài kiểm tra định kỳ và bài kiểm tra cuối học kỳ theo phân phối chương trình của Bộ giáo dục và Đào tạo.

Với cuốn sách dày gần 500 trang, được biên soạn theo hướng cơ bản và nâng cao với nhiều dạng bài tập thường gặp trong các bài kiểm tra và bài thi hiện nay. Chắc chắn đây sẽ là cuốn tư liệu tham khảo hữu ích cho các em học sinh trong quá trình học tập và ôn luyện.

Mã hàng	9786043216899
Cấp Độ/ Lớp	Lớp 12
Cấp Học	Cấp 3
Nhà Cung Cấp	Công Ty Cổ Phần Công Nghệ Giáo Dục Trực Tuyến Aladanh
Tác giả	Trang Anh, Minh Trang
NXB	NXB Hồng Đức
Năm XB	2021
Trọng lượng (gr)	690
Kích Thước Bao Bì	27 x 19 x 1.8 cm
Số trang	406
Hình thức	Bìa Mềm
Sản phẩm bán chạy nhất	Top 100 sản phẩm Tham Khảo Lớp 12 bán chạy của tháng
Giá sản phẩm trên Fahasa.com đã bao gồm thuế theo luật hiện hành. Bên cạnh đó, tuỳ vào loại sản phẩm, hình thức và địa chỉ giao hàng mà có thể phát sinh thêm chi phí khác như Phụ phí đóng gói, phí vận chuyển, phụ phí hàng cồng kềnh,...
Chính sách khuyến mãi trên Fahasa.com không áp dụng cho Hệ thống Nhà sách Fahasa trên toàn quốc
CẤU TRÚC SÁCH:

 Bộ sách Ôn tập và kiểm tra tiếng Anh 12 được chia làm 2 tập:

- Tập 1 có nội dung bám sát chương trình sách giáo khoa học kì 1

- Tập 2 có nội dung bám sát chương trình sách giáo khoa học kì 2.

NỘI DUNG SÁCH:

Phần 1: Chương trình sách giáo khoa mới

Phần 2: Chương trình sách giáo khoa hiện hành

* Mỗi Unit trong cuốn Ôn tập và kiểm tra tiếng Anh 12 bao gồm:

I. Vocabulary (Từ vựng)

II. Structures (Cấu trúc)

III. Grammar (Ngữ pháp)

IV. Practice exercises (Bài tập thực hành)

Test 1 (Bài tự luận)

Test 2 (Bài trắc nghiệm)

Ngoài ra, cuốn sách còn cả nội dung ôn tập cho các bài kiểm tra định kỳ và bài kiểm tra cuối học kỳ theo phân phối chương trình của Bộ giáo dục và Đào tạo.

Với cuốn sách dày gần 500 trang, được biên soạn theo hướng cơ bản và nâng cao với nhiều dạng bài tập thường gặp trong các bài kiểm tra và bài thi hiện nay. Chắc chắn đây sẽ là cuốn tư liệu tham khảo hữu ích cho các em học sinh trong quá trình học tập và ôn luyện.',
                         '27 x 19 x 1.8 cm',
                         406,
                         150000,
                         '2021-1-1',
                         2);

SELECT * FROM BOOK;
-- BOOK IMAGE
INSERT INTO IMAGE_BOOK(ISBN, img_link) VALUES ('8935092820392','https://cdn0.fahasa.com/media/flashmagazine/images/page_images/phuong_phap_giai_cac_chu_de_can_ban_dai_so_10_bien_soan_theo_chuong_trinh_gdpt_moi_dung_chung_cho_cac_bo_sgk_hien_hanh/2023_10_28_10_45_35_1-390x510.jpg');
INSERT INTO IMAGE_BOOK(ISBN, img_link) VALUES ('9786043216899', 'https://cdn0.fahasa.com/media/catalog/product/9/7/9786043216899.jpg');


-- AUTHOR

INSERT INTO AUTHOR(author_name) VALUES ('Nhiều tác giả');
INSERT INTO AUTHOR(author_name) VALUES ('Trang Anh');
INSERT INTO AUTHOR(author_name) VALUES ('Minh Trang1');



-- PUBLISHER
INSERT INTO PUBLISHER(publisher_name) VALUES ('ĐHQG Hà Nội');
INSERT INTO PUBLISHER(publisher_name) VALUES ('NXB Hồng Đức');

SELECT * FROM PUBLISHER;

-- BELONG TO CATEGORY

INSERT INTO BELONG_TO_CATEGORY VALUES (3, '8935092820392');

INSERT INTO BELONG_TO_CATEGORY VALUES (3, '9786043216899');
INSERT INTO BELONG_TO_CATEGORY VALUES (13, '9786043216899');


-- WRITE_BOOK

INSERT INTO WRITE_BOOK VALUES (1, '8935092820392');

INSERT INTO WRITE_BOOK VALUES (2, '9786043216899');
INSERT INTO WRITE_BOOK VALUES (6, '9786043216899');

SELECT * FROM AUTHOR;

-- ________________________________________________________________
-- BRANCH - EMPLOYEE TABLES

-- BRANCH

INSERT BRANCH VALUE (1, 'Cơ sở Lý Thường Kiệt', 268, 'Lý Thường Kiệt', 'Phường 14', 'Quận 10', 'TPHCM', '+84123456789');

-- EMPLOYEE

INSERT INTO EMPLOYEE VALUES (1, 'hung.bui@hcmut.edu.vn', 'Hưng', 'Bùi Kim','male','2000-1-1', '268', 'Lý Thường Kiệt', 'Phường 14', 'Quận 10','TPHCM', null, '+84123456789', '1234');

-- EMPLOYEE_BELONG_TO_BRANCH

INSERT INTO EMPLOYEE_BELONG_TO_BRANCH VALUES (1, 1, now());

-- BOOK BRANCH EMP TABLES
-- IMPORT_EXPORT_FORM

INSERT INTO IMPORT_EXPORT_FORM VALUES (1, now(), 'Import', 1, 1);
INSERT INTO IMPORT_EXPORT_FORM(timestamp, type, employee_id, branch_id)
VALUES (now(), 'Import', 1, 1);

SELECT * FROM IMPORT_EXPORT_FORM;
-- BOOK_IN_FORM
INSERT INTO BOOK_IN_FORM VALUES (1, '8935092820392', 10);
INSERT INTO BOOK_IN_FORM VALUES (1, '9786043216899', 20);

-- BOOK_BELONG_TO_BRANCH

INSERT INTO BOOK_BELONG_TO_BRANCH VALUES (1, '8935092820392', 10);
INSERT INTO BOOK_BELONG_TO_BRANCH VALUES (1, '9786043216899', 20);

-- --------------------------------------------------------------
-- CUSTOMER

INSERT INTO CUSTOMER VALUES (1,'anh.nguyen@hcmut.edu.vn', 'Anh', 'Nguyễn', 'female', '2005-1-1', '+840123432198', '123456');
INSERT INTO CUSTOMER(email, fname, lname, gender, birth_date, phone_number, password)
VALUES ('Einstein@gmail.com', 'Einstein', 'Nguyễn', 'male', '2005-1-1', '+840123432198', '123456');
-- DELIVERY_ADDRESS

INSERT INTO DELIVERY_ADDRESS VALUES(1, 1,
                                    '123',
                                    'Đồng Khởi',
                                    'Phường Lộc Thọ', 'Quận 1', 'TPHCM', '+840123432198', 'Anh', 'Nguyễn');

INSERT INTO DELIVERY_ADDRESS VALUES(1, 2,
                                    '123',
                                    'Đồng Khởi',
                                    'Phường Lộc Thọ', 'Quận 1', 'TPHCM', '+841234123131', 'Lễ', 'Nguyễn');


-- VOUCHER

INSERT INTO VOUCHER VALUES(1, 'MUNGKHAITRUONG', now(), DATE_ADD(NOW(), INTERVAL 1 MONTH), 200000, 1, FALSE, 0, TRUE, 50000, FALSE);


-- ORDERS

INSERT INTO ORDERS value (1, 'pending', 1, 1);

-- INVOICE

INSERT INTO INVOICE(timestamp, payment_method, delivery_fee, order_id, total_cost)
VALUES (now(), 'COD', 30000, 1, 15000+93500);

-- BELONG TO ORDERS

INSERT INTO BELONG_TO_ORDER(order_id, ISBN, quantity, price)
VALUES(1, '8935092820392', 1, 93500);
INSERT INTO BELONG_TO_ORDER(order_id, ISBN, quantity, price)
VALUES(1, '9786043216899', 1, 150000);

-- USED_VOUCHER

INSERT INTO USED_VOUCHER(order_id, voucher_id) VALUES (1, 1);

-- AFTER BUY, REFUND, RATING, LIKE
-- REFUND_REQUEST
INSERT INTO REFUND_REQUEST(order_id, request_id, status, timestamp, return_reason, account_id, img_link)
VALUES (1, 1, 'pending', now(), 'Mua nhầm', 1, null);

-- RATING
INSERT INTO RATING(rating_points, timestamp, status, comment, ISBN, account_id)
VALUES (5, now(), 'pending approval', 'Sách hay', '8935092820392', 1);

-- RATING_IMG
INSERT INTO RATING_IMAGE(rating_id, img_link)
VALUES (1, 'https://cdn0.fahasa.com/media/flashmagazine/images/page_images/phuong_phap_giai_cac_chu_de_can_ban_dai_so_10_bien_soan_theo_chuong_trinh_gdpt_moi_dung_chung_cho_cac_bo_sgk_hien_hanh/2023_10_28_10_45_35_2-390x510.jpg');

-- LIKE_RATING

INSERT INTO LIKE_RATING(account_id, rating_id) VALUES (4, 1);


SHOW TABLES;


-- Iterate through each table and count records
SHOW TABLES;

-- Iterate through each table and count records
SELECT table_name, (SELECT COUNT(*) FROM TABLE_NAME) as count_records
FROM information_schema.tables
WHERE table_schema = 'online-bookstore';






