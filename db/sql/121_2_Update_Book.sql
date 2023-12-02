DROP PROCEDURE IF EXISTS UPDATE_AUTHOR;
DROP PROCEDURE IF EXISTS UPDATE_CATEGORY;
DROP PROCEDURE IF EXISTS UPDATE_IMG;
DROP PROCEDURE IF EXISTS UPDATE_BOOK;



DELIMITER //

-- Procedure to update authors for a book in the WRITE_BOOK table
CREATE PROCEDURE UPDATE_AUTHOR(
    IN p_ISBN VARCHAR(13),
    IN p_author_ids JSON
)
BEGIN
    DECLARE s_author_id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE author_index INT DEFAULT 0;
    DECLARE author_count INT;

    -- Check if JSON array is empty
    IF JSON_LENGTH(p_author_ids) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Author_id does not exist';
    END IF;

    -- Get the count of authors in the JSON array
    SET author_count = JSON_LENGTH(p_author_ids);

    -- Start transaction
    START TRANSACTION;

    -- Delete existing records for the given ISBN in WRITE_BOOK
    DELETE FROM WRITE_BOOK WHERE ISBN = p_ISBN;

    -- Iterate over authors and insert into WRITE_BOOK
    WHILE author_index < author_count DO
        -- Get author_id from JSON array
        SET s_author_id =
        JSON_UNQUOTE(JSON_EXTRACT(p_author_ids, CONCAT('$[', author_index, ']')));

        -- Check if author_id exists
        IF NOT EXISTS (SELECT 1 FROM AUTHOR WHERE author_id = s_author_id) THEN
            -- Rollback transaction if author_id does not exist
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Author_id does not exist';
        END IF;

        -- Insert into WRITE_BOOK
        INSERT INTO WRITE_BOOK(author_id, ISBN) VALUES (s_author_id, p_ISBN);

        SET author_index = author_index + 1;
    END WHILE;

    -- Commit transaction
    COMMIT;
END //

DELIMITER ;

DELIMITER //

-- Procedure to update categories for a book in the BELONG_TO_CATEGORY table
CREATE PROCEDURE UPDATE_CATEGORY(
    IN p_ISBN VARCHAR(13),
    IN p_category_ids JSON
)
BEGIN
    DECLARE s_category_id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE category_index INT DEFAULT 0;
    DECLARE category_count INT;

    -- Check if JSON array is empty
    IF JSON_LENGTH(p_category_ids) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Category_id does not exist';
    END IF;

    -- Get the count of categories in the JSON array
    SET category_count = JSON_LENGTH(p_category_ids);

    -- Start transaction
    START TRANSACTION;

    -- Delete existing records for the given ISBN in BELONG_TO_CATEGORY
    DELETE FROM BELONG_TO_CATEGORY WHERE ISBN = p_ISBN;

    -- Iterate over categories and insert into BELONG_TO_CATEGORY
    WHILE category_index < category_count DO
        -- Get category_id from JSON array
        SET s_category_id =
        JSON_UNQUOTE(JSON_EXTRACT(p_category_ids, CONCAT('$[', category_index, ']')));

        -- Check if category_id exists
        IF NOT EXISTS (SELECT 1 FROM CATEGORY WHERE category_id = s_category_id) THEN
            -- Rollback transaction if category_id does not exist
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Category_id does not exist';
        END IF;

        -- Insert into BELONG_TO_CATEGORY
        INSERT INTO BELONG_TO_CATEGORY(category_id, ISBN)
        VALUES (s_category_id, p_ISBN);

        SET category_index = category_index + 1;
    END WHILE;

    -- Commit transaction
    COMMIT;
END //

DELIMITER ;

DELIMITER //

-- Procedure to update image links for a book in the IMAGE_BOOK table
CREATE PROCEDURE UPDATE_IMG(
    IN p_ISBN VARCHAR(13),
    IN p_image_links JSON
)
BEGIN
    DECLARE image_link VARCHAR(255);
    DECLARE done INT DEFAULT FALSE;
    DECLARE image_index INT DEFAULT 0;
    DECLARE image_count INT;

    -- Check if JSON array is empty
    IF JSON_LENGTH(p_image_links) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No image_link exists';
    END IF;

    -- Get the count of image links in the JSON array
    SET image_count = JSON_LENGTH(p_image_links);

    -- Start transaction
    START TRANSACTION;

    -- Delete existing records for the given ISBN in IMAGE_BOOK
    DELETE FROM IMAGE_BOOK WHERE ISBN = p_ISBN;

    -- Iterate over image links and insert into IMAGE_BOOK
    WHILE image_index < image_count DO
        -- Get image_link from JSON array
        SET image_link =
        JSON_UNQUOTE(JSON_EXTRACT(p_image_links, CONCAT('$[', image_index, ']')));

        -- Insert into IMAGE_BOOK
        INSERT INTO IMAGE_BOOK(ISBN, img_link) VALUES (p_ISBN, image_link);

        SET image_index = image_index + 1;
    END WHILE;

    -- Commit transaction
    COMMIT;
END //

DELIMITER ;


-- UPDATE
DELIMITER //

-- Procedure to update information for a book in the BOOK table
CREATE PROCEDURE UPDATE_BOOK(
    IN p_ISBN VARCHAR(13),
    IN p_title VARCHAR(255),
    IN p_book_cover ENUM('hardcover', 'paperback'),
    IN p_description LONGTEXT,
    IN p_dimensions VARCHAR(20),
    IN p_print_length INT,
    IN p_price INT,
    IN p_publication_date DATE,
    IN p_publisher INT,
    IN p_author_ids JSON,
    IN p_category_ids JSON,
    IN p_image_links JSON
)
BEGIN
    DECLARE book_exists INT;

    -- Check if the book with the specified ISBN exists
    SELECT COUNT(*) INTO book_exists FROM BOOK WHERE ISBN = p_ISBN;

    IF book_exists = 0 THEN
        SET @errorMessage = CONCAT('Book with ISBN ', p_ISBN, ' does not exist');
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @errorMessage;
    ELSE
        -- Check if book_cover is valid
        IF NOT (p_book_cover = 'hardcover' OR p_book_cover = 'paperback') THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid book cover type';
        END IF;

        -- Check if dimensions are in the correct format
        IF NOT (p_dimensions
            REGEXP '^[0-9]+(\.[0-9]+)? x [0-9]+(\.[0-9]+)? x [0-9]+(\.[0-9]+)? cm$') THEN
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

        -- Start transaction
        START TRANSACTION;

        -- Update information in the BOOK table
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

        -- Call procedures to update authors, categories, and image links
        CALL UPDATE_AUTHOR(p_ISBN, p_author_ids);
        CALL UPDATE_CATEGORY(p_ISBN, p_category_ids);
        CALL UPDATE_IMG(p_ISBN, p_image_links);

        -- Commit transaction
        COMMIT;

        -- Return success message
        SELECT 'Book updated successfully' AS Message;
    END IF;
END //

DELIMITER ;

-- Test the UPDATE_BOOK procedure
CALL UPDATE_BOOK(
    '0000000000000', -- Replace with the ISBN of the book you want to update
    'Updated Title',
    'paperback',
    'Updated description.',
    '20 x 30 x 4 cm',
    200,
    200000,
    '2023-02-01',
    2,
    '[3]',
    '[1, 2]',
    '["new_link1.jpg", "new_link2.jpg"]'
);


SELECT * FROM BOOK;
SELECT * FROM BELONG_TO_CATEGORY;
SELECT * FROM IMAGE_BOOK;
SELECT * FROM WRITE_BOOK;
