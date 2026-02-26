-- Staging model for client data
-- Cleans and standardizes raw client data

SELECT
    "id"::INTEGER AS client_id,
    TRIM("name") AS client_name,
    LOWER(TRIM("email")) AS email,
    TRIM("address") AS address,
    TRIM("city") AS city
FROM {{ source('raw', 'fake_client') }}
