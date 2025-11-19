-- Recommended SQL script to create the tables before importing the CSV data.

-- IMPORTANT: Run this script in the Query Tool of your PostgreSQL database.

-- 1. Create the pizza_types table (No Foreign Keys)
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY, -- e.g., 'bbq_ckn'
    name VARCHAR(100),                      -- e.g., 'The Barbecue Chicken Pizza'
    category VARCHAR(50),                   -- e.g., 'Chicken'
    ingredients TEXT                        -- e.g., 'Barbecued Chicken, Red Peppers, ...'
) ENGINE=InnoDB;

-- 2. Create the pizzas table (FK to pizza_types)
CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,   -- e.g., 'bbq_ckn_s'
    pizza_type_id VARCHAR(50) REFERENCES pizza_types(pizza_type_id),
    size VARCHAR(10),                   -- e.g., 'S', 'M', 'L'
    price DECIMAL(5, 2)                 -- e.g., 12.75
) ENGINE=InnoDB;

-- 3. Create the orders table (No Foreign Keys)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    date DATE,
    time TIME
) ENGINE=InnoDB;

-- 4. Create the order_details table (FK to orders and pizzas)
CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    pizza_id VARCHAR(50) REFERENCES pizzas(pizza_id),
    quantity INT
) ENGINE=InnoDB;