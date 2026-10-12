with staging as (
    select * from {{ ref('stg_providers') }}
)

select
    npi,
    provider_name,
    taxonomy_code,
    provider_type
from staging
