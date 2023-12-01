
-- CASE 1: ISBN already exists

CALL insertBook(
        '8935092820392', -- Existing ISBN
        'Book Title',
        'hardcover',
        'Description of the book',
        '27 x 19 x 1.8 cm',
        300, -- Print length
        20, -- Price
        '2023-01-01', -- Publication date
        1, -- Existing publisher ID
        1,
    1
    );


-- CASE 2: Invalid dimensions format.

CALL insertBook(
    '9876543210987',      -- New ISBN
    'Another Book Title',
    'paperback',
    'Another description',
    '27 x 19 x 1.8x cm',   -- Invalid dimensions format
    250,                   -- Print length
    15,                    -- Price
    '2023-01-10',          -- Publication date
    2,                      -- Existing publisher ID
    1,
    1
);

-- UPDATE
DELIMITER //

CREATE PROCEDURE updateBook(
    IN p_ISBN VARCHAR(13),
    IN p_title VARCHAR(255),
    IN p_book_cover ENUM('hardcover', 'paperback'),
    IN p_description LONGTEXT,
    IN p_dimensions VARCHAR(20),
    IN p_print_length INT,
    IN p_price INT,
    IN p_publication_date DATE,
    IN p_publisher INT,
    IN p_author_id INT,
    IN p_category_id INT
)
BEGIN
    -- Check if the book with the specified ISBN exists
    IF NOT EXISTS (SELECT 1 FROM BOOK WHERE ISBN = p_ISBN) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book with the specified ISBN does not exist';
    END IF;

    -- Check if book_cover is valid
    IF NOT (p_book_cover = 'hardcover' OR p_book_cover = 'paperback') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid book cover type';
    END IF;

    -- Check if dimensions are in the correct format
    IF NOT (p_dimensions REGEXP '^[0-9]+ x [0-9]+ x [0-9]+(\.[0-9]+)? cm$') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid dimensions format';
    END IF;

    -- Check if print_length and price are positive
    IF p_print_length <= 0 OR p_price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Print length and price must be positive';
    END IF;

    -- Check if publisher exists
    IF NOT EXISTS (SELECT 1 FROM PUBLISHER WHERE publisher_id = p_publisher) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid publisher ID';
    END IF;

    -- Check if author exists
    IF NOT EXISTS (SELECT 1 FROM AUTHOR WHERE author_id = p_author_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid author ID';
    END IF;

    -- Check if category exists
    IF NOT EXISTS (SELECT 1 FROM CATEGORY WHERE category_id = p_category_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid category ID';
    END IF;

    -- Update the book information
    UPDATE BOOK
    SET
        title = p_title,
        book_cover = p_book_cover,
        description = p_description,
        dimensions = p_dimensions,
        print_length = p_print_length,
        price = p_price,
        publication_date = p_publication_date,
        publisher = p_publisher
    WHERE ISBN = p_ISBN;

    -- Update BOOK_AUTHOR
    UPDATE WRITE_BOOK
    SET author_id = p_author_id
    WHERE ISBN = p_ISBN;

    -- Update BOOK_CATEGORY
    UPDATE BELONG_TO_CATEGORY
    SET category_id = p_category_id
    WHERE ISBN = p_ISBN;

    -- Return success message
    SELECT 'Book updated successfully' AS Message;

END //

DELIMITER ;

-- Call the UPDATE_BOOK procedure with nonexistent ISBN
CALL updateBook(
    '1234567890123',         -- Nonexistent ISBN
    'New Title',              -- New title
    'paperback',              -- New book cover
    'Updated description',    -- New description
    '20 x 15 x 2 cm',         -- New dimensions
    300,                      -- New print length
    25,                       -- New price
    '2023-01-01',             -- New publication date
    1,                        -- Existing publisher_id
    2,                        -- Existing author_id
    3                         -- Existing category_id
);

-- Call the UPDATE_BOOK procedure with invalid data (nonexistent author_id)
CALL updateBook(
    '8935092820392',         -- Existing ISBN
    'New Title',              -- New title
    'paperback',              -- New book cover
    'Updated description',    -- New description
    '20 x 15 x 2 cm',         -- New dimensions
    300,                      -- New print length
    25,                       -- New price
    '2023-01-01',             -- New publication date
    1,                        -- Existing publisher_id
    999,                      -- Nonexistent author_id (intentional error)
    3                         -- Existing category_id
);

DROP PROCEDURE IF EXISTS deleteBook;

DELIMITER //

CREATE PROCEDURE deleteBook(IN book_ISBN VARCHAR(13))
BEGIN
    DECLARE book_exists INT;

    -- Kiểm tra xem cuốn sách có tồn tại trong hệ thống không
    SELECT COUNT(*) INTO book_exists FROM BOOK WHERE ISBN = book_ISBN;

    IF book_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book does not exist';
    ELSE
        -- Start a transaction
        START TRANSACTION;

        -- Update the child tables to set ISBN to a default value
        UPDATE BELONG_TO_CATEGORY SET ISBN = '0' WHERE ISBN = book_ISBN;
        UPDATE BOOK_IN_FORM SET ISBN = '0' WHERE ISBN = book_ISBN;
        UPDATE RATING SET ISBN = '0' WHERE ISBN = book_ISBN;
        UPDATE BOOK_BELONG_TO_BRANCH SET ISBN = '0' WHERE ISBN = book_ISBN;
        UPDATE BELONG_TO_ORDER SET ISBN = '0' WHERE ISBN = book_ISBN;
        UPDATE IMAGE_BOOK SET ISBN = '0' WHERE ISBN = book_ISBN;

        -- Add more UPDATE statements for other child tables if needed

        -- Delete from the main BOOK table
        DELETE FROM BOOK WHERE ISBN = book_ISBN;

        -- Signal success or failure
        IF ROW_COUNT() > 0 THEN
            SELECT 'Delete book successfully' AS Result;
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error deleting book';
        END IF;

        -- Commit the transaction
        COMMIT;
    END IF;
END //

DELIMITER ;

CALL deleteBook('1234567891');





