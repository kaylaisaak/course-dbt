with products as (

    select * from {{ ref('stg_products') }}
)

select
    product_guid,
    product_name,
    price,
    inventory_count

from
    products