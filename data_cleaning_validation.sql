create database sql_project1;
use sql_project1;

-- UNDERSTANDING THE DATA --

select count(*) as total_records
from retail_sales_raw;

describe retail_sales_raw;

select * from
retail_sales_raw
limit 10;

show columns from retail_sales_raw;

show create table retail_sales_raw;

ALTER TABLE retail_sales_raw
RENAME COLUMN `ï»¿transactions_id` TO transactions_id;

ALTER TABLE retail_sales_raw
RENAME COLUMN quantiy TO quantity;

-- CHECKING MISSING VALUES -- 

SELECT
    SUM(CASE WHEN transactions_id IS NULL OR TRIM(transactions_id) = '' THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN sale_date IS NULL OR TRIM(sale_date) = '' THEN 1 ELSE 0 END) AS missing_sale_date,
    SUM(CASE WHEN sale_time IS NULL OR TRIM(sale_time) = '' THEN 1 ELSE 0 END) AS missing_sale_time,
    SUM(CASE WHEN customer_id IS NULL OR TRIM(customer_id) = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN gender IS NULL OR TRIM(gender) = '' THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN age IS NULL OR TRIM(age) = '' THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN category IS NULL OR TRIM(category) = '' THEN 1 ELSE 0 END) AS missing_category,
    SUM(CASE WHEN price_per_unit IS NULL OR TRIM(price_per_unit) = '' THEN 1 ELSE 0 END) AS missing_price,
    SUM(CASE WHEN quantity IS NULL OR TRIM(quantity) = '' THEN 1 ELSE 0 END) AS missing_quantity,
    SUM(CASE WHEN cogs IS NULL OR TRIM(cogs) = '' THEN 1 ELSE 0 END) AS missing_cogs,
    SUM(CASE WHEN total_sale IS NULL OR TRIM(total_sale) = '' THEN 1 ELSE 0 END) AS missing_total_sale
FROM retail_sales_raw;

-- identify the missing records -- 

SELECT *
FROM retail_sales_raw
WHERE
nullif(trim(price_per_unit),'') IS NULL
   OR nullif(trim(quantity),'') IS NULL
   OR nullif(trim(cogs),'') IS NULL
   OR nullif(trim(total_sale),'') IS NULL;
   
-- create cleaned table -- 

create table retail_sales_clean as
select * from
	retail_sales_raw
    where
    nullif(trim(price_per_unit),'') IS not NULL
   and nullif(trim(quantity),'') IS not NULL
   and nullif(trim(cogs),'') IS not NULL
   and nullif(trim(total_sale),'') IS not NULL;
   
select count(*) from retail_sales_clean;
select * from retail_sales_clean;

-- Duplicate checking --

select
	transactions_id,
    count(*) as duplicate_count
    from retail_sales_clean
    group by transactions_id
    having duplicate_count > 1;
    
-- check inconsistencies -- 

select
	gender,
    count(*) as total_count
    from retail_sales_clean
    group by gender;
    
-- Rename gender category  --

update retail_sales_clean
set gender = case
				when gender = 'M' then 'Male'
                when gender = 'F' then 'Female'
                else gender
			end
where gender in ('M','F');

select
	category,
    count(*) as total_count
    from retail_sales_clean
    group by category;
    
-- age validation --

SELECT
    MIN(CAST(age AS UNSIGNED)) AS minimum_age,
    MAX(CAST(age AS UNSIGNED)) AS maximum_age
FROM retail_sales_clean;

select * from
retail_sales_clean
where cast(age as unsigned) < 18 or
cast(age as unsigned) > 100;

-- validation of numeric columns --

select
	min(cast(price_per_unit as decimal(10,2))) as min_price,
    max(cast(price_per_unit as decimal(10,2))) as max_price
    from retail_sales_clean;
    
select * from
retail_sales_clean
where cast(price_per_unit as decimal(10,2)) <= 0;

select
	min(cast(quantity as decimal(10,2))) as min_qty,
    max(cast(quantity as decimal(10,2))) as max_qty
    from retail_sales_clean;
    
select * from 
retail_sales_clean
where cast(quantity as decimal(10,2)) <= 0;

SELECT
    MIN(CAST(cogs AS DECIMAL(10,2))) AS min_cogs,
    MAX(CAST(cogs AS DECIMAL(10,2))) AS max_cogs
FROM retail_sales_clean;

SELECT *
FROM retail_sales_clean
WHERE CAST(cogs AS DECIMAL(10,2)) <= 0;

SELECT
    MIN(CAST(total_sale AS DECIMAL(10,2))) AS min_sale,
    MAX(CAST(total_sale AS DECIMAL(10,2))) AS max_sale
FROM retail_sales_clean;

SELECT *
FROM retail_sales_clean
WHERE CAST(total_sale AS DECIMAL(10,2)) <= 0;

-- column cross validation -- ( <> & != are both same )

select * from
retail_sales_clean
where
cast(total_sale as decimal(10,2)) != (cast(quantity as unsigned) * cast(price_per_unit as decimal(10,2)));

-- date & time validation --

select
sale_date,
sale_time
from retail_sales_clean;

SELECT DISTINCT sale_date
FROM retail_sales_clean
ORDER BY sale_date
LIMIT 10;

select
count(*) as total_count,
count(str_to_date(sale_date, '%d-%m-%Y')) as valid_date
from retail_sales_clean;

select distinct
sale_time from retail_sales_clean limit 10;

SELECT
    MIN(CAST(sale_time AS TIME)) AS earliest_time,
    MAX(CAST(sale_time AS TIME)) AS latest_time
FROM retail_sales_clean;

select * from
retail_sales_clean
where cast(sale_time as time) is null;

-- Final cleaned table creation --

CREATE TABLE retail_sales_final AS
SELECT
    CAST(transactions_id AS UNSIGNED) AS transactions_id,
    STR_TO_DATE(sale_date, '%d-%m-%Y') AS sale_date,
    CAST(sale_time AS TIME) AS sale_time,
    CAST(customer_id AS UNSIGNED) AS customer_id,
    gender,
    CAST(age AS UNSIGNED) AS age,
    category,
    CAST(price_per_unit AS DECIMAL(10,2)) AS price_per_unit,
    CAST(quantity AS UNSIGNED) AS quantity,
    CAST(cogs AS DECIMAL(10,2)) AS cogs,
    CAST(total_sale AS DECIMAL(10,2)) AS total_sale
FROM retail_sales_clean;

describe retail_sales_final;

select count(*) from retail_sales_final;