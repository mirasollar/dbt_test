# MSO DEV dbt Project (Proper Setup)

dbt transformation project created using Keboola CLI (`kbc dbt init`).

## Setup

This project was initialized with:
```bash
kbc dbt init
```

This created:
- `profiles.yml` - dbt profile configuration with environment variables
- `.env.local` - Snowflake workspace credentials
- Workspace: `WORKSPACE_971787851`

## Project Structure

```
dbt_test_proper/
├── profiles.yml              # dbt profile (uses env vars)
├── .env.local               # Workspace credentials (DO NOT COMMIT)
├── dbt_project.yml          # Project configuration
├── models/
│   ├── _sources/            # Auto-generated sources from CLI
│   ├── staging/             # Data cleaning layer
│   │   ├── _sources.yml     # Source definitions
│   │   ├── stg_fake_client.sql
│   │   ├── stg_fake_revenue.sql
│   │   └── _staging.yml
│   │
│   └── marts/               # Reporting layer
│       ├── rpt_monthly_revenue.sql
│       └── _marts.yml
```

## Models

### Staging Layer

**stg_fake_client**
- Cleans client data from `fake_client` table
- Trims strings, converts email to lowercase
- Type casting to appropriate data types

**stg_fake_revenue**
- Cleans revenue transaction data
- Converts date and revenue to proper types
- Filters out NULL values

### Reporting Layer

**rpt_monthly_revenue**
- Aggregates revenue by month and client
- Incremental model (adds only new months)
- Includes client details from staging
- Calculates: total, avg, min, max revenue per month

## Local Development

1. Load environment variables:
   ```bash
   source .env.local  # Linux/Mac
   # or in PowerShell:
   Get-Content .env.local | ForEach-Object { $parts = $_.Split('=',2); [System.Environment]::SetEnvironmentVariable($parts[0], $parts[1]) }
   ```

2. Run dbt:
   ```bash
   dbt deps
   dbt run
   dbt test
   ```

## Usage in Keboola

This project is connected to Keboola dbt transformation component.

**Input tables:**
- `out.c-mso_dev_dbt_test.fake_client`
- `out.c-mso_dev_dbt_test.fake_revenue`

**Output tables:**
- `mso_dev_stg_fake_client`
- `mso_dev_stg_fake_revenue`
- `mso_dev_rpt_monthly_revenue`
