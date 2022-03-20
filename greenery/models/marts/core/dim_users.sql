with users as (

  select * from {{ ref('stg_users') }}
),

addresses as (

  select * from {{ ref('stg_addresses') }}
)

select
  users.user_guid,
  users.first_name,
  users.last_name,
  users.first_name || ' ' || users.last_name as full_name,
  users.email,
  users.phone_number,
  addresses.address,
  addresses.state,
  addresses.country,
  addresses.zipcode,
  users.signup_date_utc

from
  users
left outer join addresses
  on users.address_guid = addresses.address_guid