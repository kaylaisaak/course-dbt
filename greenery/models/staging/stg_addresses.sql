with source as (

    select * from {{ source('src_postgres', 'addresses') }}
),

renamed as (

    select 
        address_id as address_guid,
        address,
        to_char(zipcode,'00000') as zipcode,
        state,
        country

    from source
)

select * from renamed