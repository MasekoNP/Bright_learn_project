-----------------------------------------------------------------------------------------
-- 1. I want to see the bright coffee shop sales table exploryting each column
SELECT *
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

-- Number of rows were 149116
-- Number of sales were 149116, meaning no duplicates
SELECT 
      COUNT(*) AS number_of_rows,
      COUNT(DISTINCT transaction_id) AS number_of_sales
FROM bright_learn.default.bright_coffee_shop_sales_analysis;


-- Checking for NULL values
-- There are no NULL values
SELECT *
FROM bright_learn.default.bright_coffee_shop_sales_analysis
WHERE 
      transaction_id IS NULL 
      OR transaction_date IS NULL 
      OR transaction_qty IS NULL 
      OR store_id IS NULL 
      OR store_location IS NULL 
      OR product_id IS NULL 
      OR unit_price IS NULL 
      OR product_category IS NULL 
      OR product_type IS NULL 
      OR product_detail IS NULL;

----------------------------------------------------------------------------
-- 2. Checking the Date Range
-- They started collecting the data 2023-01-01
-- They last collected the data 2023-06-30
-- The duration of the data is 6 months

SELECT MIN(transaction_date) AS start_date,
      MAX(transaction_date) AS end_date
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

----------------------------------------------------------------------------
-- 3. Checking the names of the different stores
-- There are 3 stores, Lower Manhattan, Hell's Kitchen, Astoria
SELECT DISTINCT store_location
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

SELECT COUNT(DISTINCT store_id) AS number_of_stores
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

----------------------------------------------------------------------------
-- 4. Checking products sold at our stores 
--There are 9 product categories
SELECT DISTINCT product_category
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

-- There are 80 product details
SELECT DISTINCT product_detail
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

-- There are 29 product types
SELECT DISTINCT product_type
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

-- This tells us which product name within a certain category
SELECT DISTINCT product_category AS category,
                product_detail AS product_name
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

----------------------------------------------------------------------------
-- 5. Checking product prices
-- The cheapest price was 0.8 and the expensive price was 45
SELECT MIN(unit_price) As cheapest_price,
       MAX(unit_price) As expensive_price
FROM bright_learn.default.bright_coffee_shop_sales_analysis;

-- 6. Checking the highest and lowest money spent
-- The minimum amount spent is 0.8
-- The maximum amount spent is 360
SELECT MIN(transaction_qty*unit_price) AS Minimum_spent,
      MAX(transaction_qty*unit_price) AS Maximum_spent
FROM bright_learn.default.bright_coffee_shop_sales_analysis;
----------------------------------------------------------------------------
-- 7. Adding the date functions 
SELECT transaction_id,
      transaction_date,
      Dayname(transaction_date) AS Day_name,
      Monthname(transaction_date) AS Month_name,
      transaction_qty*unit_price AS revenue_per_transaction
FROM bright_learn.default.bright_coffee_shop_sales_analysis;
----------------------------------------------------------------------------
-- Adding everything up ----------------------------------------------------
SELECT 
-- Dates
      transaction_date,
      Dayname(transaction_date) AS Day_name,
        CASE 
            WHEN Dayname(transaction_date) IN ('Sat', 'Sun') THEN 'Weekend'
            ELSE 'Weekday'
      END AS day_classification,
      
      Monthname(transaction_date) AS Month_name,
      Dayofmonth(transaction_date) AS day_of_month,
      --date_format(transaction_time, 'HH:MM:SS') AS purchase_time,

-- Adding time_buckets
      CASE 
            WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '00:00:00' AND '11:59:59' THEN '1. Morning'
            WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '1200:00' AND '16:59:59' THEN '2. Afternoon'
            WHEN date_format(transaction_time, 'HH:MM:SS') BETWEEN '17:00:00' AND '23:59:59' THEN '3. Evening'
      END AS time_buckets,
 
-- Counts of IDs
      count(DISTINCT transaction_id) AS Number_of_sales,
      count(DISTINCT product_id) AS Number_of_products,
      count(DISTINCT store_id) AS Number_of_stores,

-- Revenue
      SUM(transaction_qty*unit_price) AS revenue_per_day,

-- Adding Spend buckets
      CASE 
            WHEN SUM(transaction_qty*unit_price) <= 50 THEN '01: low Spend'
            WHEN SUM(transaction_qty*unit_price) BETWEEN 51 AND 100 THEN '02: Med Spend'
            ELSE '03: High Spend'
      END AS Spend_bucket,

-- Categorical columns 
      store_location,
      product_category,
      product_detail

FROM bright_learn.default.bright_coffee_shop_sales_analysis
GROUP BY transaction_date,
         store_location,
         product_category,
         --purchase_time,
         time_buckets,
         product_detail,
         Day_name,
         Month_name,
         day_classification,
         day_of_month;

----------------------------------------------------------------------------
