# BRIEF - refhealth-starter-dbt-project

## What This Project Is

A production-grade, cloneable [dbt](https://www.getdbt.com/) starter repository designed for healthcare data strategy, health-tech analytics engineering, and clinical AI foundations. 

It provides an end-to-end working implementation of the **Governed Data Foundation (Layer 2)** of the [Healthcare Data AI Operating System (HDAIOS) v1.0](https://refhealth.consulting/hdaios), featuring synthetic claims, bitemporal member eligibility, provider dimensions, and pre-configured tests from [`refhealth-dbt-healthcare-checks`](https://github.com/apratsunrthd/refhealth-dbt-healthcare-checks).

## Current State

- **Build & Test Status**: 106/106 tests passing out of the box with zero configuration on DuckDB (`dbt build --profiles-dir .`).
- **Dependencies**: Uses `refhealth-dbt-healthcare-checks` v1.0.3 and `dbt_utils` v1.4.1.
- **Portability**: Verified on DuckDB; portable to Snowflake, BigQuery, Databricks, and Postgres via cross-adapter SQL dispatch.
- **Seeds**: Synthetic, zero-PHI datasets for members (`raw_members.csv`), providers (`raw_providers.csv`), claims line items (`raw_claims.csv`), monthly plan premiums (`raw_plan_premiums.csv`), and FHIR encounters (`raw_fhir_encounters.csv`).
- **Models**:
  - `stg_members` (view): Cleans member eligibility dates and bitemporal spans.
  - `stg_providers` (view): Normalizes NPI and taxonomy.
  - `stg_claims` (view): Generates composite surrogate keys and casts financial amounts.
  - `stg_plan_premiums` (view): Normalizes earned premium revenues and enrolled member months.
  - `stg_fhir_encounters` (view): Normalizes HL7 FHIR R4 Encounter resources, classes, and CPT/HCPCS types.
  - `int_encounter_claims_crosswalk` (view): Bridges clinical EHR encounters to adjudicated EDI 837 claim lines, computing procedure match flags, encounter-to-paid lag, and unbilled pipeline gaps.
  - `dim_members` (table): Calculates active enrollment status.
  - `dim_providers` (table): Clinician and billing facility directory.
  - `fct_claims` (table): Joins dimensions, enforces date boundaries, and calculates adjudication lag in days.
  - `fct_plan_monthly_metrics` (table): Computes Medical Loss Ratio (MLR), Allowed PMPM, Net Paid PMPM, Member Cost-Share Ratio, and Median/P90 claims adjudication lag.
- **CI/CD**: GitHub Actions workflow (`.github/workflows/ci.yml`) runs on push and pull requests, verifying `dbt build` on Python 3.11 with DuckDB.

## Key Decisions

- **Local Execution Engine**: Selected DuckDB as default target in `profiles.yml` so any developer or agent can run the project in 30 seconds without cloud warehouse setup.
- **Zero-PHI Guarantee**: Strict synthetic data standard. All records, names, dates, and codes are fictitious and comply with zero-PHI security policies.
- **Clinical-to-Financial Crosswalk**: Established intermediate grain connecting FHIR R4 encounters with EDI 837 billing lines, solving clinical-financial reconciliation and flagging unbilled encounters.
- **Actuarial Modeling Standards**: Built monthly plan-level metrics mart (`fct_plan_monthly_metrics`) complying with statutory ACA MLR calculation standards (`paid_amount / earned_premium`) and ANSI percentile distribution functions for claims lag.
- **Cross-Adapter Dispatch**: Test macros utilize `adapter.dispatch` in `refhealth-dbt-healthcare-checks` for cross-database regex and date handling.

## What's Next

- Add an example dbt snapshot (`snapshots/snp_member_eligibility.sql`) demonstrating how to model SCD Type 2 changes in member benefit plans over time.
- Add condition/diagnosis crosswalk model (`int_encounter_diagnosis_crosswalk.sql`) linking FHIR Condition resources to claims diagnosis codes.
- Cross-link starter repo metrics in technical articles and playbooks on `refhealth.consulting`.
