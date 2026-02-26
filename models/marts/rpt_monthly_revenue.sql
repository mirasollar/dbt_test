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
        COUNT(*) AS transaction_count,
        AVG(revenue_amount) AS avg_revenue,
        MIN(revenue_amount) AS min_revenue,
        MAX(revenue_amount) AS max_revenue
    FROM {{ ref('stg_fake_revenue') }}
    
    {% if is_incremental() %}
    WHERE revenue_date > (SELECT MAX(month) FROM {{ this }})
    {% endif %}
    
    GROUP BY 
        client_id, 
        DATE_TRUNC('month', revenue_date)
)

SELECT
    m.month,
    m.client_id,
    c.client_name,
    c.email,
    c.city,
    m.total_revenue,
    m.transaction_count,
    m.avg_revenue,
    m.min_revenue,
    m.max_revenue
FROM monthly_aggregation m
LEFT JOIN {{ ref('stg_fake_client') }} c
    ON m.client_id = c.client_id
ORDER BY m.month DESC, m.total_revenue DESC
