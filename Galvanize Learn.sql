SELECT 
ROUND ((trip_distance / ROUND((CAST((EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime))/3600) AS NUMERIC)), 2)), 2) AS mph
FROM taxi_trips
WHERE ROUND((CAST((EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime))/3600) AS NUMERIC)), 2) != 0


--## ROUND function not working for me, not due to syntax error