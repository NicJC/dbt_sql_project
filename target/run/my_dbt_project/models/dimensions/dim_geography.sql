USE "dbt_dev";
    USE "dbt_dev";
    
    

    

    USE "dbt_dev";
    EXEC('
        CREATE OR ALTER VIEW "dbo"."dim_geography__dbt_tmp__dbt_tmp_vw" AS 

with source_data as (

    select
        country,
        region,
        
    -- SQL Server surrogate key using SHA2_256
    convert(varchar(64),
        hashbytes(
            ''SHA2_256'',
            concat(country,''|'',region)
        ),
    2)
 as geography_key,
        current_timestamp as valid_from,
        cast(''9999-12-31'' as datetime) as valid_to,
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

;
    ')

EXEC('IF OBJECT_ID(''"dbo"."dim_geography__dbt_tmp"'', ''U'') IS NOT NULL
            EXEC(''DROP TABLE "dbt_dev"."dbo"."dim_geography__dbt_tmp"'');SELECT TOP 0 * INTO "dbt_dev"."dbo"."dim_geography__dbt_tmp" FROM "dbt_dev"."dbo"."dim_geography__dbt_tmp__dbt_tmp_vw"')
EXEC('INSERT INTO "dbt_dev"."dbo"."dim_geography__dbt_tmp" WITH (TABLOCK)
        SELECT * FROM "dbt_dev"."dbo"."dim_geography__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');
')

    

    
    USE "dbt_dev";
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbo_dim_geography_cci'
        AND object_id=object_id('"dbo"."dim_geography__dbt_tmp"')
    )
    DROP index "dbo"."dim_geography__dbt_tmp"."dbo_dim_geography_cci"
    CREATE CLUSTERED COLUMNSTORE INDEX "dbo_dim_geography_cci"
    ON "dbo"."dim_geography__dbt_tmp"

   