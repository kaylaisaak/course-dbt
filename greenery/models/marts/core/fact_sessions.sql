{% set event_types = dbt_utils.get_column_values(table=ref('stg_events'), column='event_type') %}

WITH events AS (
    SELECT * FROM {{ ref('fact_events') }}
),

sessions AS (

    SELECT
    events.session_guid,
    events.user_guid,
    events.signup_date_utc,
    events.state,
    events.country,
    MIN(events.created_at_utc) AS session_created_at_utc,
    {% for event_type in event_types %}
    SUM(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END) AS total_{{event_type}}_events
    {% if not loop.last %},{% endif %}  
    {% endfor %}

    FROM events

    GROUP BY 1,2,3,4,5

)

SELECT
*

FROM sessions 