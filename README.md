# Retail Sales Analysis Using MySQL

## Project Overview

This project focuses on analyzing retail sales data using MySQL to identify sales trends, customer purchasing patterns, product category performance, and profitability.

The project involves data cleaning, data validation, SQL-based business analysis, and generating actionable business insights.

## Business Objectives

- Analyze overall retail sales performance.
- Identify top-performing product categories.
- Understand monthly and seasonal sales trends.
- Analyze customer spending and purchase frequency.
- Evaluate category-wise gross profit and profit margins.
- Identify opportunities to improve business performance.

## Dataset Information

- **Dataset:** Retail Sales Analysis
- **Original Records:** 2,000
- **Records After Cleaning:** 1,997
- **Time Period:** 2022–2023
- **Number of Product Categories:** 3
- **Unique Customers:** 155

### Dataset Columns

`transactions_id`, `sale_date`, `sale_time`, `customer_id`, `gender`, `age`, `category`, `price_per_unit`, `quantity`, `cogs`, `total_sale`.

## Tools & Technologies

- MySQL
- MySQL Workbench
- SQL

## Data Cleaning & Validation

The following activities were performed:

- Inspected the raw dataset.
- Identified and handled missing values.
- Checked duplicate transaction IDs.
- Standardized inconsistent gender values.
- Validated age and numeric columns.
- Performed cross-column validation.
- Validated date and time values.
- Converted columns into appropriate data types.
- Created a final cleaned table for analysis.

Three incomplete records were excluded from the cleaned dataset while preserving the original raw table.

## SQL Analysis

A total of 30 business questions were explored using SQL.

Key concepts used:

- Aggregate functions
- GROUP BY and HAVING
- CASE WHEN
- Subqueries
- Common Table Expressions (CTEs)
- Window functions
- DENSE_RANK()
- LAG()
- Date and time functions

## Key Business Insights

### 1. Category Performance
- Electronics generated the highest revenue of ₹3,13,810.
- Clothing recorded the highest transaction count and quantity sold.
- Beauty had the highest average selling price.

### 2. Monthly Sales Trends
- December 2022 recorded the highest monthly revenue of ₹72,880.
- February 2022 recorded the lowest monthly revenue of ₹16,110.
- Revenue increased by approximately 1.34% in 2023 compared with 2022.

### 3. Customer Spending
- Customer 3 was the highest-spending customer, generating ₹38,440.
- The top five customers contributed approximately 16.28% of total revenue.

### 4. Customer Retention
- All 155 customers in the dataset made multiple transactions.
- No one-time customers were identified.

### 5. Category Profitability
- Clothing generated the highest gross profit of ₹2,46,679.50.
- Beauty recorded the highest gross profit margin of 79.71%.
- Electronics had the lowest gross profit margin of 78.60%.

### 6. Gender-wise Performance
- Male customers generated slightly higher revenue.
- Female customers recorded more transactions and purchased more units.
- Male customers had a higher average sale value.

## Business Recommendations

- Review Electronics pricing and supplier costs to improve profitability.
- Use cross-selling and product bundling opportunities to increase Clothing revenue.
- Prepare inventory and promotional campaigns ahead of the September–December sales period.
- Introduce loyalty programs for high-value customers.
- Monitor repeat-purchase frequency to identify declining customer activity.
- Test promotional strategies across customer groups and evaluate their results.

## Project Files

| File | Description |
|---|---|
| `data_cleaning_validation.sql` | Data cleaning and validation queries |
| `business_analysis.sql` | 30 SQL business analysis questions |
| `key_findings_analysis (PROJECT-1).sql` | Queries used for key findings |
| `business_insights.md` | Detailed business insights |
| `business_recommendations.md` | Business recommendations |

## Conclusion

This project demonstrates the use of MySQL for data cleaning, validation, business analysis, and extracting meaningful insights from retail sales data.

It helped develop practical SQL skills and understand how data analysis can support business decision-making.

---

**Project Domain:** Retail / Data Analytics  
**Technology:** MySQL
