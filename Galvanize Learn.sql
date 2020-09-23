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