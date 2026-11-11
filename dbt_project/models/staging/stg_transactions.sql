with source as (
    select * from {{ source('raw', 'transactions') }}
),

cleaned as (
    select
        transaction_id,
        account_id,
        upper(txn_type)     as txn_type,
        amount,
        txn_date,
        date(txn_date)      as txn_date_key,
        upper(channel)      as channel,
        upper(status)       as status,
        description,
        created_at,
        case
            when upper(status) = 'COMPLETED' then amount
            else 0
        end                 as completed_amount
    from source
    where transaction_id is not null
      and amount > 0
)

select * from cleaned