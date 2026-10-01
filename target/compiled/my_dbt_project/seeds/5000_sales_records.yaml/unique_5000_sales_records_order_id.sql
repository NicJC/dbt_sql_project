
    
    

select
    order_id as unique_field,
    count(*) as n_records

from "dbt_dev"."dbo_seed_data"."5000_sales_records"
where order_id is not null
group by order_id
having count(*) > 1


