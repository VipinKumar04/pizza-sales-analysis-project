--21. SecondFind the second highest priced pizza.
SELECT * FROM pizzas
ORDER BY price DESC
LIMIT 1 OFFSET 1;

--22.Find the category that generated the highest revenue.
SELECT pt.category,
SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_type pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_revenue DESC
LIMIT 1;

--23.Find the most ordered pizza in each category.
SELECT category, name_, total_quantity
FROM (SELECT 
        pt.category,pt.name_,
        SUM(od.quantity) AS total_quantity,
        RANK() OVER (
            PARTITION BY pt.category 
            ORDER BY SUM(od.quantity) DESC
        ) AS rnk
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_type pt 
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name_
) sub
WHERE rnk = 1;

--24.Find orders that contain more than one type of pizza.
SELECT 
    order_id,
    COUNT(DISTINCT pizza_id) AS pizza_types
FROM order_details
GROUP BY order_id
HAVING COUNT(DISTINCT pizza_id) > 1;

--25.Show cumulative revenue over time.
SELECT o.date_,SUM(od.quantity * p.price) AS daily_revenue,
    SUM(SUM(od.quantity * p.price)) OVER (
        ORDER BY o.date_
    ) AS running_total
FROM orders o
JOIN order_details od 
    ON o.order_id = od.order_id
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
GROUP BY o.date_
ORDER BY o.date_;

--26.Use a Common Table Expression to calculate daily revenue and display it.
WITH daily_revenue AS (
    SELECT o.date_,
    SUM(od.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_details od 
    ON o.order_id = od.order_id
    JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
    GROUP BY o.date_
)
SELECT *
FROM daily_revenue
ORDER BY date_;

--27.Find the top 3 pizzas generating highest revenue using a CTE.
WITH pizza_revenue AS (
    SELECT 
        pt.name_,
        SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_type pt 
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name_
)
SELECT *
FROM pizza_revenue
ORDER BY total_revenue DESC
LIMIT 3;

--28.Rank pizzas based on revenue from highest to lowest using CTE.
WITH pizza_revenue AS (
    SELECT 
        pt.name_,
        SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_type pt 
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name_
)

SELECT name_,total_revenue, 
RANK() OVER (ORDER BY total_revenue DESC) AS rank
FROM pizza_revenue;

--29.Calculate average revenue per order using a CTE.
WITH order_revenue AS (
    SELECT 
        od.order_id,
        SUM(od.quantity * p.price) AS revenue_per_order
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    GROUP BY od.order_id
)
SELECT 
    AVG(revenue_per_order) AS avg_order_value
FROM order_revenue;

--30.Find percentage contribution of each category in total revenue using CTE.
WITH category_revenue AS (
    SELECT 
        pt.category,
        SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_type pt 
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category
)

SELECT 
    category,
    revenue,
    ROUND((revenue * 100.0 / SUM(revenue) OVER ())::numeric, 2) 
        AS percentage_contribution
FROM category_revenue
ORDER BY percentage_contribution DESC;