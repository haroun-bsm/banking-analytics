with source as (
    select * from {{ source('raw', 'accounts') }}
),

cleaned as (
    select
        account_id,
        customer_id,
        upper(account_type)  as account_type,
        upper(status)        as status,
        currency,
        balance,
        opened_date,
        closed_date,
        case
            when closed_date is null then true
            else false
        end                  as is_active,
        created_at
    from source
    where account_id is not null
      and customer_id is not null
)

select * from cleaned