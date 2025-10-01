ALTER TABLE sample_superstore MODIFY order_id VARCHAR(20);

ALTER TABLE sample_superstore MODIFY ship_mode VARCHAR(20);

ALTER TABLE sample_superstore MODIFY order_date DATE;

ALTER TABLE sample_superstore MODIFY ship_date DATE;

ALTER TABLE sample_superstore MODIFY customer_name VARCHAR(30);

ALTER TABLE sample_superstore MODIFY customer_id VARCHAR(10);

ALTER TABLE sample_superstore MODIFY segment VARCHAR(20);

ALTER TABLE sample_superstore MODIFY country VARCHAR(20);

ALTER TABLE sample_superstore MODIFY city VARCHAR(20);

ALTER TABLE sample_superstore MODIFY state VARCHAR(20);

ALTER TABLE sample_superstore MODIFY postal_code VARCHAR(10);

ALTER TABLE sample_superstore MODIFY region VARCHAR(10);

ALTER TABLE sample_superstore MODIFY product_id VARCHAR(20);

ALTER TABLE sample_superstore MODIFY category VARCHAR(20);

ALTER TABLE sample_superstore MODIFY sub_category VARCHAR(20);

ALTER TABLE sample_superstore MODIFY product_name VARCHAR(130);

ALTER TABLE sample_superstore MODIFY sales DECIMAL(10,2);

ALTER TABLE sample_superstore MODIFY quantity DECIMAL(5,0);

ALTER TABLE sample_superstore MODIFY discount DECIMAL(5,2);

ALTER TABLE sample_superstore MODIFY profit DECIMAL(10,2);

select sum(profit) as total_profit from sample_superstore
order by 1;

select profit from sample_superstore
order by profit desc;

select * from sample_superstore
limit 10;

select count(*) from sample_superstore; -- checking the total number of records imported

select * from sample_superstore limit 6; -- checking the dataset

-- Updating the schema to add an "order_year" column by extracting the year from order_date for easier filtering by year. 
ALTER TABLE sample_superstore
ADD COLUMN order_year INT AFTER order_id;

UPDATE sample_superstore
SET order_year = YEAR(order_date);

-- What are the yearly total sales and profit?
select order_year, sum(sales) as total_sales, sum(profit) as total_profit
from sample_superstore
group by 1
order by 1;

 -- What is the total sales, average sales and percent of total sales for each category?
select category, sum(sales) as total_sales, avg(sales) as average_sales,
sum(sales)/(select sum(sales) from sample_superstore)*100 as percentage_of_total
from sample_superstore
group by 1
order by 2 desc;

 -- What are the sales by category?
select category, sum(sales) as total_sales
from sample_superstore
group by 1
order by 2 desc;

 -- What are the sales by sub_category?
select sub_category, sum(sales) as total_sales
from sample_superstore
group by 1
order by 2 desc;

 -- What are the sales by region?
select region, sum(sales) as total_sales
from sample_superstore
group by 1
order by 2 desc;

 -- What are the sales by state?
select state, sum(sales) as total_sales
from sample_superstore
group by 1
order by 2 desc;

-- Which subcategories have the highest and lowest total sales overall?
(select sub_category, sum(sales) as total_sales
from sample_superstore
group by 1
order by 2 desc
limit 1) 
union
(select sub_category, sum(sales) as total_sales
from sample_superstore
group by 1
order by 2 asc
limit 1); 

-- -- Which subcategories have the highest and lowest total profit overall?
(select sub_category, sum(profit) as total_profit
from sample_superstore
group by 1
order by 2 desc
limit 1) 
union
(select sub_category, sum(profit) as total_profit
from sample_superstore
group by 1
order by 2 asc
limit 1); 

 -- Which region generates the highest sales and profit?
select region, sum(sales) as total_sales, sum(profit) as total_profit
from sample_superstore
group by 1
order by 3 desc;

 -- What are the profit margins by region?
select region, round((sum(profit)/sum(sales))*100,2) as profit_margin
from sample_superstore
group by 1
order by 2 desc;

 -- What are the top and bottom states total sales and profits with their profit margins?
(select state, sum(sales) as total_sales, sum(profit) as total_profit, round((sum(profit)/sum(sales))*100,2) as profit_margin
from sample_superstore
group by 1
order by 2 desc
limit 1)
union
(select state, sum(sales) as total_sales, sum(profit) as total_profit, round((sum(profit)/sum(sales))*100,2) as profit_margin
from sample_superstore
group by 1
order by 2 asc
limit 1);

 -- What are the top 10 cities total sales and profits with their profit margins?
select city, sum(sales) as total_sales, sum(profit) as total_profit, round((sum(profit)/sum(sales))*100,2) as profit_margin
from sample_superstore
group by 1
order by 2 desc
limit 10;

 -- What is discount vs average sales?
select discount, round(avg(sales),2) as avg_sales 
from sample_superstore
group by 1
order by 1;

 -- What is the total discount per product category?
select category, sum(discount) as total_discount
from sample_superstore
group by 1
order by 2 desc;

  -- What are the most discounted subcategories(product type)?
select category, sub_category, sum(discount) as total_discount
from sample_superstore
group by 1, 2
order by 3 desc;

  -- What is the highest total sales and profit per category in each region?
select region, category, sum(sales) as total_sales, sum(profit) as total_profit
from sample_superstore
group by 1, 2
order by 4 desc;

  -- What is the highest total sales and profit per category in each state?
select state, category, sum(sales) as total_sales, sum(profit) as total_profit
from sample_superstore
group by 1, 2
order by 4 desc;

 -- What are the top 15 most profitable products?
select product_name, sum(sales) as total_sales, sum(profit) as total_profit
from sample_superstore
group by 1
order by 3 desc
limit 15;

 -- Which segment makes the most of our sales and profit?
select segment, sum(sales) as total_sales, sum(profit) as total_profit
from sample_superstore
group by 1
order by 2 desc;

-- Top 3 spending customers
SELECT *
FROM 
	(SELECT customer_id, customer_name, SUM(sales) AS total_spend,
		DENSE_RANK() OVER(ORDER BY SUM(sales) DESC) AS top_rank_customers
	FROM sample_superstore
	GROUP BY 1, 2) AS t1
WHERE top_rank_customers <= 3; 

-- How many customers do we have (unique customer IDs) in total?
select count(distinct customer_id) as total_customers
from sample_superstore;

-- How many customers do we have per region and state?
SELECT region, COUNT(DISTINCT customer_id) AS total_customers
FROM sample_superstore
GROUP BY region
ORDER BY total_customers DESC;

-- Top 15 customers that generated the most sales compared to total profits.
SELECT customer_id, 
SUM(sales) AS total_sales,
SUM(profit) AS total_profit
FROM sample_superstore
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 15;
