select 
	region, 
	product_name,
	distributor_id, 
	total_units_sold
from
(
select 
	region, 
	product_name, 
	distributor_id, 
	total_units_sold, 
	rank() over (partition by region order by [total_units_sold] desc, [product_name]) as 'rank_'
from
(
select 
	o.region, 
	ap.product_name, 
	ap.distributor_id, 
	sum(o.no_units) as total_units_sold
from 
	orders o 
left join 
	all_products ap 
on 
	o.product_id = ap.product_id
where 
	o.date > '2017-10-00'
group by 
	o.region, 
	ap.product_name
order by 
	o.region asc, 
	total_units_sold desc, 
	ap.product_name asc
)
)
where rank_ < 6;
