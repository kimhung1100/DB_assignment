-- Create enum-like types
# CREATE DOMAIN ISBN_TYPE AS CHAR(13);
# CREATE DOMAIN PHONE_NUMBER_TYPE AS VARCHAR(20);


-- ---------------------------------------------------------------------
-- EMPLOYEE, BRANCH GROUP
--
-- ---------------------------------------------------------------------
-- EMPLOYEE TABLE
CREATE TABLE EMPLOYEE (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    birth_date DATE NOT NULL,
    number_address VARCHAR(20) NOT NULL,
    street VARCHAR(255) NOT NULL,
    ward VARCHAR(50) NOT NULL,
    district VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    manager_id INT,
    phone_number VARCHAR(15) NOT NULL,
    password VARCHAR(40) NOT NULL,
    FOREIGN KEY (manager_id) REFERENCES EMPLOYEE(account_id)
);

DELIMITER //
CREATE TRIGGER check_age_trigger BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.birth_date > DATE_SUB(CURDATE(), INTERVAL 18 YEAR) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employees must be at least 18 years old';
    END IF;
END;
//
DELIMITER ;


-- BRANCH
CREATE TABLE BRANCH (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(255) UNIQUE NOT NULL,
    number_address VARCHAR(20) NOT NULL,
    street VARCHAR(255) NOT NULL,
    ward VARCHAR(50) NOT NULL,
    district VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL
);

CREATE TABLE EMPLOYEE_BELONG_TO_BRANCH (
    branch_id INT,
    employee_id INT,
    start_date DATE,
    PRIMARY KEY (branch_id, employee_id),
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(account_id)
);

-- Create the table
CREATE TABLE IMPORT_EXPORT_FORM (
    form_id INT PRIMARY KEY AUTO_INCREMENT,
    timestamp DATETIME,
    type ENUM('Import', 'Export'),
    status status ENUM('pending', 'confirmed'),
    employee_id INT,
    branch_id INT,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(account_id),
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);
# ALTER TABLE IMPORT_EXPORT_FORM ADD Column status ENUM('pending', 'confirmed') after type;
DELIMITER //
CREATE TRIGGER check_timestamp
BEFORE INSERT ON IMPORT_EXPORT_FORM
FOR EACH ROW
BEGIN
    IF NEW.timestamp > NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Timestamp cannot be in the future';
    END IF;
END;
//
DELIMITER ;

-- ---------------------------------------------------------------------
-- BOOK GROUP
--
-- ---------------------------------------------------------------------

CREATE TABLE PUBLISHER (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    publisher_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE AUTHOR (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE CATEGORY (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE BOOK (
    ISBN VARCHAR(13) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    book_cover ENUM('hardcover', 'paperback') NOT NULL,
    description LONGTEXT NOT NULL,
    dimensions VARCHAR(20) NOT NULL,
    print_length INT NOT NULL,
    price INT NOT NULL,
    publication_date DATE NOT NULL,
    publisher INT NOT NULL,
    FOREIGN KEY (publisher) REFERENCES PUBLISHER(publisher_id)
);

ALTER TABLE BOOK
ADD CONSTRAINT check_positive_price CHECK (price > 0);

ALTER TABLE BOOK
ADD CONSTRAINT check_positive_print_length CHECK (print_length > 0);

CREATE TABLE IMAGE_BOOK (
    ISBN VARCHAR(13),
    img_link VARCHAR(255),
    PRIMARY KEY (ISBN, img_link),
    FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN)
);


CREATE TABLE BOOK_IN_FORM (
    form_id INT NOT NULL auto_increment,
    ISBN VARCHAR(13) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (form_id, ISBN),
    FOREIGN KEY (form_id) REFERENCES IMPORT_EXPORT_FORM(form_id),
    FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN)
);

ALTER TABLE BOOK_IN_FORM
ADD CONSTRAINT check_positive_quantity CHECK (quantity > 0);

CREATE TABLE BELONG_TO_CATEGORY (
    category_id INT,
    ISBN VARCHAR(13),
    PRIMARY KEY (category_id, ISBN),
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
);


-- Drop the existing WRITE_BOOK table
DROP TABLE IF EXISTS WRITE_BOOK;

-- Create the new WRITE_BOOK table
CREATE TABLE WRITE_BOOK (
    author_id INT,
    ISBN VARCHAR(13),
    PRIMARY KEY (author_id, ISBN), -- Unique constraint for author and book
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id)
);


CREATE TABLE BOOK_BELONG_TO_BRANCH (
    branch_id INT,
    ISBN VARCHAR(13),
    quantity INT,
    PRIMARY KEY (branch_id, ISBN),
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id),
    FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN)
);

ALTER TABLE BOOK_BELONG_TO_BRANCH
ADD CONSTRAINT check_non_negative_quantity CHECK (quantity >= 0);

-- ---------------------------------------------------------------------
-- CUSTOMER GROUP
--
-- ---------------------------------------------------------------------

CREATE TABLE CUSTOMER (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    birth_date DATE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(40) NOT NULL
);

# ALTER TABLE CUSTOMER
# ADD CONSTRAINT check_valid_gender CHECK (gender IN ('male', 'female', 'other'));

DELIMITER //
CREATE TRIGGER check_birth_date_trigger
BEFORE INSERT ON CUSTOMER
FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Birth date cannot be in the future';
    END IF;
END;
//
DELIMITER ;

# DROP TABLE DELIVERY_ADDRESS;
CREATE TABLE DELIVERY_ADDRESS (
    account_id INT,
    address_id INT,
    house_number VARCHAR(20),
    street VARCHAR(255),
    ward VARCHAR(255),
    district VARCHAR(255),
    city VARCHAR(255),
    phone_number VARCHAR(13),
    Fname VARCHAR(50),
    Lname VARCHAR(50),
    PRIMARY KEY (account_id, address_id),
    FOREIGN KEY (account_id) REFERENCES CUSTOMER(account_id),
    INDEX idx_account_id (account_id),
    INDEX idx_address_id (address_id)
);

ALTER TABLE DELIVERY_ADDRESS
ADD CONSTRAINT check_phone_number_format CHECK (phone_number REGEXP '^[+]?[0-9]+$');

# SHOW INDEX FROM CUSTOMER;
# ALTER TABLE CUSTOMER
# DROP INDEX phone_number;
# ALTER TABLE CUSTOMER
# MODIFY COLUMN phone_number VARCHAR(15) NOT NULL;

CREATE TABLE RATING (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    rating_points INT NOT NULL,
    timestamp DATETIME NOT NULL,
    status ENUM('pending approval', 'approved', 'hidden') NOT NULL,
    comment VARCHAR(255),
    ISBN VARCHAR(13) NOT NULL,
    account_id INT NOT NULL,
    FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN),
    FOREIGN KEY (account_id) REFERENCES CUSTOMER(account_id)
);

ALTER TABLE RATING
ADD CONSTRAINT check_valid_rating_points CHECK (rating_points >= 1 AND rating_points <= 5);

ALTER TABLE RATING
ADD CONSTRAINT check_valid_status CHECK (status IN ('pending approval', 'approved', 'hidden'));

ALTER TABLE RATING
ADD CONSTRAINT check_comment_length CHECK (CHAR_LENGTH(comment) >= 2 AND CHAR_LENGTH(comment) <= 255);


CREATE TABLE RATING_IMAGE (
    rating_id INT NOT NULL,
    img_link VARCHAR(255) NOT NULL,
    PRIMARY KEY (rating_id, img_link),
    FOREIGN KEY (rating_id) REFERENCES RATING(rating_id)
);



CREATE TABLE VOUCHER (
    voucher_id INT AUTO_INCREMENT,
    start_date DATE,
    end_date DATE,
    min_value INT,
    account_id INT,
    discount_rate_flag BOOL,
    discount_rate INT UNSIGNED,
    discount_amount_flag BOOL,
    discount_amount INT,
    freeship_flag BOOL,
    PRIMARY KEY (voucher_id),
    FOREIGN KEY (account_id) REFERENCES EMPLOYEE(account_id)
);

ALTER TABLE VOUCHER
ADD CONSTRAINT check_valid_dates CHECK (start_date <= end_date);

ALTER TABLE VOUCHER
ADD CONSTRAINT check_exclusive_discount_flags CHECK (
    (discount_rate_flag = 1 AND discount_amount_flag = 0) OR
    (discount_rate_flag = 0 AND discount_amount_flag = 1)
);
ALTER TABLE VOUCHER
ADD CONSTRAINT check_min_value CHECK (min_value >= 0);

CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    status ENUM('pending', 'processing', 'confirmed', 'delivering', 'delivered', 'canceled', 'refunding'),
    account_id INT,
    address_id INT,
    FOREIGN KEY (account_id) REFERENCES DELIVERY_ADDRESS(account_id),
    FOREIGN KEY (address_id) REFERENCES DELIVERY_ADDRESS(address_id)
);

ALTER TABLE ORDERS
ADD CONSTRAINT check_valid_order_status CHECK (
    status IN ('pending', 'processing', 'confirmed', 'delivering', 'delivered', 'canceled', 'refunding')
);


CREATE TABLE INVOICE (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    timestamp DATE,
    payment_method ENUM('COD', 'Bank Transfer', 'Other'),
    delivery_fee INT UNSIGNED,
    order_id INT,
    total_cost INT UNSIGNED,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
);

ALTER TABLE INVOICE
ADD CONSTRAINT check_positive_values CHECK (delivery_fee >= 0 AND total_cost >= 0);



CREATE TABLE REFUND_REQUEST (
    order_id INT,
    request_id INT,
    status ENUM('pending', 'processing', 'approved', 'refuse'),
    timestamp DATE,
    return_reason VARCHAR(255),
    account_id INT,
    img_link VARCHAR(255),
    PRIMARY KEY (order_id, request_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (account_id) REFERENCES EMPLOYEE(account_id)
);

ALTER TABLE REFUND_REQUEST
ADD CONSTRAINT check_valid_status_refund CHECK (
    status IN ('pending', 'processing', 'approved', 'refuse')
);

DELIMITER //
CREATE TRIGGER before_insert_refund_request
BEFORE INSERT ON REFUND_REQUEST
FOR EACH ROW
BEGIN
    IF NEW.timestamp > CURRENT_TIMESTAMP THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert future timestamp';
    END IF;
END;
//
DELIMITER ;




CREATE TABLE USED_VOUCHER (
    order_id INT PRIMARY KEY,
    voucher_id VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (voucher_id) REFERENCES VOUCHER(voucher_id)
);

# ALTER TABLE USED_VOUCHER
# DROP FOREIGN KEY USED_VOUCHER_ibfk_2;
#
# ALTER TABLE USED_VOUCHER
# ADD CONSTRAINT USED_VOUCHER_ibfk_2
# FOREIGN KEY (voucher_id) REFERENCES VOUCHER(voucher_id);


CREATE TABLE BELONG_TO_ORDER (
    order_id INT,
    ISBN VARCHAR(13),
    quantity INT UNSIGNED,
    price INT UNSIGNED,
    PRIMARY KEY (order_id, ISBN),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN)
);
ALTER TABLE BELONG_TO_ORDER
ADD CONSTRAINT check_positive_quantity_order CHECK (quantity > 0);

ALTER TABLE BELONG_TO_ORDER
ADD CONSTRAINT check_positive_price_order CHECK (price >= 0);


CREATE TABLE LIKE_RATING (
    account_id INT,
    rating_id INT,
    PRIMARY KEY (account_id, rating_id),
    FOREIGN KEY (account_id) REFERENCES CUSTOMER(account_id),
    FOREIGN KEY (rating_id) REFERENCES RATING(rating_id)
);

CREATE TABLE FORM_OF_ORDER (
    form_id INT,
    order_id INT,
    PRIMARY KEY (form_id, order_id),
    FOREIGN KEY (form_id) REFERENCES IMPORT_EXPORT_FORM(form_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
);

SHOW TABLES;

