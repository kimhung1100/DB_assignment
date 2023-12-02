DROP PROCEDURE IF EXISTS GetAuthorsWithBooksSold;
DELIMITER //

CREATE PROCEDURE GetAuthorsWithBooksSold(
    IN p_start_time DATETIME,
    IN p_end_time DATETIME,
    IN p_N INT
)
BEGIN
    -- Declare variables
    DECLARE total_books_sold INT;

    -- Create a temporary table to store the result
    CREATE TEMPORARY TABLE TempAuthorsWithBooksSold (
        temp_id INT AUTO_INCREMENT PRIMARY KEY,
        author_id INT,
        author_name VARCHAR(255),
        books_sold INT
    );

    -- Retrieve authors with the number of books sold within the specified time range
    INSERT INTO TempAuthorsWithBooksSold (author_id, author_name, books_sold)
    SELECT
        a.author_id,
        a.author_name,
        COUNT(bo.ISBN) AS books_sold
    FROM
        AUTHOR a
    JOIN
        WRITE_BOOK wb ON a.author_id = wb.author_id
    JOIN
        BELONG_TO_ORDER bo ON wb.ISBN = bo.ISBN
    JOIN
        INVOICE i ON bo.order_id = i.order_id
    WHERE
        i.timestamp BETWEEN p_start_time AND p_end_time
    GROUP BY
        a.author_id
    HAVING
        books_sold > p_N;

    -- Select the result from the temporary table
    SELECT * FROM TempAuthorsWithBooksSold;

    -- Drop the temporary table
    DROP TEMPORARY TABLE IF EXISTS TempAuthorsWithBooksSold;
END //

DELIMITER ;

CALL GetAuthorsWithBooksSold('2023-01-01', '2023-12-31', 0);
