with loan_summary as (
    select
        d.year,
        d.quarter,
        d.month,
        date_trunc('month', d.full_date)    as month_start,
        sum(f.outstanding)                  as total_outstanding,
        sum(case when coalesce(f.is_npl, false) then f.outstanding else 0 end) as npl_outstanding,
        count(f.loan_sk)                    as total_loans,
        count(case when f.is_npl then 1 end) as npl_count
    from {{ ref('fact_loans') }} f
    join {{ ref('dim_date') }} d
        on f.date_id = d.date_id
    group by 1, 2, 3, 4
),

final as (
    select
        *,
        round(
    (
        npl_outstanding
        / nullif(total_outstanding, 0)
        * 100
    )::numeric,
    2
) as npl_ratio_pct,
        round(
    (
        npl_count::numeric
        / nullif(total_loans, 0)
        * 100
    )::numeric,
    2
) as npl_count_ratio_pct
    from loan_summary
)

select * from final
order by month_start