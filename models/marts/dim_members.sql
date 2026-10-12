with staging as (
    select * from {{ ref('stg_members') }}
),

enriched as (
    select
        member_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as full_name,
        date_of_birth,
        gender,
        coverage_effective_date,
        coverage_term_date,
        enrollment_date,
        updated_date,
        plan_id,
        case 
            when current_date >= coverage_effective_date 
             and current_date <= coalesce(coverage_term_date, cast('2099-12-31' as date))
            then true 
            else false 
        end as is_currently_enrolled
    from staging
)

select * from enriched
