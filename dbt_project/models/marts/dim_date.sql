with date_spine as (
    select generate_series(
        '2018-01-01'::date,
        '2026-12-31'::date,
        '1 day'::interval
    )::date as full_date
),

final as (
    select
        to_char(full_date, 'YYYYMMDD')::integer as date_id,
        full_date,
        date_part('year',    full_date)::integer as year,
        date_part('quarter', full_date)::integer as quarter,
        date_part('month',   full_date)::integer as month,
        to_char(full_date, 'Month')              as month_name,
        date_part('week',    full_date)::integer as week,
        to_char(full_date, 'Day')                as day_of_week,
        case when date_part('dow', full_date) in (0,6) then true else false end as is_weekend
    from date_spine
)

select * from final