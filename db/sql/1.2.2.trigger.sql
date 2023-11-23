SELECT * FROM BOOK_IN_FORM;
SELECT * FROM IMPORT_EXPORT_FORM;
SELECT * FROM BOOK_BELONG_TO_BRANCH;

DROP TRIGGER IF EXISTS updateBookQuantity;
DELIMITER //

CREATE TRIGGER updateBookQuantity
AFTER UPDATE ON IMPORT_EXPORT_FORM
FOR EACH ROW
BEGIN
    DECLARE book_ISBN VARCHAR(13);
    DECLARE quantity_change INT;
    DECLARE branch_id_value INT;



    -- Check if the status is updated to 'confirmed'
    IF NEW.status = 'confirmed' AND OLD.status <> 'confirmed' THEN
        -- Get ISBN, quantity, and branch_id from BOOK_IN_FORM based on form_id
        SELECT ISBN, quantity INTO book_ISBN, quantity_change
        FROM BOOK_IN_FORM
        WHERE form_id = NEW.form_id;

        -- Update quantity in BOOK_BELONG_TO_BRANCH
        IF NEW.type = 'Import' THEN
            UPDATE BOOK_BELONG_TO_BRANCH
            SET quantity = quantity + quantity_change
            WHERE ISBN = book_ISBN AND branch_id = NEW.branch_id;
        ELSE
            UPDATE BOOK_BELONG_TO_BRANCH
            SET quantity = quantity - quantity_change
            WHERE ISBN = book_ISBN AND branch_id = NEW.branch_id;
        END IF;
    END IF;
END //

DELIMITER ;


--
DROP procedure if exists import_export_book;
DELIMITER //

CREATE PROCEDURE import_export_book(
    IN p_ISBN VARCHAR(13),
    IN p_quantity INT,
    IN p_form_id INT
)
BEGIN

    -- Insert into BOOK_IN_FORM
    INSERT INTO BOOK_IN_FORM (form_id, ISBN, quantity)
    VALUES (p_form_id, p_ISBN, p_quantity);
END //

DELIMITER ;

SELECT * FROM IMPORT_EXPORT_FORM;

-- test trigger quantity of book in branch.

INSERT INTO IMPORT_EXPORT_FORM(timestamp, type, status, employee_id, branch_id)
VALUES (NOW(), 'import', 'pending', 1, 1);

CALL import_export_book('8935092820392', 12, 3);

UPDATE IMPORT_EXPORT_FORM
SET status = 'confirmed'
WHERE form_id = 3;

SELECT * FROM BOOK_BELONG_TO_BRANCH;
SELECT * FROM IMPORT_EXPORT_FORM;

-- Trigger 2: Sum of book price in INVOICE

SELECT * FROM INVOICE;
SELECT * FROM ORDERS;
SELECT * FROM BELONG_TO_ORDER;

DROP TRIGGER IF EXISTS update_book_price_invoice;
DELIMITER //

CREATE TRIGGER update_book_price_invoice
AFTER UPDATE ON BELONG_TO_ORDER
FOR EACH ROW
BEGIN
    DECLARE total_price INT;
    DECLARE total_price_before_update INT;

    -- Calculate the total price for the order after the update
    SET total_price = NEW.quantity * NEW.price;

    -- Calculate the total price for the order before the update
    SET total_price_before_update = OLD.quantity * OLD.price;

    -- Update the total_cost in the corresponding order in the INVOICE table
    UPDATE INVOICE
    SET total_cost = total_cost - total_price_before_update + total_price
    WHERE order_id = NEW.order_id;
END //

DELIMITER ;


-- Assuming BELONG_TO_ORDER has a column named id as a primary key
-- Update the quantity and/or price
UPDATE BELONG_TO_ORDER
SET quantity = 1, price = 150000
WHERE order_id = 1;
