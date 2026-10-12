# BRIEF - refhealth-starter-dbt-project

## What This Project Is

A production-grade, cloneable [dbt](https://www.getdbt.com/) starter repository designed for healthcare data strategy, health-tech analytics engineering, and clinical AI foundations. 

It provides an end-to-end working implementation of the **Governed Data Foundation (Layer 2)** of the [Healthcare Data AI Operating System (HDAIOS) v1.0](https://refhealth.consulting/hdaios), featuring synthetic claims, bitemporal member eligibility, provider dimensions, and pre-configured tests from [`refhealth-dbt-healthcare-checks`](https://github.com/apratsunrthd/refhealth-dbt-healthcare-checks).

## Current State

- **Build & Test Status**: 51/51 tests passing out of the box with zero configuration on DuckDB (`dbt build --profiles-dir .`).
- **Dependencies**: Uses `refhealth-dbt-healthcare-checks` v1.0.3 and `dbt_utils` v1.4.1.
- **Portability**: Verified on DuckDB; portable to Snowflake, BigQuery, Databricks, and Postgres via cross-adapter SQL dispatch.
- **Seeds**: Synthetic, zero-PHI datasets for members (`raw_members.csv`), providers (`raw_providers.csv`), and claims line items (`raw_claims.csv`).
- **Models**:
  - `stg_members` (view): Cleans member eligibility dates and bitemporal spans.
  - `stg_providers` (view): Normalizes NPI and taxonomy.
  - `stg_claims` (view): Generates composite surrogate keys and casts financial amounts.
  - `dim_members` (table): Calculates active enrollment status.
  - `dim_providers` (table): Clinician and billing facility directory.
  - `fct_claims` (table): Joins dimensions, enforces date boundaries, and calculates adjudication lag in days.
- **CI/CD**: GitHub Actions workflow (`.github/workflows/ci.yml`) runs on push and pull requests, verifying `dbt build` on Python 3.11 with DuckDB.

## Key Decisions

- **Local Execution Engine**: Selected DuckDB as default target in `profiles.yml` so any developer or agent can run the project in 30 seconds without cloud warehouse setup.
- **Zero-PHI Guarantee**: Strict synthetic data standard. All records, names, dates, and codes are fictitious and comply with zero-PHI security policies.
- **Cross-Adapter Dispatch**: Test macros utilize `adapter.dispatch` in `refhealth-dbt-healthcare-checks` for cross-database regex and date handling.

## What's Next

- Tag `v1.0.0` release on GitHub.
- Add additional clinical seeds (synthetic FHIR Encounter / Condition mapping models).
- Add synthetic SCD Type 2 snapshot example demonstrating member plan migration over time.
- Cross-link in `refhealth.consulting` site, `/llms.txt`, `/llms-full.txt`, and technical playbooks.
