with txn as (
    select * from {{ ref('stg_transactions') }}
),

accounts as (
    select account_id, account_sk, customer_id
    from {{ ref('dim_account') }}
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
        {{ dbt_utils.generate_surrogate_key(['t.transaction_id']) }} as transaction_sk,
        t.transaction_id,
        a.account_sk,
        c.customer_sk,
        d.date_id,
        t.txn_type,
        t.channel,
        t.status,
        t.amount,
        t.completed_amount,
        t.txn_date,
        t.description
    from txn t
    left join accounts a  on t.account_id   = a.account_id
    left join customers c on a.customer_id  = c.customer_id
    left join dates d     on t.txn_date_key = d.full_date
)

select * from final