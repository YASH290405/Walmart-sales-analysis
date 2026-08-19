create database if not exists salesDataWalmart;
use salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	 invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
     Branch	VARCHAR(5) NOT NULL,
     City 	VARCHAR(30) NOT NULL,
     Customer_type	VARCHAR(30) NOT NULL,
     Gender	VARCHAR(10) NOT NULL,
     Product_line VARCHAR(100) NOT NULL,
     Unit_price DECIMAL(10,2) NOT NULL,	
     Quantity INT NOT NULL,
     VAT FLOAT(6,4) NOT NULL,
     Total	DECIMAL(12,4) NOT NULL,
     Date DATETIME NOT NULL,
     Time	TIME NOT NULL,
     Payment VARCHAR(15),
     cogs	Decimal(10,2),
     gross_margin_percentage float(11,9),
     gross_Income decimal(12,4),	
     rating float(2,1)
 );
 
 -- DATA WRANGLING : INSPECTION OF DATA TO CHECK FOR NULL AND MISSING VALUES
 -- SETTING NOT NULL FOR EACH FIELD HELPED IN FILTERING OUT ALL THE RECORDS WITH NULL VALUES
 
SELECT * FROM SALES;  

SELECT COUNT(*) FROM SALES;

-- ---------------- ------------------------------------------------ ------------------------------------------------------------ -----------------
-- ----------------------------------------------------------------------  FEATURE ENGINEERING  ---------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- time_of_day
SELECT time from sales;
SELECT  time,
     (CASE 
         WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
         WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
         ELSE 'Evening'
	 END ) as time_Of_the_Day
FROM sales ORDER BY time;


ALTER table SALES add column time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day=(CASE 
         WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
         WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
         ELSE 'Evening'
	 END );
   
   
-- ---------------- ------------------------------------------------ ------------------------------------------------------------ -----------------

-- day_name

select date,dayname(date) as day_Name from sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(15);
UPDATE sales SET day_name=(dayname(date));


-- month_name
ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);	
UPDATE sales SET month_name=MONTHNAME(date);
SELECT date,week(date) from sales;

-- ---------------- ------------------------------------------------ ------------------------------------------------------------ -----------------
--                                                                Buisness Questions to Answer
-- -- ---------------- ------------------------------------------------ ------------------------------------------------------------ --------------


-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- -- -----------------------------------------------------------------GENERIC QUESTION------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- UNIQUE CITIES
SELECT DISTINCT CITY FROM sales; -- 1.Nayyitaw 2.Mandalay 3.Yangon

-- How many branches a city have
SELECT DISTINCT CITY ,branch FROM sales;

-- ------------------------------------------------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------PRODUCT--------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. How many unique product line does the data have
SELECT COUNT(DISTINCT product_line) from sales;  -- ANS: 6
/*Food and beverages
Health and beauty
Sports and travel
Fashion accessories
Home and lifestyle
Electronic accessories
*/


-- 2. What is the most common payment method
SELECT payment,COUNT(payment)
from sales
GROUP BY  payment
ORDER BY COUNT(payment) desc;


-- 3. What is the most selling product line
SELECT product_line,count(product_line) as count
FROM sales
group by product_line
order by count(product_line)  desc limit 1;


-- what is the totaal revenue by month 
select monthname(date) as month,sum(total) as total_revenue
from sales 
group by monthname(date)
order by sum(total) desc;
/*
January 	116291.8680
March	    108867.1500
February	95727.3765
*/


-- what month had the largest cogs
SELECT monthname(date) ,sum(cogs) as maxcogs
from sales
group by monthname(date)
order by sum(cogs) desc;
/*
January	110754.16
March	103683.00
February	91168.93
*/


-- what product line had the largest revenue
select product_line,sum(total) as total_revenue
from sales 
group by product_line 
order by total_revenue desc;


-- what is the city with the largest revenue
select city,sum(total) as total_revenue
from sales 
group by city 
order by total_revenue desc;


-- What product line had the Largest VAT
SELECT product_line ,AVG(VAT) as AVG_VAT_in_a_productLine
from sales
GROUP BY product_line
order by AVG_VAT_in_a_productLine desc;


-- Fetch each product line and add a column to chose products line showing "Good","Bad".alter
-- Good if its greater than average sales

ALTER TABLE sales ADD COLUMN performance VARCHAR(10) AFTER rating;
select avg(rating) from sales;
UPDATE sales SET performance='Good' WHERE rating>6.9574;
UPDATE sales SET performance='Bad' WHERE rating<=6.9574;


-- which branch sold more products than average product sold
select branch,sum(quantity) as qity
from sales 
group by branch
having qity > (select avg(quantity) from sales)
order by branch;
 
 
-- what is the most product line by gender
select gender,product_line,count(product_line) as cnt
from sales
group by gender,product_line
order by cnt desc;


-- what is the average rating of each product line
select product_line,ROUND(avg(rating)) as avg_rating
from sales
group by product_line
order by avg_rating desc;


-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------- SALES ------------------------------------------------------------------ 
-- ------------------------------------------------------------------------------------------------------------------------------------------------


-- Number of sales amde in each time of the day per weekday
select 
    time_of_day,day_name,count(*) as number_of_sales 
    from sales
    group by day_name,time_of_day
    having day_name NOT IN ('sunday','saturday')
    order by number_of_sales desc;

-- which of the customer_types bring the most revenue

SELECT 
   customer_type,SUM(total) as revenue
   FROM sales
   GROUP BY customer_type
   ORDER BY revenue desc;

-- which city has the largest tax percent/VAT(Value added tax)

SELECT City,avg(vat) as largest_vat_per_city
FROM sales
GROUP BY City
ORDER BY  largest_vat_per_city DESC ;

-- which cusyomer pays the most VAT
SELECT customer_type,avg(vat) as most_vat
FROM sales
group by customer_type
order by most_vat desc;


-- -------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------- CUSTOMERS ---------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------


-- 1. How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;


-- 2. How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM sales;


-- 3. What is the most common customer type?
SELECT customer_type,count(customer_type) counts
FROM sales
GROUP BY customer_type
ORDER BY counts desc;


-- 4. Which customer type buys the most?
SELECT customer_type,count(quantity) as total_count
FROM sales
GROUP BY customer_type;


-- 5. What is the gender of most of the customers?
SELECT gender,count(*) as gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count desc;


-- 6. What is the gender distribution per branch?
SELECT gender,branch,city,count(*) as distribution_of_gender_per_branch
FROM sales
group by gender,branch,city
ORDER BY CITY;


-- 7. Which time of the day do customers give most ratings?
SELECT time_of_day,avg(rating) as number_of_ratings
FROM sales
group by time_of_day
order by number_of_ratings desc;


-- 8. Which time of the day do customers give most ratings per branch?
SELECT time_of_day,branch,avg(rating) as Rating
FROM sales
GROUP BY branch,time_of_day
ORDER BY  branch,rating desc;


-- 9. Which day for the week has the best avg ratings?
SELECT day_name,avg(rating) as avgrating
FROM sales
GROUP BY day_name
ORDER BY avgrating DESC;


-- 10. Which day of the week has the best average ratings per branch?
WITH RANKED AS(
   SELECT day_name,branch, avg(rating) as avgrating,
   rank() over(partition by branch order by avg(rating) desc
    )as rnk
   FROM sales
   GROUP BY day_name,branch
)
select day_name,branch, avgrating from  RANKED
where rnk=1
order by branch;
