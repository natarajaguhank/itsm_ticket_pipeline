-- Clean raw tickets data
with raw as (
    select *
    from {{ source('itsm_db', 'itsm_tickets_raw') }}
)

select
    distinct inc_number as ticket_number,
    inc_business_service as business_service,
    inc_category as category,
    inc_priority as priority,
    inc_sla_due as sla_due,
    to_timestamp(inc_sys_created_on, 'DD-MM-YYYY HH24:MI') as created_at,
    to_timestamp(inc_resolved_at, 'DD-MM-YYYY HH24:MI') as resolved_at,
    inc_assigned_to as assigned_to,
    inc_state as state,
    inc_cmdb_ci as cmdb_ci,
    inc_caller_id as caller_id,
    inc_short_description as short_description,
    inc_assignment_group as assignment_group,
    inc_close_code as close_code,
    inc_close_notes as close_notes,
    date_part('year', to_timestamp(inc_sys_created_on, 'DD-MM-YYYY HH24:MI')) as year,
    date_part('month', to_timestamp(inc_sys_created_on, 'DD-MM-YYYY HH24:MI')) as month,
    date_part('day', to_timestamp(inc_sys_created_on, 'DD-MM-YYYY HH24:MI')) as day,
    extract(epoch from (to_timestamp(inc_resolved_at, 'DD-MM-YYYY HH24:MI') - to_timestamp(inc_sys_created_on, 'DD-MM-YYYY HH24:MI')))/3600 as resolution_hours
from raw
where inc_number is not null
