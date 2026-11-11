with source as (
    select * from {{ source('raw', 'customers') }}
),

cleaned as (
    select
        customer_id,
        trim(first_name)                        as first_name,
        trim(last_name)                         as last_name,
        trim(first_name) || ' ' || trim(last_name) as full_name,
        date_of_birth,
        date_part('year', age(date_of_birth))   as age,
        city,
        country,
        upper(segment)                          as segment,
        email,
        phone,
        created_at,
        updated_at,
        is_deleted
    from source
    where customer_id is not null
)

select * from cleaned