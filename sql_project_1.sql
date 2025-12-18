--CREATING TABLE
drop table if exists retail_prices;
CREATE TABLE retail_prices(
transactions_id	integer primary key,
sale_date	date,
sale_time	time,
customer_id	integer,
gender	varchar(10),
age	integer,
category varchar(15),	
quantiy	integer,
price_per_unit	float,
cogs	float,
total_sale float
);
select * from retail_prices;
select * from retail_prices where  
transactions_id is null
              or
sale_date is null
               or
sale_time is null
               or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;
-- DATA CLEANING:
--Removing all the rows with null values in any one of the columns
delete from retail_prices where
transactions_id is null
              or
sale_date is null
               or
sale_time is null
               or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;
select * from retail_prices;
--DATA EXPLORATION
--how many unique customers,sales,category we have
select count(*) as total_sales  from retail_prices;
select count(distinct(customer_id)) from retail_prices;
select distinct(category) from retail_prices;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1- Ans
select * from retail_prices where sale_date='2022-11-05';

-- Q.2- Ans
select transactions_id,category,quantiy,sale_date from retail_prices where 
category='Clothing' and quantiy>=4 and to_char(sale_date,'YYYY-MM')='2022-11';

-- Q.3- Ans
select sum(total_sale) as price,category from retail_prices group by category;

-- Q.4- Ans
select avg(age) from retail_prices where category ='Beauty';

-- Q.5- Ans
select transactions_id,total_sale from retail_prices where total_sale>1000;

-- Q.6- Ans
select count(transactions_id),gender,category from retail_prices group by gender,category order by category;

-- Q.7- Ans

select year,month,average_sales  from
(select extract(year from sale_date) as year,extract(month from sale_date) as month,avg(total_sale) as average_sales,
rank()over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_prices group by 1,2	 /*order by 1,3 desc;*/)
as t1
where rank=1;

-- Q.8- Ans
select sum(total_sale),customer_id from retail_prices group by customer_id order by sum(total_sale) desc limit 5;

-- Q.9- Ans
select count(distinct customer_id),category from retail_prices group by category;

-- Q.10- Ans
with hourly_sale as(
select *,case
     when extract(hour from sale_time)<12 then 'morning'
	 when extract(hour from sale_time) between 12 and 17 then 'afternoon'
	 else 'evening'
	 end as shift from retail_prices)
	 select shift,count(transactions_id) as count_of_sales from hourly_sale group by shift;

--End of project

