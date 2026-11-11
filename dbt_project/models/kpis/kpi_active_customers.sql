
with txn_activity as (
    select
        c.customer_id,
        c.segment,
        c.city,
        d.year,
        d.month,
        date_trunc('month', d.full_date) as month_start,
        count(t.transaction_sk) as txn_count,
        sum(t.completed_amount) as total_volume
    from {{ ref('fact_transactions') }} t
    join {{ ref('dim_customer') }} c
        on t.customer_sk = c.customer_sk
    join {{ ref('dim_date') }} d
        on t.date_id = d.date_id
    where t.status = 'COMPLETED'
    group by 1,2,3,4,5,6
),

active_per_month as (
    select
        month_start,
        year,
        month,
        count(distinct customer_id) as active_customers,
        count(distinct case when segment = 'RETAIL' then customer_id end) as active_retail,
        count(distinct case when segment = 'SME' then customer_id end) as active_sme,
        count(distinct case when segment = 'CORPORATE' then customer_id end) as active_corporate,
        sum(total_volume) as total_txn_volume
    from txn_activity
    group by 1,2,3
)

select
    *,
    lag(active_customers) over (order by month_start) as prev_month_active,
    active_customers
      - lag(active_customers) over (order by month_start) as net_new_active
from active_per_month
order by month_start