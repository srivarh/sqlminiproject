select count(*) from retailsales ;
select * from retailsales;
---step 1 : data cleaning---
select * from retailsales
where transactions_id is null;

select * from retailsales
where price_per_unit is null;

 select * from retailsales 
where 
transactions_id is null
or 
sale_date is null
or sale_time is null
or
gender is null 
or category is null
or quantiy is null 
or cogs is null

or total_sale is null ;

delete from retailsales
where 
transactions_id is null
or 
sale_date is null
or sale_time is null
or
gender is null 
or category is null
or quantiy is null 
or cogs is null

or total_sale is null ;
select * from retailsales
select count(*) from retailsales
-----------step 2 : data exploration---------------
--1. how many sales we have 
select count(*) from retailsales
--how many customers--
select count (distinct customer_id) as no_of_customers from retailsales
--no of category
select distinct category from retailsales 

-----solving bussiness problems----
--Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
select * from retailsales 
where sale_date ='2022-11-05';
--Write a SQL query to retrieve all transactions where the category 
--is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022,
select * from retailsales
where category = 'Clothing'
and to_char(sale_date ,'YYYY-MM') = '2022-11'
and quantiy >= 4
--Write a SQL query to calculate the total sales (total_sale) for each category
select category ,sum(total_sale) as totalsales 
from retailsales
group by category 
order by totalsales desc;
--Write a SQL query to find the average age of customers who purchased 
--items from the 'Beauty' category.
select round(avg(age))as average_age from retailsales
where category ='Beauty';
-- Write a SQL query to find all transactions 
--where the total_sale is greater than 1000.
select  transactions_id from retailsales 
where total_sale>1000; 
--Write a SQL query to find the total number of transactions (transaction_id)
--made by each gender in each category
select category,gender,count(transactions_id) as total_count 
from retailsales 
group by category,gender
order by category ;
---Write a SQL query to calculate the average sale for each month.
--Find out best selling month in each year.
WITH monthly_avg_sales AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retailsales
    GROUP BY 1, 2
)

SELECT 
    year,
    month,
    avg_sale
FROM monthly_avg_sales
WHERE rank = 1;

--Write a SQL query to find the top 5 customers
--based on the highest total sales 
select customer_id, sum(total_sale) as totalsales
from retailsales
group by customer_id 
order by totalsales desc 
limit 5
--Write a SQL query to find the number of unique 
--customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as countunique
FROM retailsales
GROUP BY category
order by countunique desc
--- Write a SQL query to create each shift and number of orders (Example Morning <12, 
--Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT 
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retailsales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
order by total_orders desc 
----For each sale_date, calculate the total revenue and total profit.

SELECT 
    sale_date,
    SUM(total_sale) AS total_revenue,
    SUM(total_sale - cogs) AS total_profit
FROM 
    retailsales
GROUP BY 
    sale_date
ORDER BY 
    sale_date desc
	limit 10
--Divide customers into age groups 
--(<20, 20–40, 41–60, 60+) and find the total quantity sold in each group.
SELECT
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 40 THEN '20-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    SUM(quantiy) AS total_quantity_sold
FROM 
     retailsales
GROUP BY 
    age_group
ORDER BY
    age_group;
---7-Day Rolling Sales
--Compute a rolling 7-day window of total sales (sorted by sale_date).

SELECT
 sale_date,total_sale,
    SUM(total_sale) OVER (
        ORDER BY sale_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7_day_sales
FROM 
    retailsales
ORDER BY
    sale_date;
----Compare total sales on weekdays vs weekends.

SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM sale_date) IN (1, 2, 3, 4, 5) THEN 'Weekday'
        ELSE 'Weekend'
    END AS day_type,
    SUM(total_sale) AS total_sales
FROM 
    retailsales
GROUP BY 
    day_type;

	
