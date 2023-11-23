
SELECT * FROM INVOICE;

DELIMITER //

CREATE PROCEDURE CalculateAndCheckMonthlyRevenue(
    IN p_year INT,
    IN p_month INT
)
BEGIN
    DECLARE totalRevenue DECIMAL(10, 2);
    -- Check if year and month are valid
    IF p_year < 1900 OR p_year > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid year parameter';
    END IF;

    IF p_month < 1 OR p_month > 12 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid month parameter';
    END IF;
    -- Calculate total revenue
    SELECT IFNULL(SUM(total_cost), 0) INTO totalRevenue
    FROM INVOICE
    WHERE YEAR(timestamp) = p_year AND MONTH(timestamp) = p_month;

    -- Check if there is revenue
    IF totalRevenue > 0 THEN
        SELECT 'Total revenue for ', p_month, '/', p_year, ' is: ', totalRevenue AS Result;
    ELSE
        SELECT 'No revenue for ', p_month, '/', p_year AS Result;
    END IF;
END //

DELIMITER ;

CALL CalculateAndCheckMonthlyRevenue(2023, 11);

DROP procedure if exists CalculateTotalQuantityInPriceRange;
DELIMITER //

CREATE PROCEDURE CalculateTotalQuantityInPriceRange(
    IN p_category_id INT,
    IN p_min_price INT,
    IN p_max_price INT
)
BEGIN
    DECLARE totalQuantity INT;
    DECLARE categoryExists INT;

    -- Check if category exists
    SELECT COUNT(*) INTO categoryExists
    FROM CATEGORY
    WHERE category_id = p_category_id;

    -- If category does not exist, raise an error
    IF categoryExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid category ID';
    END IF;

    -- Check if price range is valid
    IF p_min_price < 0 OR p_max_price < 0 OR p_min_price > p_max_price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid price range';
    END IF;



    -- Calculate total quantity
    SELECT COUNT(b.ISBN) INTO totalQuantity
    FROM BELONG_TO_CATEGORY bc
    JOIN BOOK b ON bc.ISBN = b.ISBN
    WHERE bc.category_id = p_category_id
        AND b.price BETWEEN p_min_price AND p_max_price
    GROUP BY bc.category_id;

    SELECT totalQuantity AS Result;
    -- Check if there is any book in the given price range
#     IF totalQuantity > 0 THEN
#         SELECT 'Total quantity of books in the price range is: ', totalQuantity AS Result;
#     ELSE
#         SELECT 'No books in the specified price range or category' AS Result;
#     END IF;
END //

DELIMITER ;

CALL CalculateTotalQuantityInPriceRange(3, 0, 200000);

