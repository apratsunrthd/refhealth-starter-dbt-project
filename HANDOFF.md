# HANDOFF - refhealth-starter-dbt-project

## Fast Orientation

This is a working, production-grade dbt starter project for healthcare analytics engineering.

### Quick Commands

```bash
# 1. Install dbt DuckDB adapter (or use uv)
uv run --with dbt-duckdb dbt deps

# 2. Build models and run all tests
uv run --with dbt-duckdb dbt build --profiles-dir .

# 3. Clean target artifacts
uv run --with dbt-duckdb dbt clean
```

### File Map

- `dbt_project.yml` - Root project configuration, paths, and seed column type overrides.
- `packages.yml` - Package dependencies: `refhealth-dbt-healthcare-checks` (v1.0.3) and `dbt-labs/dbt_utils`.
- `profiles.yml` / `profiles.yml.example` - DuckDB profile configured for zero-setup local execution (`refhealth_dev.duckdb`).
- `seeds/` - Zero-PHI synthetic CSV datasets (`raw_members.csv`, `raw_providers.csv`, `raw_claims.csv`).
- `models/staging/` - Staging views cleaning types, creating surrogate keys, and running staging tests (`_staging_models.yml`).
- `models/marts/` - Dimensional and fact tables (`dim_members`, `dim_providers`, `fct_claims`, `_marts_models.yml`).
- `.github/workflows/ci.yml` - GitHub Actions CI executing `dbt build` against DuckDB.

### Conventions & Gotchas

1. **Zero-PHI Standard**: Never add real patient, clinician, or organizational PHI/PII to this repository. All seeds must remain synthetic.
2. **Regex Functions**: Use `refhealth_dbt_healthcare_checks.regexp_match` macro rather than hardcoded `regexp_like` or `regexp_matches` to maintain portability across DuckDB, Snowflake, BigQuery, and Postgres.
3. **Surrogate Grain**: Always use `dbt_utils.generate_surrogate_key` on compound keys in claims models to maintain unique row identity.
4. **Member Coverage Windows**: In fact models, always join claims to member dimensions checking `date_of_service >= coverage_effective_date and date_of_service <= coverage_term_date` to prevent assigning claims to inactive coverage periods.
