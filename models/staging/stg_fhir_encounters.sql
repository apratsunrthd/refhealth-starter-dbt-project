with source as (
    select * from {{ ref('raw_fhir_encounters') }}
),

cleaned as (
    select
        {{ dbt_utils.generate_surrogate_key(['encounter_id']) }} as encounter_surrogate_id,
        trim(encounter_id) as encounter_id,
        lower(trim(status)) as status,
        upper(trim(class_code)) as class_code,
        upper(trim(type_code)) as type_code,
        cast(period_start as timestamp) as period_start,
        cast(period_end as timestamp) as period_end,
        cast(period_start as date) as encounter_date,
        trim(cast(service_provider_npi as {{ dbt.type_string() }})) as service_provider_npi,
        trim(subject_member_id) as subject_member_id
    from source
)

select * from cleaned
