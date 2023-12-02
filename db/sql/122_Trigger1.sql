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
# DELIMITER //
#
# CREATE PROCEDURE import_export_book(
#     IN p_ISBN VARCHAR(13),
#     IN p_quantity INT,
#     IN p_form_id INT
# )
# BEGIN
#
#     -- Insert into BOOK_IN_FORM
#     INSERT INTO BOOK_IN_FORM (form_id, ISBN, quantity)
#     VALUES (p_form_id, p_ISBN, p_quantity);
# END //
#
# DELIMITER ;

-- test trigger quantity of book in branch.
# SELECT * FROM BOOK_IN_FORM;
# SELECT * FROM IMPORT_EXPORT_FORM;
SELECT * FROM BOOK_BELONG_TO_BRANCH;

-- An employee create new form
INSERT INTO IMPORT_EXPORT_FORM(timestamp, type, status, employee_id, branch_id)
VALUES (NOW(), 'import', 'pending', 1, 1);

-- Check that new form
SELECT * FROM IMPORT_EXPORT_FORM;

-- Check book in form
SELECT * FROM BOOK_IN_FORM;
-- ADD book to that form, change the form_id to newestnewest
INSERT INTO BOOK_IN_FORM (form_id, ISBN, quantity)
    VALUES (4, '8935092820392', 3);

-- Check book in form again
SELECT * FROM BOOK_IN_FORM;

-- That form not been confirm, book in branch not update
SELECT * FROM BOOK_BELONG_TO_BRANCH;

-- Confirm that Form
UPDATE IMPORT_EXPORT_FORM
SET status = 'confirmed'
WHERE form_id = 4;

SELECT * FROM BOOK_BELONG_TO_BRANCH;
SELECT * FROM IMPORT_EXPORT_FORM;


