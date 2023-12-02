DROP PROCEDURE IF EXISTS GetBooksByCategoryAndPriceRange;
DELIMITER //

CREATE PROCEDURE GetBooksByCategoryAndPriceRange(
    IN p_category_id INT,
    IN p_min_price INT,
    IN p_max_price INT
)
BEGIN
    -- Declare a variable to check if the category exists
    DECLARE category_exists INT DEFAULT 0;

    -- Check if the specified category exists
    SELECT COUNT(*) INTO category_exists FROM CATEGORY WHERE category_id = p_category_id;

    -- Check if the category exists
    IF category_exists > 0 THEN
        -- Category exists, proceed with the main query
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
    ELSE
        -- Category does not exist, return a message or handle accordingly
        SELECT 'Category does not exist' AS message;
    END IF;

END //

DELIMITER ;


-- Gọi thủ tục và truyền tham số
CALL GetBooksByCategoryAndPriceRange(3, 50, 200000);

-- Trường hợp không có Category
CALL GetBooksByCategoryAndPriceRange(20, 50, 200000);