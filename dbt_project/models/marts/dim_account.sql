with stg as (
    select * from {{ ref('stg_accounts') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['account_id']) }} as account_sk,
    account_id,
    customer_id,
    account_type,
    status,
    currency,
    balance,
    opened_date,
    closed_date,
    is_active
from stg