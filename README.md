# Week 1 Questions

#### Q1: How many users do we have?

- 130 unique users

```sql
select count(distinct user_guid) from stg_users
```

#### Q2: On average, how many orders do we receive per hour?

- 7.52 orders per hour

```sql
with orders_per_hour as (
  select 
    date_trunc('hour', created_at_utc) as created_date_hour,
    count(order_guid) as order_count
  from dbt_kayla_i.stg_orders
  group by 1
)

select round(avg(order_count),2) avg_order_count from orders_per_hour
```

#### Q3: On average, how long does an order take from being placed to being delivered?

- 93.40 hours to delivery

```sql
with delivered_orders as (
  select 
    order_guid,
    created_at_utc,
    delivered_at_utc
  from dbt_kayla_i.stg_orders
  where order_status = 'Delivered'
),

avg_delivery_time_seconds as(
  select
    avg(extract(epoch from delivered_at_utc - created_at_utc)) as seconds_to_deliver
  from delivered_orders
)
select round(cast(seconds_to_deliver as numeric)/3600, 2) from avg_delivery_time_seconds
```

#### Q4: How many users have only made one purchase? Two purchases? Three+ purchases?

| orders_placed | user_count |
| ------------- | ---------- |
| 1             | 25         |
| 2             | 28         |
| 3+            | 71         |

```sql
with orders_per_user as (
  select
    user_guid,
    count(distinct order_guid) as order_count
  from dbt_kayla_i.stg_orders
  group by user_guid
)

select
  case 
    when order_count >= 3 then '3+'
    else order_count::varchar
  end as orders_placed,
  count(distinct user_guid) user_count
from orders_per_user
group by 1
order by orders_placed
```

#### Q5: On average, how many unique sessions do we have per hour?

- 16.33 unique sessions

```sql
with sessions_per_hour as(
  select 
    date_trunc('hour', created_at_utc) session_hour,
    count(distinct session_guid) as session_count
  from dbt_kayla_i.stg_events
  group by 1
)

select round(avg(session_count), 2) from sessions_per_hour
```

