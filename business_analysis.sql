USE sql_project1;

select * from retail_sales_raw limit 10;
select * from retail_sales_clean limit 10;
select * from retail_sales_final limit 10;

#Q1. A retail manager wants to understand the overall sales performance of the business.

select
	count(distinct transactions_id) as total_transaction,
    sum(total_sale) as total_revenue,
    avg(total_sale) as avg_sale_value,
    sum(quantity) as total_quantity
    from retail_sales_final;
    
#Q2. The retail manager wants to understand how much revenue each gender contributes to total sales.

select
	gender,
	count(distinct transactions_id) as total_transaction,
    sum(total_sale) as total_revenue,
    avg(total_sale) as avg_sale_value,
    sum(quantity) as total_quantity
    from retail_sales_final
    group by gender;
    
#Q3. The retail manager wants to identify which product categories generate the most revenue.

select
	category,
	count(distinct transactions_id) as total_transaction,
    sum(total_sale) as total_revenue,
    avg(price_per_unit) as avg_selling_price,
    sum(quantity) as total_quantity
    from retail_sales_final
    group by category
    order by total_revenue desc;
    
#Q4. The manager wants to understand how sales revenue changes month by month.

select
	date_format(sale_date, '%Y-%m') as month,
    count(distinct transactions_id) as total_transaction,
    sum(total_sale) as total_revenue,
    sum(quantity) as total_quantity
    from retail_sales_final
    group by date_format(sale_date, '%Y-%m')
    order by month;
    
#Q5. The manager wants to identify the category with the highest number of units sold.

select
	category,
    sum(quantity) as total_quantity,
    sum(total_sale) as revenue,
    count(distinct transactions_id) as total_transactions
    from retail_sales_final
    group by category
    order by total_quantity desc;
    
#Q6. The sales manager wants to identify which product category generates the highest revenue.

select
	category,
    sum(total_sale) as revenue,
    sum(quantity) as total_quantity,
    avg(price_per_unit) as avg_selling_price
    from retail_sales_final
    group by category
    order by revenue desc;
    
#Q7. The manager wants to identify the highest-value individual transaction.

select
	transactions_id,
    sum(total_sale) as transaction_value
    from retail_sales_final
    group by transactions_id
    order by transaction_value desc
    limit 1;
    
#Q8. The manager wants to identify the lowest-value transaction.

select
	transactions_id,
    sum(total_sale) as transaction_value
    from retail_sales_final
    group by transactions_id
    order by transaction_value
    limit 1;
    
#Q9. The manager wants to compare the average transaction value between male and female customers.

with trans as (
	select
		transactions_id,
        gender,
        sum(total_sale) as transaction_value
        from retail_sales_final
        group by transactions_id,gender),

final as (
	select
    gender,
		count(transactions_id) as total_transaction,
        sum(transaction_value) as total_revenue,
        avg(transaction_value) as avg_trans_value
        from trans
        group by gender)
        
select * from final;

#Q10. The manager wants to compare monthly revenue and understand how revenue changes compared with the previous month.

with revenue_summery as (
	select
		date_format(sale_date, '%Y-%m') as month,
        sum(total_sale) as current_revenue
	from retail_sales_final
    group by date_format(sale_date, '%Y-%m') ),

previous as (
select
	month,
    current_revenue,
    lag(current_revenue) over(
			order by month) as previous_month_revenue
    from revenue_summery)
    
select 
	month,
    current_revenue,
    previous_month_revenue,
    (current_revenue - previous_month_revenue) as revenue_differ
    from previous;
    
#Q11. The manager wants to understand the percentage increase or decrease in revenue compared with the previous month.

with revenue_summery as (
	select
		date_format(sale_date, '%Y-%m') as month,
        sum(total_sale) as current_revenue
	from retail_sales_final
    group by date_format(sale_date, '%Y-%m') ),

previous as (
select
	month,
    current_revenue,
    lag(current_revenue) over(
			order by month) as previous_month_revenue
    from revenue_summery),
    
growth as (    
select 
	month,
    current_revenue,
    previous_month_revenue,
    (current_revenue - previous_month_revenue) as revenue_differ
    from previous)
    
select 
	month,
    current_revenue,
    previous_month_revenue,
    revenue_differ,
    round(((revenue_differ / nullif(previous_month_revenue,0)) * 100 ),2) as mom
    from growth;
    
#Q12. The manager wants to identify which month generated the highest revenue.

select
	date_format(sale_date, '%Y-%m') as month,
    sum(total_sale) as total_revenue,
    count(distinct transactions_id) as total_transactions,
    sum(quantity) as total_quantity
    from 
    retail_sales_final
    group by date_format(sale_date, '%Y-%m')
    order by total_revenue desc
    limit 3;
    
#Q13. The manager wants to identify which day of the week generates the highest revenue.

select
	dayname(sale_date) as weekdays,
    sum(total_sale) as total_revenue,
    count(distinct transactions_id) as total_transactions,
     sum(quantity) as total_quantity
     from
     retail_sales_final
     group by dayname(sale_date)
     order by total_revenue desc;
     
#Q14. The manager wants to compare sales performance on weekends versus weekdays.

select
	case
		when dayofweek(sale_date) in (1,7) then 'weekend'
        else 'weekday'
	end as day_type,
    sum(total_sale) as total_revenue,
    count(distinct transactions_id) as total_transactions,
     sum(quantity) as total_quantity
     from
     retail_sales_final
     group by day_type
     order by total_revenue desc;
     
#Q15. The manager wants to compare sales performance across quarters.

select
	year(sale_date) as year,
    quarter(sale_date) as quarter,
    sum(total_sale) as total_revenue,
    count(distinct transactions_id) as total_transactions,
     sum(quantity) as total_quantity
     from
     retail_sales_final
     group by year(sale_date),  quarter(sale_date)
     order by year,quarter;
     
#Q16. The manager wants to understand how much each product category contributes to the company's overall revenue.

with cat_revenue as (
	select
		category,
        sum(total_sale) as category_revenue
        from retail_sales_final
        group by category),
        
tot_revenue as (
	select
    category,
    category_revenue,
    sum(category_revenue) over () as total_revenue
    from cat_revenue
    )

select
	category,
    category_revenue,
    total_revenue,
    round(((category_revenue / total_revenue) * 100),2) as revenue_contribution_pct
    from tot_revenue;
    
#Q17. The manager wants to identify the two highest-revenue categories.

with tot_revenue as (
	select 
		category,
        sum(total_sale) as total_revenue
        from retail_sales_final
        group by category),
cat_ranks as (	
select
	category,
    total_revenue,
    dense_rank() over (
		order by total_revenue desc) as cat_rank
	from tot_revenue )
    
select * from cat_ranks
where cat_rank <= 2;

#Q18. The manager wants to identify which product category has the highest average transaction value.

with tot_revenue as (
	select
		category,
        sum(total_sale) as transac_value
        from retail_sales_final
        group by category,transactions_id )
	
select
	category,
    count(*) as total_transaction,
    sum(transac_value) as total_revenue,
    avg(transac_value) as avg_trans_value
    from tot_revenue
    group by category;
    
#Q19. The manager wants to understand how each product category performs across different months.

select
	date_format(sale_date, '%Y-%m') as month,
    category,
    sum(total_sale) as total_revenue,
    sum(quantity) as total_quantity
    from retail_sales_final
    group by date_format(sale_date, '%Y-%m'),category
    order by month asc , total_revenue desc;
    
#Q20. The manager wants to identify the highest-revenue category for every month.

with tot_rev as (
	select
		date_format(sale_date, '%Y-%m') as month,
        category,
        sum(total_sale) as total_revenue
        from retail_sales_final
        group by date_format(sale_date, '%Y-%m'),category),
ranks as (
select
	month,
    category,
    total_revenue,
    dense_rank() over (
		partition by month
        order by total_revenue desc ) as revenue_rank
	from tot_rev)
    
select * from ranks
where revenue_rank = 1;

#Q21. The manager wants to understand each customer's purchasing behaviour.

with tot as (
select
	customer_id,
    sum(total_sale) as total_value,
    sum(quantity) as quantity
    from retail_sales_final
    group by customer_id,transactions_id)
    
select 
	customer_id,
    count(*) as total_transaction,
    sum(total_value) as total_spending,
    sum(quantity) as total_quantity,
    round(avg(total_value),2) as avt
    from tot
    group by customer_id
    order by total_spending desc;
    
#Q22. The manager wants to identify the five customers who spend the most.

with tot as (
select
	customer_id,
    sum(total_sale) as total_value
    from retail_sales_final
    group by customer_id,transactions_id)
    
select 
	customer_id,
    count(*) as total_transaction,
    sum(total_value) as total_spending,
    round(avg(total_value),2) as avt
    from tot
    group by customer_id
    order by total_spending desc
    limit 5;
    
#Q23. The manager wants to classify customers into spending groups.

select
	customer_id,
    sum(total_sale) as total_spending,
    case
		when sum(total_sale) > 10000 then 'High spender'
        when sum(total_sale) >= 5000 then 'Medium spender'
        else 'Low spender'
	end as customer_segment
from retail_sales_final
group by customer_id
order by total_spending desc;
    
#Q24. The manager wants to identify how frequently each customer purchases.

select
	customer_id,
    count(distinct transactions_id) as total_transactions,
    sum(total_sale) as total_spending,
    case
		when count(distinct transactions_id) >= 10 then 'Frequent customer '
        when  count(distinct transactions_id) >=5 then 'Regular customer '
        else 'Occasional customer '
	end as purchase_f_segment
from retail_sales_final
group by customer_id
order by total_transactions desc;

#Q25. The manager wants to understand how many customers have purchased more than once versus those who purchased only once.

with once as (
	select
		customer_id,
        count(distinct transactions_id) as total_transactions,
        sum(total_sale) as total_spending
        from retail_sales_final
        group by customer_id ),

twice as(
	select
		customer_id,
        total_transactions,
        total_spending,
        case
			when total_transactions > 1 then 'Repeated customer'
            else 'One-time customer'
		end as customer_type
	from once)
    
select
	customer_type,
    count(distinct customer_id) as total_customers,
    sum(total_transactions) as total_transactionss,
    sum(total_spending) as total_spendingg
    from twice
    group by customer_type;
    
#Q26.  The manager wants to identify the total revenue generated by each customer throughout the dataset period.

select
	customer_id,
    min(sale_date) as first_purchase,
    max(sale_date) as last_purchase,
    sum(total_sale) as total_spending,
    count(distinct transactions_id) as total_transactions
    from retail_sales_final
    group by customer_id;

    
#Q27.  Days between first and last purchase for each customer.

with ff as (
select
	customer_id,
    min(sale_date) as first_purchase,
    max(sale_date) as last_purchase
    from retail_sales_final
    group by customer_id)
    
select
	customer_id,
    first_purchase,
    last_purchase,
    datediff(last_purchase,first_purchase) as day_differ
    from ff;
    
#Q28. The manager wants to identify how recently each customer made a purchase.

with ff as (
select
	customer_id,
    max(sale_date) as last_purchase
    from retail_sales_final
    group by customer_id)
    
select
	customer_id,
    last_purchase,
    datediff((select max(sale_date) from retail_sales_final),last_purchase) as day_differ
    from ff
    order by customer_id ;
    
#Q29. Find the top 5 customers based on total revenue.

with cus_total as(
	select
		customer_id,
		count(distinct transactions_id) as total_transactions,
		sum(total_sale) as total_revenue
		from retail_sales_final
		group by customer_id),
cus_rank as (
	select
		customer_id,
		total_transactions,
		total_revenue,
		dense_rank() over(
			order by total_revenue desc) as revenue_rank
		from cus_total)
        
select * from
cus_rank
where revenue_rank <=5;

#Q30. Find how much each customer contributes to the overall revenue.

with cust_rev as (
	select
		customer_id,
        sum(total_sale) as total_revenue
        from retail_sales_final
        group by customer_id),

overall_rev as(
	select
		customer_id,
        total_revenue,
        sum(total_revenue) over() as overall_revenue
        from cust_rev)
        
select
		customer_id,
		total_revenue,
		overall_revenue,
		round(((total_revenue / overall_revenue) * 100 ) , 2) as contribution
from overall_rev
order by contribution desc;