with events as (

    select * from {{ ref('stg_events') }}
),

users as (

    select * from {{ ref('stg_users') }}
),

user_events as (

    select
        users.user_guid,
        events.session_guid,
        events.event_guid,
        events.order_guid,
        events.product_guid,
        events.page_url,
        events.created_at_utc as event_time_utc,
        events.event_type

    from 
        events
    full outer join users
        on events.user_guid = users.user_guid
)

select * from user_events