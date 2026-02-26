-- Staging model for revenue data
-- Cleans and validates revenue transactions

SELECT
    id::INTEGER AS client_id,
    date::DATE AS revenue_date,
    revenue::DECIMAL(10,2) AS revenue_amount
FROM {{ source('keboola', 'fake_revenue') }}
WHERE revenue IS NOT NULL
  AND date IS NOT NULL
