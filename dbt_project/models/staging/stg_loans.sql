with source as (
    select * from {{ source('raw', 'loans') }}
),

cleaned as (
    select
        loan_id,
        customer_id,
        upper(loan_type)    as loan_type,
        principal,
        outstanding,
        interest_rate,
        issue_date,
        due_date,
        upper(loan_status)  as loan_status,
        days_past_due,
        created_at,
        case
            when days_past_due >= 90 then true
            else false
        end                 as is_npl  -- Non-Performing Loan flag
    from source
    where loan_id is not null
)

select * from cleaned