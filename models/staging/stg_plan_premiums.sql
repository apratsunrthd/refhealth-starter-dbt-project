with source as (
    select * from {{ ref('raw_plan_premiums') }}
),

cleaned as (
    select
        {{ dbt_utils.generate_surrogate_key(['plan_id', 'service_month']) }} as plan_month_surrogate_id,
        trim(plan_id) as plan_id,
        cast(service_month as date) as service_month,
        cast(earned_premium_amount as {{ dbt.type_float() }}) as earned_premium_amount,
        cast(enrolled_member_months as integer) as enrolled_member_months
    from source
)

select * from cleaned
