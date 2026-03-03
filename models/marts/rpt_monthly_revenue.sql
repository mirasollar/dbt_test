{{ config(
    materialized='incremental',
    unique_key=['month', 'client_id'],
    on_schema_change='sync_all_columns'
) }}

-- Monthly revenue report
-- Aggregates revenue by client and month with client details

WITH monthly_aggregation AS (
    SELECT
        client_id,
        DATE_TRUNC('month', revenue_date) AS month,
        SUM(revenue_amount) AS total_revenue,
        COUNT(*) AS transaction_count
    FROM {{ ref('stg_fake_revenue') }}
    
    {% if is_incremental() %}
    WHERE revenue_date > (SELECT MAX(month) FROM {{ this }})
    {% endif %}
    
    GROUP BY 
        client_id, 
        DATE_TRUNC('month', revenue_date)
)

SELECT
    m.month::DATE AS month,
    m.client_id,
    c.client_name,
    c.email,
    c.city,
    m.total_revenue::DECIMAL(10,2) AS total_revenue,
    m.transaction_count
FROM monthly_aggregation m
LEFT JOIN {{ ref('stg_fake_client') }} c
    ON m.client_id = c.client_id
ORDER BY m.month DESC, m.total_revenue DESC
