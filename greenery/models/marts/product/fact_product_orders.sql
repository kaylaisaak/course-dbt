with orders as (

    select * from {{ ref('int_order_events') }}
),

order_items as (
    
    select * from {{ ref('stg_order_items') }}
),

products as (

    select * from {{ ref('dim_products') }}
),

users as ( 

    select * from {{ ref('dim_users') }}
),

product_orders as (

    select 
        orders.*,
        order_items.quantity_ordered,
        products.product_guid,
        products.product_name,
        users.state,
        users.country,
        products.price * order_items.quantity_ordered as total_product_cost_usd --assuming prices have not changed
    
    from 
        orders
    inner join order_items
        on orders.order_guid = order_items.order_guid
    left outer join products
        on order_items.product_guid = products.product_guid
    left outer join users
        on orders.user_guid = users.user_guid
)

select * From product_orders