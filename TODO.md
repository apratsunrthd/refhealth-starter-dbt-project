# TODO - refhealth-starter-dbt-project

## Recently Completed

- Initialized repository architecture with DuckDB zero-setup configuration.
- Authored synthetic, zero-PHI datasets: `raw_members.csv`, `raw_providers.csv`, `raw_claims.csv`, and `raw_plan_premiums.csv`.
- Built staging models: `stg_members`, `stg_providers`, `stg_claims`, and `stg_plan_premiums` (with compound surrogate key generation).
- Built marts models: `dim_members` (active coverage calculation), `dim_providers`, `fct_claims` (adjudication lag in days and allowed amounts), and `fct_plan_monthly_metrics` (Medical Loss Ratio, Allowed/Net PMPM, Member Cost-Share Ratio, and Median/P90 claims adjudication turnaround lag).
- Integrated `refhealth-dbt-healthcare-checks` v1.0.3 and `dbt_utils`, asserting 106/106 tests passing across surrogate grain, bitemporal dates, CMS NPI format, ICD-10 validity, CPT validity, midnight timestamp audits, referential integrity, and accepted range bounds (MLR between 0.50 and 1.50, lag >= 0).
- Built synthetic FHIR Encounter-to-Claims Transformation Bridge (`raw_fhir_encounters.csv`, `stg_fhir_encounters.sql`, `int_encounter_claims_crosswalk.sql`) linking clinical care events to billing claim lines, auditing unbilled clinical care and procedure code alignment.
- Configured GitHub Actions CI workflow in `.github/workflows/ci.yml`.
- Authored all required documentation: `README.md`, `ARCHITECTURE.md`, `BRIEF.md`, `HANDOFF.md`, `TODO.md`, and `LICENSE`.

## For Claude or Other Models

- [ ] Add an example dbt snapshot (`snapshots/snp_member_eligibility.sql`) demonstrating how to model SCD Type 2 changes in member benefit plans over time.
- [ ] Add condition/diagnosis crosswalk model (`int_encounter_diagnosis_crosswalk.sql`) linking FHIR Condition resources to claims diagnosis codes.
- [ ] Cross-link starter repo metrics in technical articles and playbooks on `refhealth.consulting`.

## For Humans

- [ ] Clone and verify on team environments: `dbt build --profiles-dir .`.
- [ ] Share repository link with health-tech engineering teams seeking standard healthcare dbt modeling patterns.
- [ ] Star the repository on GitHub (`apratsunrthd/refhealth-starter-dbt-project`).
