-- ============================================================
-- TOON CLEANERS
-- Customers: Cartoon Characters | Employees: Street Fighters
-- ============================================================

-- Drop tables if re-running
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS garments CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

-- ============================================================
-- EMPLOYEES (Street Fighter characters)
-- ============================================================
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    role VARCHAR(50) NOT NULL, -- e.g. 'Cleaner', 'Presser', 'Front Desk', 'Manager'
    hourly_rate NUMERIC(6,2) NOT NULL,
    hire_date DATE NOT NULL
);

INSERT INTO employees (first_name, last_name, role, hourly_rate, hire_date) VALUES
('Ryu', NULL, 'Cleaner', 18.50, '2019-03-01'),
('Ken', 'Masters', 'Manager', 28.00, '2018-06-15'),
('Chun-Li', NULL, 'Front Desk', 22.00, '2020-01-10'),
('Guile', NULL, 'Presser', 19.00, '2019-11-20'),
('Cammy', 'White', 'Cleaner', 18.50, '2021-04-05'),
('Blanka', NULL, 'Cleaner', 17.00, '2022-07-01'),
('Dhalsim', NULL, 'Stain Specialist', 24.00, '2020-09-14'),
('Zangief', NULL, 'Presser', 19.50, '2021-02-28'),
('Balrog', NULL, 'Delivery Driver', 16.50, '2022-03-18'),
('Sakura', 'Kasugano', 'Front Desk', 20.00, '2023-01-09');

-- ============================================================
-- CUSTOMERS (Cartoon characters)
-- ============================================================
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    universe VARCHAR(50) NOT NULL, -- e.g. 'Looney Tunes', 'Cartoon Network'
    phone VARCHAR(20),
    email VARCHAR(100),
    loyalty_points INT DEFAULT 0
);

INSERT INTO customers (first_name, last_name, universe, phone, email, loyalty_points) VALUES
('Bugs', 'Bunny', 'Looney Tunes', '555-0101', 'bugs@looneymail.com', 320),
('Daffy', 'Duck', 'Looney Tunes', '555-0102', 'daffy@looneymail.com', 85),
('Elmer', 'Fudd', 'Looney Tunes', '555-0103', 'elmer@looneymail.com', 140),
('Porky', 'Pig', 'Looney Tunes', '555-0104', 'porky@looneymail.com', 210),
('Tweety', 'Bird', 'Looney Tunes', '555-0105', 'tweety@looneymail.com', 55),
('Sylvester', NULL, 'Looney Tunes', '555-0106', 'sylvester@looneymail.com', 90),
('Yosemite', 'Sam', 'Looney Tunes', '555-0107', 'yosemite@looneymail.com', 30),
('Speedy', 'Gonzales', 'Looney Tunes', '555-0108', 'speedy@looneymail.com', 175),
('Marvin', 'Martian', 'Looney Tunes', '555-0109', 'marvin@space.com', 400),
('Foghorn', 'Leghorn', 'Looney Tunes', '555-0110', 'foghorn@looneymail.com', 60),
('Tom', NULL, 'Hanna-Barbera', '555-0201', 'tom@hhmail.com', 120),
('Jerry', NULL, 'Hanna-Barbera', '555-0202', 'jerry@hhmail.com', 95),
('Scooby', 'Doo', 'Hanna-Barbera', '555-0203', 'scooby@mysteryinc.com', 280),
('Shaggy', 'Rogers', 'Hanna-Barbera', '555-0204', 'shaggy@mysteryinc.com', 150),
('Fred', 'Flintstone', 'Hanna-Barbera', '555-0205', 'fred@bedrock.net', 310),
('Barney', 'Rubble', 'Hanna-Barbera', '555-0206', 'barney@bedrock.net', 200),
('Yogi', 'Bear', 'Hanna-Barbera', '555-0207', 'yogi@jellystone.com', 45),
('Boo-Boo', 'Bear', 'Hanna-Barbera', '555-0208', 'booboo@jellystone.com', 30),
('Dexter', NULL, 'Cartoon Network', '555-0301', 'dexter@dexterlab.com', 500),
('Dee Dee', NULL, 'Cartoon Network', '555-0302', 'deedee@dexterlab.com', 75),
('Johnny', 'Bravo', 'Cartoon Network', '555-0303', 'johnny@bravo.com', 220),
('Cow', NULL, 'Cartoon Network', '555-0304', 'cow@farmmail.com', 10),
('Chicken', NULL, 'Cartoon Network', '555-0305', 'chicken@farmmail.com', 10),
('Courage', NULL, 'Cartoon Network', '555-0306', 'courage@nowhere.com', 185),
('Mojo', 'Jojo', 'Cartoon Network', '555-0307', 'mojo@townsville.com', 65),
('Him', NULL, 'Cartoon Network', '555-0308', NULL, 50),
('Ed', NULL, 'Cartoon Network', '555-0401', 'ed@edboys.com', 20),
('Edd', NULL, 'Cartoon Network', '555-0402', 'edd@edboys.com', 160),
('Eddy', NULL, 'Cartoon Network', '555-0403', 'eddy@edboys.com', 35),
('Numbuh One', 'Uno', 'Cartoon Network', '555-0501', 'numbuh1@knd.org', 290);

-- ============================================================
-- SERVICES
-- ============================================================
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    description TEXT,
    base_price NUMERIC(8,2) NOT NULL
);

INSERT INTO services (service_name, description, base_price) VALUES
('Dry Clean', 'Standard dry cleaning', 12.99),
('Press & Steam', 'Steam pressing only, no cleaning', 6.99),
('Stain Removal', 'Targeted stain treatment', 9.99),
('Leather Treatment', 'Clean and condition leather garments', 24.99),
('Alterations', 'Basic hem or seam alterations', 19.99),
('Wedding Package', 'Full bridal/formal gown cleaning and preservation', 89.99),
('Fur Treatment', 'Cleaning and conditioning of fur garments', 49.99),
('Deodorize', 'Odor elimination treatment', 7.99),
('Waterproofing', 'Apply waterproof coating', 14.99),
('Rush Service', 'Same-day turnaround surcharge', 15.00);

-- ============================================================
-- GARMENTS
-- ============================================================
CREATE TABLE garments (
    garment_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    garment_type VARCHAR(100) NOT NULL,
    color VARCHAR(50),
    fabric VARCHAR(50),
    notes TEXT
);

INSERT INTO garments (customer_id, garment_type, color, fabric, notes) VALUES
-- Bugs Bunny
(1, 'Tuxedo', 'Black', 'Wool', 'Worn to the Oscars. Again.'),
(1, 'White Gloves', 'White', 'Cotton', 'Four fingers only'),
-- Daffy Duck
(2, 'Tuxedo', 'Black', 'Polyester', 'Rage-induced perspiration stains throughout'),
(2, 'Cape', 'Red', 'Satin', 'Magician cape, rabbit smell'),
-- Elmer Fudd
(3, 'Hunting Jacket', 'Orange', 'Canvas', 'Gunpowder residue, please advise'),
(3, 'Pork Pie Hat', 'Brown', 'Felt', NULL),
-- Porky Pig
(4, 'Suit Jacket', 'Blue', 'Wool', 'No pants needed, never has been'),
(4, 'Bow Tie', 'Red', 'Silk', NULL),
-- Tweety Bird
(5, 'Knitted Sweater', 'Yellow', 'Cashmere', 'Tiny. Very tiny.'),
-- Sylvester
(6, 'Tuxedo Bib', 'Black/White', 'Cotton', 'Fish oil stains'),
-- Yosemite Sam
(7, 'Cowboy Hat', 'Red', 'Felt', 'Singed from multiple explosions'),
(7, 'Chaps', 'Brown', 'Leather', NULL),
-- Scooby Doo
(13, 'Mystery Inc Collar', 'Blue', 'Nylon', 'Covered in Scooby Snack crumbs'),
-- Shaggy Rogers
(14, 'Green T-Shirt', 'Green', 'Cotton', 'Unknown stains, do not ask'),
(14, 'Brown Flares', 'Brown', 'Polyester', NULL),
-- Fred Flintstone
(15, 'Spotted Toga', 'White/Black', 'Linen', 'Prehistoric BBQ stains'),
-- Barney Rubble
(16, 'Spotted Toga', 'Brown/Black', 'Linen', NULL),
-- Dexter
(19, 'Lab Coat', 'White', 'Cotton', 'Chemical burns, various colours'),
(19, 'Bow Tie', 'Black', 'Silk', NULL),
-- Johnny Bravo
(21, 'Muscle Tee', 'White', 'Cotton', 'Excessive hair product transfer'),
(21, 'Blue Jeans', 'Blue', 'Denim', 'Skin tight. Good luck.'),
-- Courage
(24, 'Nothing', NULL, NULL, 'Just wanted company. Sweet dog.'),
-- Edd (Double D)
(28, 'Ski Hat', 'Black', 'Wool', 'Never to be removed. Do not ask.'),
-- Numbuh One
(30, 'Turtleneck', 'Red', 'Cotton', 'Field ops wear, multiple unknown substances'),
(30, 'Sunglasses', 'Black', 'Plastic', 'Not a garment but he insists');

-- ============================================================
-- ORDERS
-- ============================================================
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    employee_id INT NOT NULL REFERENCES employees(employee_id),
    drop_off_date DATE NOT NULL,
    pickup_date DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'Received', -- Received, In Progress, Ready, Picked Up, Cancelled
    total_price NUMERIC(10,2),
    notes TEXT
);

INSERT INTO orders (customer_id, employee_id, drop_off_date, pickup_date, status, total_price, notes) VALUES
(1, 3, '2024-01-05', '2024-01-08', 'Picked Up', 19.98, NULL),
(2, 3, '2024-01-06', NULL, 'Ready', 22.98, 'Customer called 7 times'),
(3, 1, '2024-01-07', '2024-01-10', 'Picked Up', 12.99, NULL),
(4, 3, '2024-01-08', '2024-01-11', 'Picked Up', 6.99, NULL),
(13, 1, '2024-01-10', '2024-01-13', 'Picked Up', 12.99, NULL),
(14, 5, '2024-01-12', '2024-01-15', 'Picked Up', 22.98, NULL),
(15, 4, '2024-01-14', '2024-01-17', 'Picked Up', 12.99, 'Smells like brontosaurus'),
(19, 7, '2024-01-15', '2024-01-16', 'Picked Up', 27.98, 'Rush requested'),
(21, 3, '2024-01-18', '2024-01-21', 'Picked Up', 16.99, NULL),
(7, 1, '2024-02-01', '2024-02-04', 'Picked Up', 34.98, 'Customer very loud'),
(28, 5, '2024-02-03', NULL, 'In Progress', 6.99, 'Do not touch the hat'),
(30, 3, '2024-02-05', '2024-02-06', 'Picked Up', 40.98, 'Rush. Always rush with this one.'),
(1, 4, '2024-02-10', '2024-02-13', 'Picked Up', 12.99, NULL),
(2, 3, '2024-02-14', NULL, 'In Progress', 32.97, 'Claims a ghost spilled something on his cape'),
(9, 6, '2024-02-20', '2024-02-23', 'Picked Up', 49.99, 'Intergalactic shipping inquiry. Declined.'),
(24, 3, '2024-03-01', NULL, 'Received', 0.00, 'Just dropped off the dog. No garments.'),
(16, 4, '2024-03-03', '2024-03-06', 'Picked Up', 12.99, NULL),
(21, 5, '2024-03-05', NULL, 'Ready', 24.99, 'Asked if we had a mirror. We do not.'),
(13, 1, '2024-03-10', NULL, 'In Progress', 20.98, NULL),
(19, 7, '2024-03-12', NULL, 'Ready', 15.98, NULL);

-- ============================================================
-- ORDER ITEMS
-- ============================================================
CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id),
    garment_id INT REFERENCES garments(garment_id),
    service_id INT NOT NULL REFERENCES services(service_id),
    price NUMERIC(8,2) NOT NULL,
    employee_id INT REFERENCES employees(employee_id) -- who handled this specific item
);

INSERT INTO order_items (order_id, garment_id, service_id, price, employee_id) VALUES
(1, 1, 1, 12.99, 1),
(1, 2, 2, 6.99, 4),
(2, 3, 1, 12.99, 1),
(2, 4, 3, 9.99, 7),
(3, 5, 1, 12.99, 1),
(4, 8, 2, 6.99, 4),
(5, 13, 1, 12.99, 1),
(6, 14, 1, 12.99, 5),
(6, 15, 2, 6.99, 4),
(7, 16, 1, 12.99, 1),
(8, 19, 1, 12.99, 7),
(8, 20, 10, 15.00, 3),
(9, 21, 1, 12.99, 5),
(9, 22, 3, 9.99, 7),  -- hair product = stain removal, obviously
(10, 11, 4, 24.99, 7),
(10, 12, 3, 9.99, 7),
(11, 23, 2, 6.99, 5),
(12, 24, 1, 12.99, 1),
(12, 25, 10, 15.00, 3),
(12, 24, 3, 9.99, 7),
(13, 1, 1, 12.99, 1),
(14, 3, 1, 12.99, 1),
(14, 4, 3, 9.99, 7),
(14, 4, 8, 7.99, 6),
(15, NULL, 7, 49.99, 7),
(17, 17, 1, 12.99, 1),
(18, 22, 4, 24.99, 7),
(19, 13, 1, 12.99, 1),
(19, 13, 3, 7.99, 7),
(20, 19, 1, 12.99, 7),
(20, 20, 3, 9.99, 7);  -- lab coat chemical burns = stain removal attempt
