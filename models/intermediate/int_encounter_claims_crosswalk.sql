with encounters as (
    select * from {{ ref('stg_fhir_encounters') }}
),

claims as (
    select * from {{ ref('stg_claims') }}
),

joined as (
    select
        {{ dbt_utils.generate_surrogate_key(['encounters.encounter_id', "coalesce(claims.claim_line_surrogate_id, 'UNBILLED')"]) }} as crosswalk_surrogate_id,
        encounters.encounter_id,
        encounters.encounter_surrogate_id,
        encounters.encounter_date,
        encounters.period_start,
        encounters.period_end,
        encounters.status as encounter_status,
        encounters.class_code as encounter_class,
        encounters.type_code as encounter_procedure_code,
        encounters.service_provider_npi as encounter_provider_npi,
        encounters.subject_member_id as member_id,

        claims.claim_id,
        claims.claim_line_number,
        claims.claim_line_surrogate_id,
        claims.date_of_service as claim_date_of_service,
        claims.billing_npi as claim_billing_npi,
        claims.rendering_npi as claim_rendering_npi,
        claims.procedure_code as claim_procedure_code,
        claims.primary_diagnosis_code as claim_diagnosis_code,
        claims.charge_amount,
        claims.paid_amount,
        claims.patient_due_amount,
        claims.claim_status,
        claims.paid_date,

        case
            when claims.claim_id is not null then true
            else false
        end as is_billed_claim,

        case
            when claims.claim_id is not null and encounters.type_code = claims.procedure_code then true
            else false
        end as is_procedure_matched,

        case
            when claims.paid_date is not null
            then datediff('day', encounters.encounter_date, claims.paid_date)
            else null
        end as lag_days_encounter_to_paid

    from encounters
    left join claims
        on encounters.subject_member_id = claims.member_id
       and encounters.encounter_date = claims.date_of_service
)

select * from joined
