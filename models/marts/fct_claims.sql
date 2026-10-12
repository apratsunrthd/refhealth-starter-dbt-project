with claims as (
    select * from {{ ref('stg_claims') }}
),

members as (
    select * from {{ ref('dim_members') }}
),

billing_providers as (
    select * from {{ ref('dim_providers') }}
),

final as (
    select
        c.claim_line_surrogate_id,
        c.claim_id,
        c.claim_line_number,
        c.member_id,
        m.plan_id,
        c.date_of_service,
        c.paid_date,
        datediff('day', c.date_of_service, c.paid_date) as adjudication_lag_days,
        c.billing_npi,
        bp.provider_name as billing_provider_name,
        bp.provider_type as billing_provider_type,
        c.rendering_npi,
        c.primary_diagnosis_code,
        c.procedure_code,
        c.charge_amount,
        c.paid_amount,
        c.patient_due_amount,
        (c.paid_amount + c.patient_due_amount) as total_allowed_amount,
        c.created_at,
        c.claim_status
    from claims c
    inner join members m
        on c.member_id = m.member_id
       and c.date_of_service >= m.coverage_effective_date
       and c.date_of_service <= coalesce(m.coverage_term_date, cast('2099-12-31' as date))
    left join billing_providers bp
        on c.billing_npi = bp.npi
)

select * from final
