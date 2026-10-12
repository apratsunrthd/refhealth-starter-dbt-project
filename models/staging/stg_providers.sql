with source as (
    select * from {{ ref('raw_providers') }}
),

renamed as (
    select
        trim(cast(npi as {{ dbt.type_string() }})) as npi,
        trim(provider_name) as provider_name,
        trim(taxonomy_code) as taxonomy_code,
        trim(provider_type) as provider_type
    from source
)

select * from renamed
