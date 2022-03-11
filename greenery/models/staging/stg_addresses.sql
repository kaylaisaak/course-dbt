with source as (

    select * from {{ source('src_postgres', 'addresses') }}
),

renamed as (

    select 
        address_id as address_guid,
        address,
        zipcode,
        state,
        country

    from source
)

select * from renamed