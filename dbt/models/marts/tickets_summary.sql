-- Aggregated metrics per category and priority
with base as (
    select *
    from {{ ref('stg_itsm_tickets') }}
)

select
    category,
    priority,
    avg(resolution_hours) as avg_resolution_time_hours,
    sum(case when state='Closed' then 1 else 0 end)::float / count(*) as closure_rate
from base
group by category, priority
