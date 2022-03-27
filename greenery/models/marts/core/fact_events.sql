with events as (
    select * from {{ ref('stg_events') }}
)

, users as (
    select * from {{ ref('dim_users') }}
)

, products as (
    SELECT * FROM {{ ref('stg_products') }}
)

select
events.event_guid,
events.session_guid,
events.user_guid,
events.page_url,
events.created_at_utc,
events.event_type,
events.order_guid,
events.product_guid,
users.signup_date_utc,
users.state,
users.country,
products.product_name,
products.price,
row_number() over(partition by events.session_guid order by events.created_at_utc asc) as event_sequence

FROM events

LEFT JOIN users
    ON events.user_guid = users.user_guid

LEFT JOIN products
    ON events.product_guid = products.product_guid