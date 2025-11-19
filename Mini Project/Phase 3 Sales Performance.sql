USE idc_pizza;

-- 1. Total quantity of pizzas sold (`SUM`).
SELECT SUM(quantity) as total_pizzas_sold FROM order_details;

-- 2. Average pizza price (`AVG`).
SELECT ROUND(AVG(price), 2) AS avg_pizza_price FROM pizzas;

-- 3. Total order value per order (`JOIN`, `SUM`, `GROUP BY`).
	

-- 4. Total quantity sold per pizza category (`JOIN`, `GROUP BY`).


-- 5. Categories with more than 5,000 pizzas sold (`HAVING`).


-- 6. Pizzas never ordered (`LEFT/RIGHT JOIN`).


-- 7. Price differences between different sizes of the same pizza (`SELF JOIN`).