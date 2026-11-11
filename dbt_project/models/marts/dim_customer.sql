with snapshot as (

    select * from {{ ref('snap_customers') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'dbt_scd_id']) }} as customer_sk,
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
        is_deleted,
        dbt_scd_id,
        dbt_valid_from,
        dbt_valid_to,
        case
            when dbt_valid_to is null then true
            else false
        end as dbt_is_current

    from snapshot

)

select * from final