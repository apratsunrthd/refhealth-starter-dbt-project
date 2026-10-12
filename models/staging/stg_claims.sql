with source as (
    select * from {{ ref('raw_claims') }}
),

cleaned as (
    select
        {{ dbt_utils.generate_surrogate_key(['claim_id', 'claim_line_number']) }} as claim_line_surrogate_id,
        trim(claim_id) as claim_id,
        cast(claim_line_number as integer) as claim_line_number,
        trim(member_id) as member_id,
        cast(date_of_service as date) as date_of_service,
        trim(cast(billing_npi as {{ dbt.type_string() }})) as billing_npi,
        trim(cast(rendering_npi as {{ dbt.type_string() }})) as rendering_npi,
        upper(trim(primary_diagnosis_code)) as primary_diagnosis_code,
        upper(trim(procedure_code)) as procedure_code,
        cast(charge_amount as {{ dbt.type_float() }}) as charge_amount,
        cast(paid_amount as {{ dbt.type_float() }}) as paid_amount,
        cast(patient_due_amount as {{ dbt.type_float() }}) as patient_due_amount,
        cast(paid_date as date) as paid_date,
        cast(created_at as timestamp) as created_at,
        upper(trim(claim_status)) as claim_status
    from source
)

select * from cleaned
