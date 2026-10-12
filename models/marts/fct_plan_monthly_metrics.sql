with claims as (
    select * from {{ ref('fct_claims') }}
),

plan_premiums as (
    select * from {{ ref('stg_plan_premiums') }}
),

monthly_claims as (
    select
        plan_id,
        cast({{ dbt.date_trunc('month', 'date_of_service') }} as date) as service_month,
        count(distinct claim_id) as total_claims_count,
        count(distinct member_id) as distinct_claimant_count,
        sum(charge_amount) as total_charge_amount,
        sum(paid_amount) as total_paid_amount,
        sum(patient_due_amount) as total_patient_due_amount,
        sum(total_allowed_amount) as total_allowed_amount,
        avg(adjudication_lag_days) as avg_adjudication_lag_days,
        percentile_cont(0.5) within group (order by adjudication_lag_days) as median_adjudication_lag_days,
        percentile_cont(0.9) within group (order by adjudication_lag_days) as p90_adjudication_lag_days
    from claims
    group by 
        plan_id,
        cast({{ dbt.date_trunc('month', 'date_of_service') }} as date)
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['p.plan_id', 'p.service_month']) }} as plan_month_surrogate_id,
        p.plan_id,
        p.service_month,
        p.earned_premium_amount,
        p.enrolled_member_months,
        coalesce(c.total_claims_count, 0) as total_claims_count,
        coalesce(c.distinct_claimant_count, 0) as distinct_claimant_count,
        coalesce(c.total_charge_amount, 0.0) as total_charge_amount,
        coalesce(c.total_paid_amount, 0.0) as total_paid_amount,
        coalesce(c.total_patient_due_amount, 0.0) as total_patient_due_amount,
        coalesce(c.total_allowed_amount, 0.0) as total_allowed_amount,
        -- Financial & Actuarial Core Metrics
        round(
            cast(coalesce(c.total_paid_amount, 0.0) as {{ dbt.type_float() }}) / 
            nullif(cast(p.earned_premium_amount as {{ dbt.type_float() }}), 0.0), 
            4
        ) as medical_loss_ratio,
        round(
            cast(coalesce(c.total_allowed_amount, 0.0) as {{ dbt.type_float() }}) / 
            nullif(cast(p.enrolled_member_months as {{ dbt.type_float() }}), 0.0), 
            2
        ) as allowed_pmpm,
        round(
            cast(coalesce(c.total_paid_amount, 0.0) as {{ dbt.type_float() }}) / 
            nullif(cast(p.enrolled_member_months as {{ dbt.type_float() }}), 0.0), 
            2
        ) as net_paid_pmpm,
        round(
            cast(coalesce(c.total_patient_due_amount, 0.0) as {{ dbt.type_float() }}) / 
            nullif(cast(coalesce(c.total_allowed_amount, 0.0) as {{ dbt.type_float() }}), 0.0), 
            4
        ) as member_cost_share_ratio,
        -- Operational Claims Adjudication Lag Metrics
        round(c.avg_adjudication_lag_days, 1) as avg_adjudication_lag_days,
        c.median_adjudication_lag_days,
        c.p90_adjudication_lag_days
    from plan_premiums p
    left join monthly_claims c
        on p.plan_id = c.plan_id
       and p.service_month = c.service_month
)

select * from final
