-- MENU EDA

-- To view the menu_items table 
select * from menu_items;

-- number of items on the menu
select count(menu_item_id) from menu_items;

-- the least and most expensive items on the menu
(select item_name,price,"Most Expensive Item" as price_category from menu_items
order by price desc
limit 1 )
union
(select item_name,price,"Least Expensive Item" as price_category from menu_items
order by price asc
limit 1 );

-- no of Italian dishes are on the menu and the least and most expensive Italian dishes on the menu?
Select count(menu_item_id) from menu_items
where category = "Italian";

(select item_name,price,"Least Expensive Item" as price_category from menu_items
where category="Italian"
order by price asc
limit 1)
union
(select item_name,price,"Most Expensive Item" as price_category from menu_items
where category="Italian"
order by price desc
limit 1);

-- no. of dishes in each category and average dish price within each category
select category,count(menu_item_id) as dish_count ,avg(price) as average_dish_price from menu_items
group by category;








-- ORDERS EDA

-- to view the order_details table 
-- the date range of the table
select * from order_details;
select min(order_date) as First_Order_Date,max(order_date) as Last_Order_Date from order_details;

-- no. of orders made within the date range
select count(distinct(order_id)) as Total_orders_made from order_details
where order_date between (select min(order_date) from order_details) and (select max(order_date) from order_details);

-- no. of  items ordered within the date range
select count(order_details_id) as Total_items_ordered from order_details
where order_date between (select min(order_date) from order_details) and (select max(order_date) from order_details);

-- orders that had the most number of items
select order_id, count(order_details_id) as Total_items_ordered from order_details
group by order_id
order by Total_items_ordered desc;

-- no. of orders that had more than 12 items
select count(order_id) from (select order_id, count(item_id) as Total_items_ordered from order_details
group by order_id
having Total_items_ordered > 12) as num_orders
;



-- CUSTOMER BEHAVIOUR ANALYSIS

-- Combining the menu_items and order_details tables into a single table
Select * from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id;

--  the least and most ordered items and the categories they were in
(select "Most_ordered_item" as order_count_category, item_name,category ,count(item_name) as total_orders from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
group by item_name ,category
order by total_orders desc
limit 1)

union

(select "Least_ordered_item" as order_count_category, item_name,category,count(item_name) as total_orders from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
where item_name is not null
group by item_name, category 
order by total_orders asc
limit 1);


--  the top 5 orders that spent the most money
Select order_id,sum(price) as total_spend
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
group by order_id
order by total_spend desc
limit 5;


-- View the details of the highest spend order. Which specific items were purchased?

SELECT *
FROM order_details od
left join menu_items mi ON od.item_id = mi.menu_item_id
WHERE od.order_id = 
(Select order_id
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
group by order_id
order by sum(price) desc
limit 1);

-- details of the top 5 highest spend orders
select order_id,count(item_id) as num_orders,category
from order_details od
left join menu_items mi on od.item_id = mi.menu_item_id
where order_id in (440,2075,1957,330,2675)
group by order_id,category
;