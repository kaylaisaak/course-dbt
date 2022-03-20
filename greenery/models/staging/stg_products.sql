with source as (

    select * from {{ source('src_postgres', 'products') }}
),

renamed as (

    select 
        product_id as product_guid,
        name as product_name,
        price,
        inventory as inventory_count

    from source
)

select * from renamed