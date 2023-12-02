-- Trigger 2: Sum of book price in INVOICE
-- Drop existing trigger if it exists
-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_book_price_invoice_insert;
DELIMITER //

CREATE TRIGGER update_book_price_invoice_insert
AFTER INSERT ON BELONG_TO_ORDER
FOR EACH ROW
BEGIN
    DECLARE total_price INT;
    DECLARE order_status VARCHAR(255);
    DECLARE voucher_min_value INT;
    DECLARE u_voucher_id INT;

    -- Get the status from the ORDERS table
    SELECT status INTO order_status FROM ORDERS WHERE order_id = NEW.order_id;

    -- Check if the order status is 'pending'
    IF order_status = 'pending' THEN
        -- Calculate the total price for the order after the insert
        SET total_price = COALESCE(NEW.quantity, 0) * COALESCE(NEW.price, 0);

        -- Update the total_cost in the corresponding order in the INVOICE table
        UPDATE INVOICE
        SET total_cost = total_cost + total_price
        WHERE order_id = NEW.order_id;


        -- Check the minimum value constraint for the voucher used in the order
        SELECT voucher_id INTO u_voucher_id FROM USED_VOUCHER WHERE order_id = NEW.order_id;

        SELECT min_value INTO voucher_min_value FROM VOUCHER WHERE voucher_id = u_voucher_id;

        IF total_price < voucher_min_value THEN
            -- Delete the voucher from USED_VOUCHER if the constraint is not met
            DELETE FROM USED_VOUCHER WHERE order_id = NEW.order_id;
        END IF;
    END IF;
END //

DELIMITER ;


-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_book_price_invoice_update;
DELIMITER //

CREATE TRIGGER update_book_price_invoice_update
AFTER UPDATE ON BELONG_TO_ORDER
FOR EACH ROW
BEGIN
    DECLARE total_price INT;
    DECLARE total_price_before_update INT;
    DECLARE order_status VARCHAR(255);

    DECLARE u_voucher_id INT;
    DECLARE voucher_min_value INT;

    -- Get the status from the ORDERS table
    SELECT status INTO order_status FROM ORDERS WHERE order_id = NEW.order_id;

    -- Check if the order status is 'pending'
    IF order_status = 'pending' THEN
        -- Calculate the total price for the order after the update
        SET total_price = COALESCE(NEW.quantity, 0) * COALESCE(NEW.price, 0);

        -- Calculate the total price for the order before the update
        SET total_price_before_update = COALESCE(OLD.quantity, 0) * COALESCE(OLD.price, 0);

        -- Update the total_cost in the corresponding order in the INVOICE table
        UPDATE INVOICE
        SET total_cost = total_cost - total_price_before_update + total_price
        WHERE order_id = NEW.order_id;

        -- Check the minimum value constraint for the voucher used in the order
        SELECT voucher_id INTO u_voucher_id FROM USED_VOUCHER WHERE order_id = NEW.order_id;

        SELECT min_value INTO voucher_min_value FROM VOUCHER WHERE voucher_id = u_voucher_id;
        IF total_price < voucher_min_value THEN
            -- Delete the voucher from USED_VOUCHER if the constraint is not met
            DELETE FROM USED_VOUCHER WHERE order_id = NEW.order_id;
        END IF;
    END IF;
END //

DELIMITER ;


-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_book_price_invoice_delete;
DELIMITER //

CREATE TRIGGER update_book_price_invoice_delete
AFTER DELETE ON BELONG_TO_ORDER
FOR EACH ROW
BEGIN
    DECLARE price_before_delete INT;
    DECLARE decrease_price_after_delete INT;
    DECLARE order_status VARCHAR(255);
    DECLARE u_voucher_id INT;
    DECLARE voucher_min_value INT;

    -- Get the status from the ORDERS table
    SELECT status INTO order_status FROM ORDERS WHERE order_id = OLD.order_id;

    -- Check if the order status is 'pending'
    IF order_status = 'pending' THEN
        SELECT total_cost INTO price_before_delete
        FROM INVOICE
        WHERE order_id = OLD.order_id;
        -- Calculate the total price for the order after the delete
        SET decrease_price_after_delete = COALESCE(OLD.quantity, 0) * COALESCE(OLD.price, 0);

        -- Update the total_cost in the corresponding order in the INVOICE table
        UPDATE INVOICE
        SET total_cost = total_cost - decrease_price_after_delete
        WHERE order_id = OLD.order_id;

        -- Check the minimum value constraint for the voucher used in the order
        SELECT voucher_id INTO u_voucher_id FROM USED_VOUCHER WHERE order_id = OLD.order_id;

        SELECT min_value INTO voucher_min_value FROM VOUCHER WHERE voucher_id = u_voucher_id;
        IF price_before_delete - decrease_price_after_delete < voucher_min_value THEN
            -- Delete the voucher from USED_VOUCHER if the constraint is not met
            DELETE FROM USED_VOUCHER WHERE order_id = OLD.order_id;
        END IF;
    END IF;
END //

DELIMITER ;



-- Check case 1: insert new book to ORDER:
-- Check the Book in order
SELECT * FROM BELONG_TO_ORDER;

-- Check the VOUCHER, have min value : 200.000
SELECT * FROM VOUCHER;
-- That order used voucher
SELECT * FROM USED_VOUCHER;

-- Check INVOICE first
SELECT * FROM INVOICE;

-- ADD new book to that ORDER,
-- check total_value increase.

INSERT INTO BELONG_TO_ORDER(order_id, ISBN, quantity, price)
VALUES (1, '9786043216899', 1, 120000);

-- Check INVOICE
SELECT * FROM INVOICE;

SELECT * FROM BELONG_TO_ORDER;

-- Check case 2: update quantity of book in table BELONG TO ORDER:

UPDATE BELONG_TO_ORDER
SET quantity = 2
WHERE  order_id = 1  AND ISBN= '9786043216899';

SELECT * FROM INVOICE;

-- Check case 2. 2: decrease BOOK, and delete in USED_VOUCHER:
SELECT * FROM USED_VOUCHER;
INSERT INTO USED_VOUCHER(order_id, voucher_id)
VALUES(1, 1);

UPDATE BELONG_TO_ORDER
SET quantity = 1
WHERE order_id = 1 AND ISBN = '9786043216899';

SELECT * FROM INVOICE;
SELECT * FROM USED_VOUCHER;

-- Check case 3.1: DELELe record from BELONG_TO_ORDER
SELECT * FROM BELONG_TO_ORDER;

DELETE
FROM BELONG_TO_ORDER WHERE order_id = 1 AND ISBN = '9786043216899';

SELECT * FROM INVOICE;

-- Check case 3.2: DELETE book from Order, and not to use voucher
INSERT INTO BELONG_TO_ORDER(order_id, ISBN, quantity, price)
VALUES(1, '9786043216899', 3, 120000);

SELECT * FROM INVOICE;

INSERT INTO USED_VOUCHER(order_id, voucher_id)
VALUES(1, 1);

SELECT * FROM USED_VOUCHER;

DELETE
FROM BELONG_TO_ORDER WHERE order_id = 1 AND ISBN = '9786043216899';

SELECT * FROM USED_VOUCHER;

SELECT * FROM BELONG_TO_ORDER;