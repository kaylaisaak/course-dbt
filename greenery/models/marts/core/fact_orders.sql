with orders as (

    select * from {{ ref('int_order_events') }}
),

order_format_hours as (
    
    select
        order_guid,
        tracking_id,
        order_cost_usd,
        shipping_cost_usd,
        order_total_usd,
        shipping_service,
        estimated_delivery_at_utc,
        delivered_at_utc,
        order_placed_at_utc,
        order_status,
        checkout_at_utc,
        shipped_at_utc,
        checkout_to_ship_hours_rounded as checkout_to_ship_hours,
        ship_to_delivery_hours_rounded as ship_to_delivery_hours,
        checkout_to_delivery_hours_rounded as checkout_to_delivery_hours,
        case
            when delivered_at_utc > estimated_delivery_at_utc then 'Late'
            else 'On Time'
        end as on_time_delivery

    from orders
),

order_on_time_status as (
    
    select
        *,
        case
            when delivered_at_utc > estimated_delivery_at_utc then 'Late'
            else 'On Time'
        end as on_time_delivery

    from orders
)

select * from order_on_time_status