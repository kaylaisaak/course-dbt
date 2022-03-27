with orders as (

    select * from {{ ref('stg_orders') }}
),

events as (

    select * from {{ ref('int_user_activity')}}
),

order_by_session as (

    select 
        orders.*,
        events.session_guid
    from
        orders
    left outer join events
        on orders.order_guid = events.order_guid
),

order_checkout as (

    select 
        order_by_session.*,
        events.event_time_utc as checkout_at_utc
    
    from 
        order_by_session
    left outer join events
        on order_by_session.order_guid = events.order_guid
    
    where events.event_type = 'checkout'
),

order_shipped as (

    select 
        order_checkout.*,
        events.event_time_utc as shipped_at_utc
    
    from 
        order_checkout
    left outer join events
        on order_checkout.order_guid = events.order_guid
    
    where events.event_type = 'package_shipped'
),

order_time_periods as (

    select 
        *,
        cast(extract(epoch from shipped_at_utc - checkout_at_utc) as numeric)/3600 as checkout_to_ship_hours, --test for positive
        cast(extract(epoch from delivered_at_utc - shipped_at_utc) as numeric)/3600 as ship_to_delivery_hours, --test for positive
        cast(extract(epoch from delivered_at_utc - checkout_at_utc) as numeric)/3600 as checkout_to_delivery_hours --test for positive

    from
        order_shipped
),

order_round_hours as (

    select 
        *,
        round(checkout_to_ship_hours, 2) as checkout_to_ship_hours_rounded,
        round(ship_to_delivery_hours, 2) as ship_to_delivery_hours_rounded,
        round(checkout_to_delivery_hours, 2) as checkout_to_delivery_hours_rounded

    from order_time_periods
)

select * from order_round_hours