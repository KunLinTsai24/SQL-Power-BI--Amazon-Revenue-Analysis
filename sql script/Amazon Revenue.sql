--Success Sales Revenue Analysis for current month (July 2024)

--What is the total revenue?
select
	to_char(order_date,'YYYY-MM') order_month,
	round(cast(sum(total_sales) as numeric),2) total_sales
from orders o
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
where to_char(order_date,'YYYY-MM') = '2024-07' and (order_status = 'Completed' or order_status = 'Inprogress')
group by order_month

-- What is the MoM percentage change? 
with current_month as(
	select
		to_char(order_date,'YYYY-MM') order_month,
		round(cast(sum(total_sales) as numeric),2) total_sales
	from orders o
	join order_items oi
	on o.order_id = oi.order_id
	join products p
	on oi.product_id = p.product_id
	where to_char(order_date,'YYYY-MM') = '2024-07' and (order_status = 'Completed' or order_status = 'Inprogress')
	group by order_month
),
	last_month as(
	select
		to_char(order_date,'YYYY-MM') order_month,
		round(cast(sum(total_sales) as numeric),2) total_sales
	from orders o
	join order_items oi
	on o.order_id = oi.order_id
	join products p
	on oi.product_id = p.product_id
	where to_char(order_date,'YYYY-MM') = '2024-06' and (order_status = 'Completed' or order_status = 'Inprogress')
	group by order_month
),
	MoM as(
	select * from current_month
	union 
	select * from last_month
)

select
	round(cast((current_month_sales-last_month_sales)/last_month_sales*100 as numeric),2) MoM_change_percentage
from(
	select
		order_month,
		total_sales current_month_sales,
		lag (total_sales,1) over(order by order_month) last_month_sales
	from MoM
)t1
where last_month_sales is not null



-- What is the YoY percentage change?
with current_month as(
	select
		to_char(order_date,'YYYY-MM') order_month,
		round(cast(sum(total_sales) as numeric),2) total_sales
	from orders o
	join order_items oi
	on o.order_id = oi.order_id
	join products p
	on oi.product_id = p.product_id
	where to_char(order_date,'YYYY-MM') = '2024-07' and (order_status = 'Completed' or order_status = 'Inprogress')
	group by order_month
),	
	current_month_last_year as(
	select
		to_char(order_date,'YYYY-MM') order_month,
		round(cast(sum(total_sales) as numeric),2) total_sales
	from orders o
	join order_items oi
	on o.order_id = oi.order_id
	join products p
	on oi.product_id = p.product_id
	where to_char(order_date,'YYYY-MM') = '2023-07' and (order_status = 'Completed' or order_status = 'Inprogress')
	group by order_month
),
	YoY as(
select * from current_month
union
select * from current_month_last_year
	)

select
	round(cast((current_year_sales-current_month_last_year_sales)/current_month_last_year_sales*100 as numeric),2) YoY_change_percentage
from(
	select
		order_month,
		total_sales current_year_sales,
		lag (total_sales,1) over(order by order_month) current_month_last_year_sales
	from YoY
)t1
where current_month_last_year_sales is not null



-- What is the monthly trend of total revenue between August 2023 and July 2024?

with order_sales as(
	select 
		order_id,
		sum(total_sales) order_sales
	from order_items
	group by order_id
),
	successful_sales as(
	select
		o.order_id, o.order_date,o.customer_id, o.seller_id, o.order_status, os.order_sales
	from orders o
	join order_sales os
	on o.order_id = os.order_id
	where order_status = 'Completed' or order_status = 'Inprogress'
)

select
	order_month,
	current_month_sales,
	last_month_sales,
	round(cast ((current_month_sales-last_month_sales)/last_month_sales*100 as numeric),2) MoM_change
from(
	select
		to_char(order_date,'YYYY-MM') order_month,
		round(cast (sum(order_sales) as numeric),2) current_month_sales,
		lead (round(cast (sum(order_sales) as numeric),2),1) over(order by to_char(order_date,'YYYY-MM') desc) last_month_sales
	from successful_sales ss
	where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08'
	group by order_month
	order by order_month desc
)t1



-- Product Performance Analysis from January to March 

-- Contribution to Revenue Decline by Category

with order_sales as(
	select 
		order_id,
		sum(total_sales) order_sales
	from order_items
	group by order_id
),
	successful_sales as(
	select
		o.order_id, o.order_date,o.customer_id, o.seller_id, o.order_status, os.order_sales
	from orders o
	join order_sales os
	on o.order_id = os.order_id
	where order_status = 'Completed' or order_status = 'Inprogress'
)

select
	category_name,
	january_sales,
	march_sales,
	mom_change,
	mom_change_percentage,
	round(cast (decline_contribution_percentage as numeric), 2) decline_contribution_percentage,
	round(cast (sum(decline_contribution_percentage) over(order by decline_contribution_percentage desc) as numeric), 2) acummulative_decline_contribution
from(	
	select 
		category_name,
		round(cast(january_sales as numeric),2) january_sales,
		round(cast(march_sales as numeric),2) march_sales,
		round(cast((march_sales - january_sales) as numeric),2) mom_change,
		round(cast((march_sales - january_sales) / january_sales*100 as numeric),2) mom_change_percentage,
		case when march_sales - january_sales<0 
			 then (march_sales - january_sales)/sum(case when march_sales - january_sales<0 then march_sales - january_sales else 0 end) over()*100
			 else 0 end decline_contribution_percentage
	from(
		select 
			c.category_name,
			to_char(order_date,'YYYY-MM') order_month,
			sum(total_sales) march_sales,
			lead(sum(total_sales),1) over(partition by category_name order by to_char(order_date,'YYYY-MM') desc) january_sales
		from successful_sales ss
		join order_items oi
		on ss.order_id = oi.order_id
		join products p
		on oi.product_id = p.product_id
		join categories c
		on p.category_id = c.category_id
		where to_char(order_date,'YYYY-MM') in ('2024-01','2024-03')
		group by 
			c.category_name,
			to_char(order_date,'YYYY-MM')
	)t1
	where january_sales is not null
	order by decline_contribution_percentage desc
)t2

-- Identifying Specific Products Contributing to Revenue Decline in Electronics

with order_sales as(
	select 
		order_id,
		sum(total_sales) order_sales
	from order_items
	group by order_id
),
	successful_sales as(
	select
		o.order_id, o.order_date,o.customer_id, o.seller_id, o.order_status, os.order_sales
	from orders o
	join order_sales os
	on o.order_id = os.order_id
	where order_status = 'Completed' or order_status = 'Inprogress'
)
select
	product_name,
	january_sales,
	march_sales,
	mom_change,
	mom_change_percentage,
	round(cast (decline_contribution_percentage as numeric), 2) decline_contribution_percentage,
	round(cast (sum(decline_contribution_percentage) over(order by decline_contribution_percentage desc) as numeric), 2) acummulative_decline_contribution
from(	
	select 
		product_name,
		round(cast(january_sales as numeric),2) january_sales,
		round(cast(march_sales as numeric),2) march_sales,
		round(cast((march_sales - january_sales) as numeric),2) mom_change,
		round(cast((march_sales - january_sales) / january_sales*100 as numeric),2) mom_change_percentage,
		case when march_sales - january_sales<0 
			 then (march_sales - january_sales)/sum(case when march_sales - january_sales<0 then march_sales - january_sales else 0 end) over()*100
			 else 0 end decline_contribution_percentage
	from(
		select 
			p.product_name,
			to_char(order_date,'YYYY-MM') order_month,
			sum(total_sales) march_sales,
			lead(sum(total_sales),1) over(partition by p.product_name order by to_char(order_date,'YYYY-MM') desc) january_sales
		from successful_sales ss
		join order_items oi
		on ss.order_id = oi.order_id
		join products p
		on oi.product_id = p.product_id
		join categories c
		on p.category_id = c.category_id
		where to_char(order_date,'YYYY-MM') in ('2024-01','2024-03')
		group by 
			p.product_name,
			to_char(order_date,'YYYY-MM')
	)t1
	where january_sales is not null
	order by decline_contribution_percentage desc
)t2
order by decline_contribution_percentage desc
limit 20

--Returned loss revenue analysis
--What is the trend of Returned Loss Ratio (Returned Loss Revenue/ Revenue)?

with order_sales as(
	select 
		order_id,
		sum(total_sales) order_sales
	from order_items
	group by order_id
),
	successful_sales as(
	select
		o.order_id, o.order_date,o.customer_id, o.seller_id, o.order_status, os.order_sales
	from orders o
	join order_sales os
	on o.order_id = os.order_id
	where order_status = 'Completed' or order_status = 'Inprogress'
),
	sales_loss_sales as(
	select
		o.order_id, o.order_date,o.customer_id, o.seller_id, o.order_status, os.order_sales
	from orders o
	join order_sales os
	on o.order_id = os.order_id
	where order_status = 'Returned'
),
	successful_sales_month_trend as(
	select
		to_char(order_date,'YYYY-MM') order_month,
		round(cast (sum(order_sales) as numeric),2) month_sales
	from successful_sales pls
	where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08'
	group by order_month
	order by order_month desc
	),
	sales_loss_month_trend as(
	select
		to_char(order_date,'YYYY-MM') order_month,
		round(cast (sum(order_sales) as numeric),2) sales_loss
	from sales_loss_sales pls
	where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08'
	group by order_month
	order by order_month desc
	)

select
	order_month,
	sales_loss,
	month_sales,
	current_month_sales_loss_percentage,
	last_month_sales_loss_percentage,
	current_month_sales_loss_percentage - last_month_sales_loss_percentage mom_change
from(
	select
		pl.order_month,
		pl.sales_loss,
		ss.month_sales,
		round(cast(pl.sales_loss/(pl.sales_loss + ss.month_sales)*100 as numeric),2) current_month_sales_loss_percentage,
		lead(round(cast(pl.sales_loss/(pl.sales_loss + ss.month_sales)*100 as numeric),2),1) over(order by pl.order_month desc) last_month_sales_loss_percentage
	from sales_loss_month_trend pl
	join successful_sales_month_trend ss
	on pl.order_month = ss.order_month
)t1


-- Why is the ratio decrease in March?

-- Returned loss revenue decrease more than revenue?

with order_sales as(
	select 
		order_id,
		sum(total_sales) order_sales
	from order_items
	group by order_id
),
not_cancelled_sales as(
	select
		o.order_id, o.order_date,o.customer_id, o.seller_id, o.order_status, os.order_sales
	from orders o
	join order_sales os
	on o.order_id = os.order_id
	where order_status <> 'Cancelled'
), 
	order_shipping_in_feb_and_mar as(
	select 
		ncs.order_id,
		order_date,
		order_sales,
		shipping_date,
		shipping_providers,
		order_status
	from not_cancelled_sales ncs
	join shippings s
	on ncs.order_id = s.order_id
	where to_char(order_date,'YYYY-MM') in ('2024-02','2024-03')
)

select
	success_tag,
	round(cast(feb_sales as numeric),2) feb_sales,
	round(cast(march_sales as numeric),2) march_sales,
	round(cast((march_sales-feb_sales)/ feb_sales*100 as numeric),2) mom_change
from(
	select 
		order_month,
		success_tag,
		sales feb_sales,
		lead(sales,1) over(partition by success_tag order by order_month) march_sales
	from(
		select
				to_char(order_date,'YYYY-MM') order_month,
				case when order_status = 'Completed' or order_status = 'Inprogress' then 'Successful_sales'
					 else 'Loss sales' end as success_tag,
				sum(order_sales) sales
			from order_shipping_in_feb_and_mar
			group by
				success_tag,
				order_month
			order by success_tag desc,order_month 
	)t1
	order by success_tag desc
)t2
where order_month = '2024-02'

-- Which shipping provider contribute more in returned loss revenue decrease

with order_sales as(
	select 
		order_id,
		sum(total_sales) order_sales
	from order_items
	group by order_id
),
not_cancelled_sales as(
	select
		o.order_id, o.order_date,o.customer_id, o.seller_id, o.order_status, os.order_sales
	from orders o
	join order_sales os
	on o.order_id = os.order_id
	where order_status <> 'Cancelled'
), 
	order_shipping_in_feb_and_mar as(
	select 
		ncs.order_id,
		order_date,
		order_sales,
		shipping_date,
		shipping_providers,
		order_status
	from not_cancelled_sales ncs
	join shippings s
	on ncs.order_id = s.order_id
	where to_char(order_date,'YYYY-MM') in ('2024-02','2024-03')
)

select
	round(cast((fedex_mar-fedex_feb)/((fedex_mar+dhl_mar+bluedart_mar)-(fedex_feb+dhl_feb+bluedart_feb))*100 as numeric),2) fedex_returned_change_contribution_percentage,
	round(cast((dhl_mar-dhl_feb)/((fedex_mar+dhl_mar+bluedart_mar)-(fedex_feb+dhl_feb+bluedart_feb))*100 as numeric),2) dhl_returned_change_contribution_percentage,
	round(cast((bluedart_mar-bluedart_feb)/((fedex_mar+dhl_mar+bluedart_mar)-(fedex_feb+dhl_feb+bluedart_feb))*100 as numeric),2) bluedart_returned_change_contribution_percentage
from(
	select
		order_month,
		fedex fedex_feb,
		dhl dhl_feb,
		bluedart bluedart_feb,
		lead(fedex,1) over(order by order_month)fedex_mar,
		lead(dhl,1) over(order by order_month)dhl_mar,
		lead(bluedart,1) over(order by order_month)bluedart_mar
	from(
		select
			order_month,
			fedex,
			dhl,
			bluedart
		from(
			select
				to_char(order_date,'YYYY-MM') order_month,
				case when order_status = 'Completed' or order_status = 'Inprogress' then 1
					 else 0 end as success_tag,
				cast(sum(case when shipping_providers ='fedex' then order_sales else 0 end) as numeric) fedex,
				cast(sum(case when shipping_providers ='dhl' then order_sales else 0 end) as numeric) dhl,
				cast(sum(case when shipping_providers ='bluedart' then order_sales else 0 end) as numeric) bluedart
			from order_shipping_in_feb_and_mar
			group by
				success_tag,
				order_month
			order by success_tag desc,order_month 
		)t1
		where success_tag =0
	)t2
)t3
where order_month = '2024-02'

-- Cancelled rate analysis

select
	order_month,
	cancelled_sales_count,
	total_sales_count,
	round(cancelled_sales_count/total_sales_count,2) canccel_rate
from(
	select 
		to_char(order_date,'YYYY-MM') order_month,
		cast(sum(case when order_status = 'Cancelled' then 1 else 0 end) as numeric) cancelled_sales_count,
		cast(count(order_id) as numeric) total_sales_count
	from orders
	where to_char(order_date,'YYYY-MM') between '2023-08' and '2024-08'
	group by order_month
	order by order_month desc
)t1



