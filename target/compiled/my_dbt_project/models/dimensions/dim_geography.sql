

with source_data as (

    select
        country,
        region,
        
    -- SQL Server surrogate key using SHA2_256
    convert(varchar(64),
        hashbytes(
            'SHA2_256',
            concat(country,'|',region)
        ),
    2)
 as geography_key,
        current_timestamp as valid_from,
        cast('9999-12-31' as datetime) as valid_to,
        1 as is_current
    from "dbt_dev"."dbo_dbo"."5000_sales_records"
    group by country, region

)

select
    sd.geography_key,
    sd.country,
    sd.region,
    sd.valid_from,
    sd.valid_to,
    sd.is_current
from source_data sd

