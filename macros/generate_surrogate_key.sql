{% macro generate_surrogate_key(columns) %}
    -- SQL Server surrogate key using SHA2_256
    convert(varchar(64),
        hashbytes(
            'SHA2_256',
            concat({{ columns | join(",'|',") }})
        ),
    2)
{% endmacro %}
