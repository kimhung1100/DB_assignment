DELIMITER //

CREATE PROCEDURE GetBooksByPublisher(
    IN p_publisher_id INT
)
BEGIN
    -- Truy vấn dữ liệu từ bảng BOOK và PUBLISHER
    SELECT
        b.ISBN,
        b.title,
        b.book_cover,
        b.description,
        b.dimensions,
        b.print_length,
        b.price,
        b.publication_date,
        b.publisher,
        p.publisher_name
    FROM
        BOOK b
    JOIN
        PUBLISHER p ON b.publisher = p.publisher_id
    WHERE
        b.publisher = p_publisher_id
    ORDER BY
        b.publication_date DESC; -- Sắp xếp theo ngày xuất bản từ mới đến cũ

END //

DELIMITER ;
-- Gọi thủ tục và truyền mã nhà xuất bản
CALL GetBooksByPublisher(1); -- Thay thế 1 bằng mã nhà xuất bản cần tìm kiếm



DROP PROCEDURE IF EXISTS GetBooksByCategoryAndPriceRange;
DELIMITER //

CREATE PROCEDURE GetBooksByCategoryAndPriceRange(
    IN p_category_id INT,
    IN p_min_price INT,
    IN p_max_price INT
)
BEGIN
    -- Truy vấn dữ liệu từ bảng sách, bảng thuộc tính danh mục, và bảng danh mục
    SELECT
        b.ISBN,
        b.title,
        b.price,
        MAX(c.category_name) AS category_name
    FROM
        BOOK b
    JOIN
        BELONG_TO_CATEGORY bc ON b.ISBN = bc.ISBN
    JOIN
        CATEGORY c ON bc.category_id = c.category_id
    WHERE
        c.category_id = p_category_id
        AND b.price BETWEEN p_min_price AND p_max_price
    GROUP BY
        b.ISBN, b.title, b.price
    HAVING
        COUNT(b.ISBN) > 0
    ORDER BY
        b.price ASC; -- Sắp xếp theo giá tăng dần

END //

DELIMITER ;

-- Gọi thủ tục và truyền tham số
CALL GetBooksByCategoryAndPriceRange(3, 50, 200000); -- Thay thế bằng tham số thực tế
