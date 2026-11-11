{% snapshot snap_customers %}

{{
    config(
        target_schema='marts',
        unique_key='customer_id',
        strategy='check',
        check_cols=['first_name','last_name','city','segment','email','phone','is_deleted'],
        invalidate_hard_deletes=True
    )
}}

select
    customer_id,
    first_name,
    last_name,
    full_name,
    date_of_birth,
    city,
    country,
    segment,
    email,
    phone,
    created_at,
    updated_at,
    is_deleted
from {{ ref('stg_customers') }}

{% endsnapshot %}