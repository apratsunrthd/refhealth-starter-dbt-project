with source as (
    select * from {{ ref('raw_members') }}
),

renamed as (
    select
        trim(member_id) as member_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        cast(date_of_birth as date) as date_of_birth,
        upper(trim(gender)) as gender,
        cast(coverage_effective_date as date) as coverage_effective_date,
        cast(coverage_term_date as date) as coverage_term_date,
        cast(enrollment_date as date) as enrollment_date,
        cast(updated_date as date) as updated_date,
        trim(plan_id) as plan_id
    from source
)

select * from renamed
