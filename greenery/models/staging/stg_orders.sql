with source as (

    select * from {{ source('src_postgres', 'orders') }}
),

renamed as (

    select 
        order_id as order_guid,
        user_id as user_guid,
        promo_id as promo_id,
        address_id as address_guid,
        tracking_id,
        order_cost as order_cost_usd,
        shipping_cost as shipping_cost_usd,
        order_total as order_total_usd,
        upper(shipping_service) as shipping_service,
        estimated_delivery_at as estimated_delivery_at_utc,
        delivered_at as delivered_at_utc,
        created_at as order_placed_at_utc,
        initcap(status) as order_status

    from source
)

select * from renamed