# Week 3 Questions

#### Q1: What is our overall conversion rate?
- 62.46%
```sql
select 
round(cast(count(distinct case when total_checkout_events > 0 THEN session_guid end) as numeric)
/cast(count(distinct session_guid) as numeric),4) AS total_conversion_rate
FROM dbt_kayla_i.fact_sessions
```

#### Q2: What is our conversion rate by product?
| product_id                           | name                | conversion_rate |
|--------------------------------------|---------------------|-----------------|
| 6f3a3072-a24d-4d11-9cef-25b0b5f8a4af | Alocasia Polly      | 0.4118          |
| 74aeb414-e3dd-4e8a-beef-0fa45225214d | Arrow Head          | 0.5556          |
| 80eda933-749d-4fc6-91d5-613d29eb126f | Pink Anthurium      | 0.4189          |
| 843b6553-dc6a-4fc4-bceb-02cd39af0168 | Ficus               | 0.4265          |
| a88a23ef-679c-4743-b151-dc7722040d8c | Jade Plant          | 0.4783          |
| b66a7143-c18a-43bb-b5dc-06bb5d1d3160 | ZZ Plant            | 0.5397          |
| b86ae24b-6f59-47e8-8adc-b17d88cbd367 | Calathea Makoyana   | 0.5094          |
| bb19d194-e1bd-4358-819e-cd1f1b401c0c | Birds Nest Fern     | 0.4231          |
| be49171b-9f72-4fc9-bf7a-9a52e259836b | Monstera            | 0.5102          |
| c17e63f7-0d28-4a95-8248-b01ea354840e | Cactus              | 0.5455          |
| c7050c3b-a898-424d-8d98-ab0aaad7bef4 | Orchid              | 0.4533          |
| d3e228db-8ca5-42ad-bb0a-2148e876cc59 | Money Tree          | 0.4643          |
| e18f33a6-b89a-4fbc-82ad-ccba5bb261cc | Ponytail Palm       | 0.4             |
| e2e78dfc-f25c-4fec-a002-8e280d61a2f2 | Boston Fern         | 0.4127          |
| e5ee99b6-519f-4218-8b41-62f48f59f700 | Peace Lily          | 0.4091          |
| e706ab70-b396-4d30-a6b2-a1ccf3625b52 | Fiddle Leaf Fig     | 0.5             |
| e8b6528e-a830-4d03-a027-473b411c7f02 | Snake Plant         | 0.3973          |
| fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 | String of pearls    | 0.6094          |
| 05df0866-1a66-41d8-9ed7-e2bbcddd6a3d | Bird of Paradise    | 0.45            |
| 35550082-a52d-4301-8f06-05b30f6f3616 | Devil's Ivy         | 0.4889          |
| 37e0062f-bd15-4c3e-b272-558a86d90598 | Dragon Tree         | 0.4677          |
| 4cda01b9-62e2-46c5-830f-b7f262a58fb1 | Pothos              | 0.3443          |
| 55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3 | Philodendron        | 0.4839          |
| 579f4cd0-1f45-49d2-af55-9ab2b72c3b35 | Rubber Plant        | 0.5185          |
| 58b575f2-2192-4a53-9d21-df9a0c14fc25 | Angel Wings Begonia | 0.3934          |
| 5b50b820-1d0a-4231-9422-75e7f6b0cecf | Pilea Peperomioides | 0.4746          |
| 5ceddd13-cf00-481f-9285-8340ab95d06d | Majesty Palm        | 0.4925          |
| 615695d3-8ffd-4850-bcf7-944cf6d3685b | Aloe Vera           | 0.4923          |
| 64d39754-03e4-4fa0-b1ea-5f4293315f67 | Spider Plant        | 0.4746          |
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Bamboo              | 0.5373          |

#### Q3: Why might certain products be converting at higher/lower rates than others?
- Availability (out of stock)

---

# Week 2 Questions

#### Q1: What is our user repeat rate?
- 79.84%

```sql
with orders as (
  select * from dbt_kayla_i.stg_orders
),

user_purchase_count as (
  select
    user_guid,
    count(distinct order_guid) as purchase_count
  from orders
  group by user_guid
),

repeat_count as (
  select
    sum(case 
          when purchase_count > 1 then 1
          else 0
        end) as repeat_purchase,
    count(user_guid) as total_users
  from user_purchase_count
)

select round((repeat_purchase / total_users::numeric) * 100, 2) as repeat_rate from repeat_count
```

#### Q2: 
- **What are good indicators of a user who will likely purchase again?**
  - Frequent site visits
  - Have already made multiple purchases
  - Higher product quantities purchased
  - Short delivery time
  - High conversion rate (most site visits lead to an order being placed)
  - Users who have something sitting in their cart already
  - Promotion use

- **What about indicators of users who are likely NOT to purchase again?**
  - Long delivery time
  - Have not purchased in a long time
  - Low conversion rate (few site visits lead to an order being placed)

- **If you had more data, what features would you want to look into to answer this question?**
  - Gender
  - What else are they buying/searching for?
  - Are they comparing our products/prices to a competitor?
  - How frequently are we running promotions and sending out promo codes?
  - Do we have a guaranteed delivery time? How frequently are we within that window?
  - Inventory history - Could we have sold more of a product but it was out of stock?
  - Have price changes affected customer retention?

#### Q3: Explain the marts models you added. Why did you organize the models in the way you did?
- Core
  - Everything that will be used in models across departments or is high-level summary info
  - **int_order_events**: Transformations for time metrics combining event and order info. Reusable for time metrics in other models for all departments.
  - **int_user_activity**: Includes repeatable table join. Reusable for other models for all departments.
  - **fact_orders**: Order summary model to answer general sales questions
    - Are sales increasing or decreasing?
    - Are delivery times increasing/decreasing? How does that impact future sales?

- Marketing
  - **fact_user_orders**: Answer questions about website effectiveness and promotions
    - Are site visits increasing/decreasing? New or existing customers?
    - How long does a customer spend on the site before completing an order?
    - Are customers using promotions? What promos are the most popular?
    - Where are we shipping the most product to?

- Product
  - **fact_product_orders**: Answer questions related to product purchase history and inventory needs
    - What products have been purchased the most? Least? Never?
    - Do current inventory levels match the purchase trend per product?
  - **fact_product_views**: Answer questions related to product interest
    - How many users went back to look at the same product multiple times?
    - What products haven't been viewed in a long time (or ever)? The most?

#### Q4: What assumptions are you making about each model? (i.e. why are you adding each test?)
- Primary keys for each model
- Positive values for quantities and amounts
- Accepted values for Event Types, so I'll know if there's a new event type to map or if one changes
- Checkout time < Shipment time < Delivery time

#### Q5: Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
- I didn't run into any that wasn't already handled in staging/transformation conversions

#### Q6: Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
- Implement a tool that displays status history and allows users to subscribe to various alerts per test. My company is currently evaluating options for this, but I don't recall the names of the tools that have been tried so far. It would be similar to the dbt status page: https://status.getdbt.com/

---

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

