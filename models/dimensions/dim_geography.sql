{{ config(
    materialized='incremental',
    unique_key='geography_key',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

with source_data as (

    select
        country,
        region,
        {{ generate_surrogate_key(['country', 'region']) }} as geography_key,
        current_timestamp as valid_from,
        cast('9999-12-31' as datetime) as valid_to,
        1 as is_current
    from {{ ref('5000_sales_records') }}
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

{% if is_incremental() %}

with existing as (
    select *
    from {{ this }}
)

where sd.geography_key not in (
    select geography_key from existing where is_current = 1
)

{% endif %}

