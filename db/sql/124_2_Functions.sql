DROP FUNCTION IF EXISTS StatFavoriteBooks;
DELIMITER //

CREATE FUNCTION StatFavoriteBooks(
    CUSTOMER_ID INT,
    p_start DATETIME,
    p_end DATETIME
) RETURNS INT
BEGIN
    DECLARE max_book_count INT;

    -- Thống kê số lượng sách trong thể loại yêu thích của khách hàng trong khoảng thời gian
    SELECT
        MAX(book_count) INTO max_book_count
    FROM (
        SELECT
            COUNT(*) AS book_count
        FROM
            BELONG_TO_ORDER bo
        JOIN
            BOOK b ON bo.ISBN = b.ISBN
        JOIN
            BELONG_TO_CATEGORY bc ON b.ISBN = bc.ISBN
        JOIN
            CATEGORY c ON bc.category_id = c.category_id
        JOIN
            ORDERS o ON bo.order_id = o.order_id
        JOIN
            INVOICE i ON o.order_id = i.order_id
        WHERE
            i.timestamp BETWEEN p_start AND p_end
            AND o.account_id = CUSTOMER_ID
        GROUP BY
            c.category_name
    ) AS subquery;

    -- Trả về kết quả thống kê (trả về giá trị lớn nhất)
    RETURN max_book_count;
END //

DELIMITER ;



SELECT StatFavoriteBooks(1, '2023-1-1', '2023-12-31') AS Result;

# SELECT * FROM ORDERS;