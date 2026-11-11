-- models/kpis/kpi_customer_segments.sql

with customers as (
    select *
    from {{ ref('dim_customer') }}
    where dbt_is_current = true
      and is_deleted = false
),

accounts as (
    select
        customer_id,
        count(*) as account_count,
        sum(balance) as total_balance
    from {{ ref('dim_account') }}
    where is_active = true
    group by customer_id
),

loans as (
    select
        c.customer_id,
        count(fl.loan_sk) as loan_count,
        sum(fl.outstanding) as total_loan_outstanding
    from {{ ref('fact_loans') }} fl
    join {{ ref('dim_customer') }} c
        on fl.customer_sk = c.customer_sk
    group by c.customer_id
),

final as (
    select
        c.segment,
        count(c.customer_id) as total_customers,
       round(avg(a.total_balance)::numeric, 2) as avg_balance,
round(sum(a.total_balance)::numeric, 2) as total_deposits,
round(avg(a.account_count)::numeric, 2) as avg_accounts_per_customer,
        coalesce(sum(l.total_loan_outstanding), 0) as total_loans_outstanding,
        count(case when l.loan_count > 0 then 1 end) as customers_with_loans
    from customers c
    left join accounts a
        on c.customer_id = a.customer_id
    left join loans l
        on c.customer_id = l.customer_id
    group by c.segment
)

select * from final