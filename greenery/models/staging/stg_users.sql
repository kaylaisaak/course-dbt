with source as (

    select * from {{ source('src_postgres', 'users') }}
),

renamed as (

    select 
        user_id as user_guid,
        address_id as address_guid,
        first_name,
        last_name,
        email,
        phone_number,
        created_at as signup_date_utc,
        updated_at as updated_at_utc
        
    from source
)

select * from renamed