# TODO - refhealth-starter-dbt-project

## Recently Completed

- Initialized repository architecture with DuckDB zero-setup configuration.
- Authored synthetic, zero-PHI datasets: `raw_members.csv`, `raw_providers.csv`, `raw_claims.csv`.
- Built staging models: `stg_members`, `stg_providers`, `stg_claims` (with compound surrogate key generation).
- Built marts models: `dim_members` (active coverage calculation), `dim_providers`, and `fct_claims` (adjudication lag in days and allowed amounts).
- Integrated `refhealth-dbt-healthcare-checks` v1.0.3, asserting 51/51 tests passing across surrogate grain, bitemporal dates, CMS NPI format, ICD-10 validity, CPT validity, midnight timestamp audits, and referential integrity.
- Configured GitHub Actions CI workflow in `.github/workflows/ci.yml`.
- Authored all required documentation: `README.md`, `ARCHITECTURE.md`, `BRIEF.md`, `HANDOFF.md`, `TODO.md`, and `LICENSE`.

## For Claude or Other Models

- [ ] Add an example dbt snapshot (`snapshots/snp_member_eligibility.sql`) demonstrating how to model SCD Type 2 changes in member benefit plans over time.
- [ ] Add an example semantic layer metric file (`models/metrics.yml`) calculating Medical Loss Ratio (MLR), Allowed PMPM (Per Member Per Month), and 30-Day Readmission Rate.
- [ ] Add synthetic FHIR Encounter seed and mapping model (`stg_fhir_encounters.sql`) demonstrating how to bridge FHIR resources to tabular claims dimensions.

## For Humans

- [ ] Clone and verify on team environments: `dbt build --profiles-dir .`.
- [ ] Share repository link with health-tech engineering teams seeking standard healthcare dbt modeling patterns.
- [ ] Star the repository on GitHub (`apratsunrthd/refhealth-starter-dbt-project`).
