create database miniprojectdbms2
use miniprojectdbms2;

-- 1.	Join all the tables and create a new table called combined_table.
-- (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

select * from combinedtable;

-- 2.	Find the top 3 customers who have the maximum number of orders

select * from market_fact;

select Cust_id,Prod_id,Order_Quantity,dense_rank() over( partition by Cust_id order by Order_Quantity desc) as HighWeightageCustomers
from market_fact;

with top3 as 
(select Cust_id,Order_Quantity,dense_rank() over( order by Order_Quantity desc) as HighWeightageCustomers
from market_fact )
select Cust_id,Order_Quantity,HighWeightageCustomers
from top3
where HighWeightageCustomers in (1,2,3);

-- 3.	Create a new column DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.

select o.Order_ID,o.Order_Date,s.Ship_Date,datediff(Ship_Date,Order_Date) as datedifference
from orders_dimen as o 
inner join shipping_dimen as s on o.Order_ID = s.Order_ID;

-- 4. 	Find the customer whose order took the maximum time to get delivered.

with MAXIMUMDELIVERYTIME AS(
select c.Customer_Name,o.Order_ID,o.Order_Date,s.Ship_Date,datediff(Ship_Date,Order_Date) as datedifference
from orders_dimen as o 
inner join shipping_dimen as s on o.Order_ID = s.Order_ID
inner join market_fact as mf on mf.Ship_id =  s.Ship_id
inner join cust_dimen as c on c.Cust_id = mf.Cust_id)

select Customer_Name,Order_ID,Order_Date,Ship_Date,datediff(Ship_Date,Order_Date) as datedifference,dense_rank() over ( order by datedifference desc ) as denserank
from MAXIMUMDELIVERYTIME
limit 1;


-- 5.Retrieve total sales made by each product from the data (use Windows function)


select prod_id,sales , row_number() over ( partition by Prod_id order by sales) as total
from market_fact
group by Prod_id;


-- 6.Retrieve total profit made from each product from the data (use windows function)

select prod_id,sales , row_number() over ( partition by Prod_id order by Profit) as total
from market_fact
group by Prod_id;
group by Prod_id;

-- 7.Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

select distinct cd.Customer_Name,count(cd.Cust_id),od.order_date
from cust_dimen as cd 
inner join  market_fact as mf on mf.Cust_id = cd.Cust_id
inner join orders_dimen as od on od.Ord_id = mf.Ord_id
where year(order_date) = 2011 and month(order_date) = 01 and cd.Customer_Name in (select distinct cd.Customer_Name
from cust_dimen as cd 
inner join  market_fact as mf on mf.Cust_id = cd.Cust_id
inner join orders_dimen as od on od.Ord_id = mf.Ord_id
where year(order_date) = 2011 and month(order_date) != 01 )
group by Customer_Name;

-- 8.Retrieve month-by-month customer retention rate since the start of the business.(using views)

create view retentionview as (

with retention as (
select cd.Cust_id,cd.Customer_Name,o.order_date ,year(order_date) as years,month(order_date) as months
from cust_dimen as cd 
inner join market_fact as mf on mf.Cust_id = cd.Cust_id
inner join orders_dimen as o on o.Ord_id = mf.Ord_id
group by years,months
order by years,months)

select Cust_id,Customer_Name,order_date ,year(order_date) as years,month(order_date) as months,dense_rank() over( partition by Cust_id,years order by  months ) as denserank
from retention ;