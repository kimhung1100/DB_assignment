

-- Drop existing procedures if they exist
DROP PROCEDURE IF EXISTS SPLIT_STRING_INTO_TABLE;
DROP PROCEDURE IF EXISTS ADD_AUTHOR;
DROP PROCEDURE IF EXISTS ADD_CATEGORY;
DROP PROCEDURE IF EXISTS ADD_IMG;
DROP PROCEDURE IF EXISTS INSERT_BOOK;

Delimiter //
-- Procedure to add authors to the WRITE_BOOK table
CREATE PROCEDURE ADD_AUTHOR(
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

    -- Iterate over authors and insert into WRITE_BOOK
    WHILE author_index < author_count DO
        -- Get author_id from JSON array
        SET s_author_id = JSON_UNQUOTE(JSON_EXTRACT(p_author_ids, CONCAT('$[', author_index, ']')));

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
END;

-- Procedure to add categories to the BELONG_TO_CATEGORY table
CREATE PROCEDURE ADD_CATEGORY(
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

    -- Iterate over categories and insert into BELONG_TO_CATEGORY
    WHILE category_index < category_count DO
        -- Get category_id from JSON array
        SET s_category_id = JSON_UNQUOTE(JSON_EXTRACT(p_category_ids, CONCAT('$[', category_index, ']')));

        -- Check if category_id exists
        IF NOT EXISTS (SELECT 1 FROM CATEGORY WHERE category_id = s_category_id) THEN
            -- Rollback transaction if category_id does not exist
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Category_id does not exist';
        END IF;

        -- Insert into BELONG_TO_CATEGORY
        INSERT INTO BELONG_TO_CATEGORY(category_id, ISBN) VALUES (s_category_id, p_ISBN);

        SET category_index = category_index + 1;
    END WHILE;

    -- Commit transaction
    COMMIT;
END;

-- Procedure to add image links to the IMAGE_BOOK table
CREATE PROCEDURE ADD_IMG(
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
        SET MESSAGE_TEXT = 'No image_link combination exists';
    END IF;

    -- Get the count of image links in the JSON array
    SET image_count = JSON_LENGTH(p_image_links);

    -- Start transaction
    START TRANSACTION;

    -- Iterate over image links and insert into IMAGE_BOOK
    WHILE image_index < image_count DO
        -- Get image_link from JSON array
        SET image_link = JSON_UNQUOTE(JSON_EXTRACT(p_image_links, CONCAT('$[', image_index, ']')));

        -- Check if ISBN and image_link combination already exists
        IF EXISTS (SELECT 1 FROM IMAGE_BOOK WHERE ISBN = p_ISBN AND img_link = image_link) THEN
            -- Rollback transaction if combination exists
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ISBN and image_link combination already exists';
        END IF;

        -- Insert into IMAGE_BOOK
        INSERT INTO IMAGE_BOOK(ISBN, img_link) VALUES (p_ISBN, image_link);

        SET image_index = image_index + 1;
    END WHILE;

    -- Commit transaction
    COMMIT;
END;

-- Procedure to insert a book into the BOOK table
CREATE PROCEDURE INSERT_BOOK(
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
    -- Check if ISBN already exists
    IF EXISTS (SELECT 1 FROM BOOK WHERE ISBN = p_ISBN) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ISBN of the book already exists';
    END IF;

    -- Check if book_cover is valid
    IF NOT (p_book_cover = 'hardcover' OR p_book_cover = 'paperback') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid book cover type';
    END IF;

    -- Check if dimensions are in the correct format
    IF NOT (p_dimensions REGEXP '^[0-9]+(\.[0-9]+)? x [0-9]+(\.[0-9]+)? x [0-9]+(\.[0-9]+)? cm$') THEN
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
    -- If all checks pass, insert the book
    INSERT INTO BOOK (
        ISBN, title, book_cover, description, dimensions,
        print_length, price, publication_date, publisher
    ) VALUES (
        p_ISBN, p_title, p_book_cover, p_description, p_dimensions,
        p_print_length, p_price, p_publication_date, p_publisher
    );
        -- Call procedures to add authors, categories, and image links
    CALL ADD_AUTHOR(p_ISBN, p_author_ids);
    CALL ADD_CATEGORY(p_ISBN, p_category_ids);
    CALL ADD_IMG(p_ISBN, p_image_links);
    -- Commit transaction
    COMMIT;

    -- Return success message
    SELECT 'Book added successfully' AS Message;
END;

DELIMITER ;

-- Test the INSERT_BOOK procedure

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

CALL INSERT_BOOK(
 '0000000000000', -- Replace with a valid and unique ISBN
 'Sample Book',
 'hardcover',
 'A sample book description.',
 '15 x 23 x 3 cm',
 150,
 150000,
 '2023-01-01',
 1,
 '[1, 2, 3]',
 '[4, 5]',
 '["link1.jpg", "link2.jpg"]'
 );


# DELETE FROM BELONG_TO_CATEGORY WHERE ISBN = '0000000000000';
# DELETE FROM IMAGE_BOOK WHERE ISBN = '0000000000000';
# DELETE FROM WRITE_BOOK WHERE ISBN = '0000000000000';
# DELETE FROM BOOK WHERE ISBN = '0000000000000';


