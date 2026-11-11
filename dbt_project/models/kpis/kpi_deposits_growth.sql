with monthly_deposits as (
    select
        d.year,
        d.month,
        d.month_name,
        date_trunc('month', d.full_date)    as month_start,
        sum(t.completed_amount)             as total_deposits
    from {{ ref('fact_transactions') }} t
    join {{ ref('dim_date') }} d
        on t.date_id = d.date_id
where t.completed_amount > 0      and t.status   = 'COMPLETED'
    group by 1, 2, 3, 4
),

with_growth as (
    select
        year,
        month,
        month_name,
        month_start,
        total_deposits,
        lag(total_deposits) over (order by month_start) as prev_month_deposits,
        round(
    (
        (total_deposits - lag(total_deposits) over (order by month_start))
        / nullif(lag(total_deposits) over (order by month_start), 0)
        * 100
    )::numeric,
    2
) as mom_growth_pct
    from monthly_deposits
)

select * from with_growth
order by month_start