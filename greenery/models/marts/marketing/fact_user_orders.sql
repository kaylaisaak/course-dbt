with orders as (

    select * from {{ ref('int_order_events') }}
),

users as (

    select * from {{ ref('dim_users') }}
),

promos as ( 

    select * from {{ ref('stg_promos') }}
),

user_orders as (

    select 
        orders.*,
        users.full_name,
        users.state,
        users.country,
        promos.discount

    from 
        orders
    left outer join users
        on orders.user_guid = users.user_guid
    left outer join promos
        on orders.promo_id = promos.promo_id
)

select * from user_orders