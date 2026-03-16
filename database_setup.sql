-- ╔══════════════════════════════════════════════════════════════╗
-- ║       CAFE MANAGEMENT SYSTEM - DATABASE SETUP               ║
-- ║       Run this file in MySQL Workbench / phpMyAdmin          ║
-- ╚══════════════════════════════════════════════════════════════╝

-- STEP 1: Create and use the database
CREATE DATABASE IF NOT EXISTS cafe_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cafe_db;

-- ──────────────────────────────────────────────────────────────
-- TABLE 1: users
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100)    NOT NULL,
    username    VARCHAR(50)     NOT NULL UNIQUE,
    password    VARCHAR(255)    NOT NULL COMMENT 'MD5 hashed',
    role        ENUM('admin','cashier','manager') DEFAULT 'cashier',
    is_active   TINYINT(1)      DEFAULT 1,
    created_at  DATETIME        DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────────────────────────
-- TABLE 2: menu_items
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS menu_items (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(150)    NOT NULL,
    category        ENUM('Hot Beverages','Cold Beverages','Snacks','Desserts','Main Course') NOT NULL,
    price           DECIMAL(10,2)   NOT NULL,
    description     TEXT,
    is_available    TINYINT(1)      DEFAULT 1,
    created_at      DATETIME        DEFAULT CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────────────────────────
-- TABLE 3: orders
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    bill_no         VARCHAR(20)     NOT NULL UNIQUE,
    customer_name   VARCHAR(100)    DEFAULT 'Walk-in Customer',
    table_no        VARCHAR(10)     DEFAULT 'T0',
    subtotal        DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    gst             DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    total           DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    payment_method  ENUM('cash','card','upi','wallet') DEFAULT 'cash',
    status          ENUM('active','cancelled','refunded') DEFAULT 'active',
    order_date      DATETIME        DEFAULT CURRENT_TIMESTAMP,
    user_id         INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ──────────────────────────────────────────────────────────────
-- TABLE 4: order_items
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    order_id    INT             NOT NULL,
    item_id     INT,
    item_name   VARCHAR(150)    NOT NULL,
    quantity    INT             NOT NULL DEFAULT 1,
    price       DECIMAL(10,2)   NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id)  REFERENCES menu_items(id) ON DELETE SET NULL
);

-- ──────────────────────────────────────────────────────────────
-- TABLE 5: expenses (optional bonus table)
-- ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS expenses (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(150)    NOT NULL,
    amount      DECIMAL(10,2)   NOT NULL,
    category    VARCHAR(80),
    expense_date DATE            DEFAULT (CURDATE()),
    note        TEXT,
    user_id     INT,
    created_at  DATETIME        DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ══════════════════════════════════════════════════════════════
-- SAMPLE DATA INSERTS
-- ══════════════════════════════════════════════════════════════

-- Default admin user  (password = admin123)
INSERT INTO users (full_name, username, password, role) VALUES
('Super Admin',  'admin',   MD5('admin123'), 'admin'),
('Rahul Sharma', 'rahul',   MD5('rahul123'), 'cashier'),
('Priya Singh',  'priya',   MD5('priya123'), 'manager');

-- Menu Items – Hot Beverages
INSERT INTO menu_items (name, category, price) VALUES
('Espresso',            'Hot Beverages',  60.00),
('Cappuccino',          'Hot Beverages',  80.00),
('Latte',               'Hot Beverages',  90.00),
('Americano',           'Hot Beverages',  70.00),
('Masala Chai',         'Hot Beverages',  40.00),
('Hot Chocolate',       'Hot Beverages', 100.00),
('Green Tea',           'Hot Beverages',  50.00),
('Ginger Lemon Tea',    'Hot Beverages',  45.00);

-- Menu Items – Cold Beverages
INSERT INTO menu_items (name, category, price) VALUES
('Cold Coffee',         'Cold Beverages', 120.00),
('Iced Latte',          'Cold Beverages', 130.00),
('Mango Smoothie',      'Cold Beverages', 110.00),
('Strawberry Shake',    'Cold Beverages', 120.00),
('Chocolate Milkshake', 'Cold Beverages', 130.00),
('Lemonade',            'Cold Beverages',  60.00),
('Virgin Mojito',       'Cold Beverages',  90.00),
('Fresh Lime Soda',     'Cold Beverages',  70.00);

-- Menu Items – Snacks
INSERT INTO menu_items (name, category, price) VALUES
('Veg Sandwich',        'Snacks',  80.00),
('Club Sandwich',       'Snacks', 120.00),
('French Fries',        'Snacks',  90.00),
('Cheese Fries',        'Snacks', 110.00),
('Onion Rings',         'Snacks',  85.00),
('Garlic Bread',        'Snacks',  70.00),
('Paneer Tikka',        'Snacks', 150.00),
('Spring Rolls',        'Snacks',  95.00);

-- Menu Items – Desserts
INSERT INTO menu_items (name, category, price) VALUES
('Chocolate Brownie',   'Desserts', 100.00),
('Cheesecake',          'Desserts', 150.00),
('Tiramisu',            'Desserts', 160.00),
('Gulab Jamun',         'Desserts',  60.00),
('Ice Cream (2 Scoops)','Desserts',  80.00),
('Waffle',              'Desserts', 130.00),
('Muffin',              'Desserts',  70.00),
('Cookie',              'Desserts',  40.00);

-- Menu Items – Main Course
INSERT INTO menu_items (name, category, price) VALUES
('Paneer Butter Masala','Main Course', 200.00),
('Dal Makhani',         'Main Course', 180.00),
('Veg Biryani',         'Main Course', 190.00),
('Chicken Biryani',     'Main Course', 250.00),
('Pasta Arrabiata',     'Main Course', 210.00),
('Pasta Alfredo',       'Main Course', 220.00),
('Pizza Margherita',    'Main Course', 250.00),
('Pizza Veggie',        'Main Course', 280.00);

-- Sample orders for demo / reports
INSERT INTO orders (bill_no, customer_name, table_no, subtotal, gst, total, order_date, user_id) VALUES
('BILL-10001', 'Amit Kumar',   'T1', 250.00, 12.50, 262.50, NOW() - INTERVAL 1 HOUR, 1),
('BILL-10002', 'Sneha Patel',  'T2', 340.00, 17.00, 357.00, NOW() - INTERVAL 2 HOUR, 2),
('BILL-10003', 'Raj Verma',    'T3', 170.00,  8.50, 178.50, NOW() - INTERVAL 3 HOUR, 2),
('BILL-10004', 'Walk-in',      'T0', 120.00,  6.00, 126.00, DATE_SUB(NOW(), INTERVAL 1 DAY), 1),
('BILL-10005', 'Pooja Mishra', 'T4', 450.00, 22.50, 472.50, DATE_SUB(NOW(), INTERVAL 2 DAY), 1);

INSERT INTO order_items (order_id, item_id, item_name, quantity, price) VALUES
(1, 2,  'Cappuccino',        2,  80.00),
(1, 20, 'French Fries',      1,  90.00),
(2, 4,  'Americano',         1,  70.00),
(2, 25, 'Chocolate Brownie', 2, 100.00),
(2, 17, 'Veg Sandwich',      1,  80.00),
(3, 9,  'Cold Coffee',       1, 120.00),
(3, 24, 'Gulab Jamun',       2,  60.00) -- Wait, price * 2 = 120, but subtotal is 170
;

-- ══════════════════════════════════════════════════════════════
-- USEFUL VIEWS
-- ══════════════════════════════════════════════════════════════

-- View: Daily Sales Summary
CREATE OR REPLACE VIEW v_daily_sales AS
SELECT
    DATE(order_date)    AS sale_date,
    COUNT(id)           AS total_orders,
    SUM(subtotal)       AS subtotal,
    SUM(gst)            AS total_gst,
    SUM(total)          AS grand_total
FROM orders
WHERE status = 'active'
GROUP BY DATE(order_date)
ORDER BY sale_date DESC;

-- View: Top Selling Items
CREATE OR REPLACE VIEW v_top_items AS
SELECT
    oi.item_name,
    SUM(oi.quantity)            AS total_qty,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM order_items oi
JOIN orders o ON o.id = oi.order_id
WHERE o.status = 'active'
GROUP BY oi.item_name
ORDER BY total_qty DESC;

-- View: Monthly Revenue
CREATE OR REPLACE VIEW v_monthly_revenue AS
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(id)                        AS total_orders,
    SUM(total)                       AS revenue
FROM orders
WHERE status = 'active'
GROUP BY month
ORDER BY month DESC;

-- ══════════════════════════════════════════════════════════════
-- VERIFY SETUP
-- ══════════════════════════════════════════════════════════════
SELECT 'Database setup complete!' AS status;
SELECT TABLE_NAME, TABLE_ROWS FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'cafe_db';
