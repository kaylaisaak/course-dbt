with page_views as (

    select * from {{ ref('int_user_activity') }} where event_type = 'page_view'
),

products as (

    select * from {{ ref('dim_products') }}
),

product_views as (

    select 
        products.product_guid,
        products.product_name,
        products.price,
        page_views.session_guid,
        page_views.event_guid,
        page_views.order_guid,
        page_views.event_time_utc as page_view_at_utc
    
    from
        page_views
    full outer join products
        on page_views.product_guid = products.product_guid
)

select * from product_views