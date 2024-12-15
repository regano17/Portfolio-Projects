-- 1. Comhbine the menu_items and order_details tables into a single table.
select *
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id;

-- 2. What were the least and most ordered items? What categories were they in?
select item_name, category, count(order_details_id) as num_purchases
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
group by item_name, category
order by num_purchases desc;

select item_name, category, count(order_details_id) as num_purchases
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
group by item_name, category
order by num_purchases;

-- 3. What were the top 5 orders that spent the most money?
select order_id, sum(price) as order_total
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
group by order_id
order by order_total desc
limit 5;

-- 4. View the details of the highest spend order. What insights can you gather from the data?
select category, count(item_name)
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
where order_id = '440'
group by category
order by count(item_name) desc;

-- 5. View the details of the top highest spend orders. What insights can you gather from the data?
select order_id, category, count(item_name)
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
where order_id in (440, 2075, 1957, 330, 2675)
group by order_id, category
order by 1;




