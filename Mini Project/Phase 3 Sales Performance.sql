USE idc_pizza;

-- 1. Total quantity of pizzas sold (`SUM`).
SELECT SUM(quantity) as total_pizzas_sold FROM order_details;

-- 2. Average pizza price (`AVG`).
SELECT ROUND(AVG(price), 2) AS avg_pizza_price FROM pizzas;

-- 3. Total order value per order (`JOIN`, `SUM`, `GROUP BY`).
SELECT
	od.order_id,
    SUM(p.price) AS total_order_value
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id;

SELECT od.order_id, SUM(p.price) AS total_order_value FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id GROUP BY od.order_id;

-- 4. Total quantity sold per pizza category (`JOIN`, `GROUP BY`).
SELECT
	pt.category,
    SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

SELECT pt.category, SUM(od.quantity) AS total_sold FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id GROUP BY pt.category;

-- 5. Categories with more than 5,000 pizzas sold (`HAVING`).
SELECT
	pt.category,
    SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
HAVING total_sold > 5000;

SELECT pt.category, SUM(od.quantity) AS total_sold FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id GROUP BY pt.category HAVING total_sold > 5000; 

-- 6. Pizzas never ordered (`LEFT/RIGHT JOIN`).
SELECT
	p.*
FROM pizzas p
LEFT JOIN order_details od ON p.pizza_id = od.pizza_id
WHERE od.pizza_id IS NULL;

SELECT p.* FROM pizzas p LEFT JOIN order_details od ON p.pizza_id = od.pizza_id WHERE od.pizza_id IS NULL;

-- 7. Price differences between different sizes of the same pizza (`SELF JOIN`).
SELECT 
	p1.pizza_type_id,
    p1.size AS size1,
    p1.price AS price1,
    p2.size AS size2,
    p2.price AS price2,
    (p2.price - p1.price) AS price_difference
FROM pizzas p1
JOIN pizzas p2 
	ON p1.pizza_type_id = p2.pizza_type_id
	AND (
		CASE p1.size
				WHEN 'S' THEN 1
                WHEN 'M' THEN 2
                WHEN 'L' THEN 3
                WHEN 'XL' THEN 4
                WHEN 'XXL' THEN 5
		END
        <
        CASE p2.size
				WHEN 'S' THEN 1
                WHEN 'M' THEN 2
                WHEN 'L' THEN 3
                WHEN 'XL' THEN 4
                WHEN 'XXL' THEN 5
		END
    )
ORDER BY p1.pizza_type_id, p1.size, p2.size;

SELECT p1.pizza_type_id, p1.size AS size1, p1.price AS price1, p2.size AS size2, p2.price AS price2, (p2.price - p1.price) AS price_difference FROM pizzas p1 JOIN pizzas p2 ON p1.pizza_type_id = p2.pizza_type_id AND (CASE p1.size WHEN 'S' THEN 1 WHEN 'M' THEN 2 WHEN 'L' THEN 3 WHEN 'XL' THEN 4 WHEN 'XXL' THEN 5 END < CASE p2.size WHEN 'S' THEN 1 WHEN 'XXL' THEN 5 END) ORDER BY p1.pizza_type_id, p1.size, p2.size;