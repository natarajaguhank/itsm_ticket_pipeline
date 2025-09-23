-- Monthly ticket summary
with base as (
    select *
    from {{ ref('stg_itsm_tickets') }}
)

select
    year,
    month,
    count(*) as total_tickets,
    avg(resolution_hours) as avg_resolution_time,
    sum(case when state='Closed' then 1 else 0 end)::float / count(*) as closure_rate
from base
group by year, month
order by year, month
