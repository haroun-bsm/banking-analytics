with loans as (
    select * from {{ ref('stg_loans') }}
),

customers as (
    select customer_id, customer_sk
    from {{ ref('dim_customer') }}
    where dbt_is_current = true
),

dates as (
    select date_id, full_date
    from {{ ref('dim_date') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['l.loan_id']) }} as loan_sk,
        l.loan_id,
        c.customer_sk,
        d.date_id,
        l.loan_type,
        l.principal,
        l.outstanding,
        l.interest_rate,
        l.issue_date,
        l.due_date,
        l.loan_status,
        l.days_past_due,
        l.is_npl
    from loans l
    left join customers c on l.customer_id = c.customer_id
    left join dates d on d.full_date = l.issue_date::date
)

select * from final