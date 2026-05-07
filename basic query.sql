--1.Write a query to find the total number of orders placed.
select count(order_id)
from order_details;

--2.Find the total number of pizzas sold.
select count(quantity)
from order_details;

--3.Display the name, size, and price of all pizzas.
select pizza_type.name_,
pizzas.price , pizzas.size_
from pizza_type join
pizzas 
on pizza_type.pizza_type_id = pizzas.pizza_type_id;

--4.Find all the distinct pizza categories available.
select distinct category
from pizza_type;

--5.Find the name and price of the most expensive pizza.
select pizza_type.name_,
pizzas.price 
from pizzas
join pizza_type
on pizzas.pizza_type_id = pizza_type.pizza_type_id
order by pizzas.price desc
limit 1;

--6.Find the total number of orders placed on each date.
select date_,count(order_id)
from orders
group by date_;

--7.Find the pizza type that has been ordered the most based on quantity.
select pizza_type.name_,
sum(order_details.quantity)
from order_details join
pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_type
on pizza_type.pizza_type_id = pizzas.pizza_type_id
group by pizza_type.name_
order by sum(order_details.quantity) desc
limit 1;

--8.Find the total quantity sold for each pizza size.
select pizzas.size_,
sum(order_details.quantity)
from order_details join
pizzas
on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size_;

--9.Display the top 5 pizzas ordered based on quantity.
select pizza_type.name_,
sum(order_details.quantity)
from order_details join
pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_type
on pizza_type.pizza_type_id = pizzas.pizza_type_id
group by pizza_type.name_
order by sum(order_details.quantity) desc
limit 5;

--10.Find the number of pizza types available in each category.
select category, count(pizza_type_id)
from pizza_type
group by category;


