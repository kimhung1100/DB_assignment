DROP FUNCTION IF EXISTS GetMonthlyRevenue;
DELIMITER //

CREATE FUNCTION GetMonthlyRevenue(
    p_year INT,
    p_month INT
)
RETURNS DECIMAL(10, 2)
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

    -- Return the total revenue
    RETURN totalRevenue;
END //

DELIMITER ;


SELECT GetMonthlyRevenue(2023, 11) AS Result;
