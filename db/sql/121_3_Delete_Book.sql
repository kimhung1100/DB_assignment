
DROP PROCEDURE IF EXISTS deleteBook;

DELIMITER //

CREATE PROCEDURE deleteBook(IN book_ISBN VARCHAR(13))
BEGIN
    DECLARE book_exists INT;

    -- Check if the book with the specified ISBN exists
    SELECT COUNT(*) INTO book_exists FROM BOOK WHERE ISBN = book_ISBN;

    IF book_exists = 0 THEN
        SET @errorMessage = CONCAT('Book with ISBN ', book_ISBN, ' does not exist');
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @errorMessage;
    ELSE
        -- Check if the book is part of an order
        IF EXISTS (SELECT 1 FROM BELONG_TO_ORDER WHERE ISBN = book_ISBN) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Book is part of an order and cannot be deleted';
        ELSE
            -- Start a transaction
            START TRANSACTION;

            -- Delete records from related tables
            DELETE FROM BELONG_TO_CATEGORY WHERE ISBN = book_ISBN;
            DELETE FROM BOOK_BELONG_TO_BRANCH WHERE ISBN = book_ISBN;
            DELETE FROM BOOK_IN_FORM WHERE ISBN = book_ISBN;
            DELETE FROM RATING WHERE ISBN = book_ISBN;
            DELETE FROM IMAGE_BOOK WHERE ISBN = book_ISBN;
            DELETE FROM WRITE_BOOK WHERE ISBN = book_ISBN;

            -- Delete the book from the main BOOK table
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
    END IF;
END //

DELIMITER ;

-- delete book successfully
CALL deleteBook('0000000000000');

SELECT * FROM BOOK;
SELECT * FROM BELONG_TO_CATEGORY;
SELECT * FROM IMAGE_BOOK;
SELECT * FROM WRITE_BOOK;

DELETE FROM WRITE_BOOK WHERE ISBN = '0000000000000';

-- book in order cannot delete
CALL deleteBook('9786043216899');





