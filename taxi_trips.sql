--##Average Trip Distance by vendor
SELECT
vendor_id,
ROUND(AVG(trip_distance),2) AS round
FROM taxi_trips
GROUP BY vendor_id
ORDER BY 1



--##Average Speed of Driver per Trip
SELECT 
ROUND ((trip_distance / ROUND((CAST((EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime))/3600) AS NUMERIC)), 2)), 2) AS mph
FROM taxi_trips
WHERE ROUND((CAST((EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime))/3600) AS NUMERIC)), 2) != 0





--##Average Cost/Rider for Multi-Rider trips
SELECT
ROUND((SUM(total_amount) / SUM(passenger_count)), 2) AS avg_cost
FROM taxi_trips
WHERE passenger_count > 1 



--##Highest Tip % by rate code
WITH percentage_table AS (
    SELECT
    rate_code_id,
    MAX(tip_percentage) OVER (PARTITION BY rate_code_id) AS highest_tip_percentage
    FROM (
        SELECT
        rate_code_id,
        fare_amount,
        tip_amount,
        ROUND((tip_amount/fare_amount)*100, 2) AS tip_percentage
        FROM taxi_trips
        WHERE fare_amount != 0
    ) AS base
)

SELECT 
* 
FROM percentage_table
GROUP BY 1,2
ORDER BY 1









--##Show all trip info WHERE tip % was highest for its rate code
WITH base AS (
    SELECT
    *, 
    FIRST_VALUE(tip_percentage) OVER (PARTITION BY rate_code_id ORDER BY tip_percentage DESC) AS highest_tip_percentage
    FROM (
        SELECT
        *,
        ROUND((tip_amount/fare_amount)*100, 2) AS tip_percentage
        FROM taxi_trips
        WHERE fare_amount != 0
    ) AS foo
)

SELECT 
* 
FROM base 
WHERE tip_percentage = highest_tip_percentage

--##CASE WHEN
SELECT
*,
(CASE WHEN CAST(trip_distance AS NUMERIC) > 15 THEN 'Long'
     ELSE 'Short'
     END) AS duration
FROM taxi_trips
ORDER BY duration

--##Revenues by vendor by rate code
SELECT
vendor_id,
rate_code_id, 
SUM(total_amount) AS total_revenues
FROM taxi_trips
GROUP BY rate_code_id, vendor_id
ORDER BY vendor_id, total_revenues DESC

--##Trips with higher than average fare amounts
SELECT
*
FROM taxi_trips 
WHERE fare_amount > (SELECT AVG(fare_amount) FROM taxi_trips)
ORDER BY fare_amount DESC

--##Trips with a fare amount within 10pct of the average
SELECT
*
FROM taxi_trips 
WHERE fare_amount BETWEEN 
(SELECT AVG(fare_amount) * 0.90 FROM taxi_trips)
AND 
(SELECT AVG(fare_amount) * 1.10 FROM taxi_trips)
ORDER BY fare_amount DESC

--##Payment type totals
SELECT
fare_amount,
payment_type,
SUM(fare_amount) OVER (PARTITION BY payment_type) AS sum
FROM taxi_trips
ORDER BY payment_type