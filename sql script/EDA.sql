--EDA

select distinct order_status from orders;

-- Completed
select min(order_id) from orders where order_status = 'Completed'; --order_id =1

select * from orders where order_id =1; --order_date =2021-09-02

select * from payments where order_id = 1; -- payment_date = 2021-09-02, payment_status = 'Payment Successed'

select * from shippings where order_id = 1; -- shipped_date = 2021-09-03, returned_date = null, delivery_status = Delivered

-- Inprogress
select min(order_id) from orders where order_status = 'Inprogress'; --order_id =15

select * from orders where order_id =15; --order_date =2022-11-20

select * from payments where order_id = 15; --payment_date = 2022-11-20, payment_status = 'Payment Successed'

select * from shippings where order_id = 15; -- shipped_date = 2021-11-25, returned_date = null, delivery_status = Shipped

-- Returned
select min(order_id) from orders where order_status = 'Returned'; --order_id =13

select * from orders where order_id =13; --order_date =2022-09-05

select * from payments where order_id = 13; --payment_date = 2022-09-05, payment_status = 'Refunded'

select * from shippings where order_id = 13;-- shipped_date = 2022-09-10, returned_date = 2022-09-21, delivery_status = Returned

-- Cancelled

select min(order_id) from orders where order_status = 'Cancelled' --order_id =2

select * from orders where order_id =2; --order_date =2023-12-19

select * from payments where order_id = 2; --payment_date = 2023-12-19, payment_status = 'Payment Failed'

select * from shippings where order_id = 2;-- shipped_date = null, returned_date = null, delivery_status = null


--clothing 
--sales count derease in fisrt decline, no sales after second decline
select
	to_char(order_date,'YYYY-MM') order_month,
	category_name,
	count(o.order_id) sales_count,
	round(cast(sum(total_sales) as numeric),2) total_sales,
	round(cast(avg(total_sales) as numeric),2) average_sales
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join categories c
on p.category_id = c.category_id
where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08' and category_name='clothing' and (order_status = 'Completed' or order_status = 'Inprogress')
group by order_month, category_name

--home & kitchen
--sales count derease in fisrt decline, 2024-02, average sales decrease in 2024-03
select
	to_char(order_date,'YYYY-MM') order_month,
	category_name,
	count(o.order_id) sales_count,
	round(cast(sum(total_sales) as numeric),2) total_sales,
	round(cast(avg(total_sales) as numeric),2) average_sales
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join categories c
on p.category_id = c.category_id
where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08' and category_name='home & kitchen' and (order_status = 'Completed' or order_status = 'Inprogress')
group by order_month, category_name

--Pet Supplies
--no decrease fisrt decline, second decline
select
	to_char(order_date,'YYYY-MM') order_month,
	category_name,
	count(o.order_id) sales_count,
	round(cast(sum(total_sales) as numeric),2) total_sales,
	round(cast(avg(total_sales) as numeric),2) average_sales
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join categories c
on p.category_id = c.category_id
where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08' and category_name='Pet Supplies' and (order_status = 'Completed' or order_status = 'Inprogress')
group by order_month, category_name


--Sports & Outdoors
--sales count derease in fisrt decline, increase in 2024-02
select
	to_char(order_date,'YYYY-MM') order_month,
	category_name,
	count(o.order_id) sales_count,
	round(cast(sum(total_sales) as numeric),2) total_sales,
	round(cast(avg(total_sales) as numeric),2) average_sales
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join categories c
on p.category_id = c.category_id
where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08' and category_name='Sports & Outdoors' and (order_status = 'Completed' or order_status = 'Inprogress')
group by order_month, category_name


--Toys & Games
--sales count derease in fisrt decline, decrease in 2024-02
select
	to_char(order_date,'YYYY-MM') order_month,
	category_name,
	count(o.order_id) sales_count,
	round(cast(sum(total_sales) as numeric),2) total_sales,
	round(cast(avg(total_sales) as numeric),2) average_sales
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join categories c
on p.category_id = c.category_id
where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08' and category_name='Toys & Games' and (order_status = 'Completed' or order_status = 'Inprogress')
group by order_month, category_name


--electronics
--sales count derease in first decline, second decline
select
	to_char(order_date,'YYYY-MM') order_month,
	category_name,
	count(o.order_id) sales_count,
	round(cast(sum(total_sales) as numeric),2) total_sales,
	round(cast(avg(total_sales) as numeric),2) average_sales
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join categories c
on p.category_id = c.category_id
where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08' and category_name='electronics' and (order_status = 'Completed' or order_status = 'Inprogress')
group by order_month, category_name
