use retail_sales_final;

# BUSINESS INSIGHTS 

-- CATEGORY PERFORMANCE --

SELECT
    category,
    COUNT(DISTINCT transactions_id) AS total_transactions,
    SUM(total_sale) AS total_revenue,
    AVG(price_per_unit) AS avg_selling_price,
    SUM(quantity) AS total_quantity
FROM retail_sales_final
GROUP BY category
ORDER BY total_revenue DESC;

-- MONTHLY SALES TREND --

SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    SUM(total_sale) AS total_revenue,
    COUNT(DISTINCT transactions_id) AS total_transactions,
    SUM(quantity) AS total_quantity
FROM retail_sales_final
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY month, TOTAL_REVENUE DESC;

-- CUSTOMER SPENDING PATTERN --

SELECT
    customer_id,
    COUNT(DISTINCT transactions_id) AS total_transactions,
    SUM(total_sale) AS total_spending,
    SUM(quantity) AS total_quantity
FROM retail_sales_final
GROUP BY customer_id
ORDER BY total_spending DESC
LIMIT 10;

-- CUSTOMER RETENTION ANALYSIS --

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT transactions_id) AS total_transactions
    FROM retail_sales_final
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN total_transactions > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM customer_orders
GROUP BY customer_type;

-- PROFITABILITY ANALYSIS --

SELECT
    category,
    SUM(total_sale) AS total_revenue,
    SUM(cogs) AS total_cost,
    SUM(total_sale - cogs) AS gross_profit,
    ROUND(
        SUM(total_sale - cogs) / SUM(total_sale) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales_final
GROUP BY category
ORDER BY gross_profit DESC;

-- GENDER WISE SALES PERFORMANCE -- 

SELECT
    gender,
    COUNT(DISTINCT transactions_id) AS total_transactions,
    SUM(total_sale) AS total_revenue,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(total_sale), 2) AS avg_sale_value
FROM retail_sales_final
GROUP BY gender
ORDER BY total_revenue DESC;