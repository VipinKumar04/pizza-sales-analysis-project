CREATE TABLE order_details(
order_details_id int primary key,
order_id int,
pizza_id varchar(50),
quantity int
);

CREATE TABLE orders(
order_id int,
date_ date,
time_ time,
foreign key (order_id) references order_details (order_details_id)
);

CREATE TABLE pizza_type(
pizza_type_id varchar(50),
name_ varchar(50),
category varchar(50),
indredients varchar(100)
);

CREATE TABLE pizzas(
pizza_id varchar(50),
pizza_type_id varchar(50),
size_ varchar(5),
price int
);

alter table pizzas
add primary key (pizza_id);

alter table order_details
add foreign key (pizza_id)
references pizzas(pizza_id);

alter table pizza_type
add primary key (pizza_type_id);

alter table pizzas
add foreign key (pizza_type_id)
references pizza_type(pizza_type_id);