--##1
SELECT 
b.starttime
FROM bookings b 
LEFT JOIN members m ON b.memid = m.memid
WHERE m.firstname LIKE 'David' 
AND m.surname LIKE 'Farrell'
ORDER BY 1

--##2
SELECT 
firstname,
surname
FROM members 
WHERE memid IN (SELECT DISTINCT recommendedby FROM members)
ORDER BY 2

--##3
SELECT
m1.firstname AS member_first,
m1.surname AS member_last,
m2.firstname AS recommender_first,
m2.surname AS recommender_last
FROM members m1
LEFT JOIN members m2 ON m1.recommendedby = m2.memid
ORDER BY 2,1

--##4
SELECT DISTINCT
m.firstname AS firstname,
m.surname AS surname,
f.name AS name
FROM bookings b
LEFT JOIN facilities f ON b.facid = f.facid
LEFT JOIN members m ON b.memid = m.memid
WHERE f.name LIKE '%Tennis%Court%'
ORDER BY 1,2

--##5
NOT SURE IF POSSIBLE WITHOUT JOINS

--##6
SELECT
f.name AS name,
SUM(CASE WHEN memid = 0 THEN f.guestcost * b.slots
         WHEN memid != 0 THEN f.membercost * b.slots
         END) AS totalrevenue
FROM bookings b 
LEFT JOIN facilities f ON b.facid = f.facid
GROUP BY 1
HAVING SUM(CASE WHEN memid = 0 THEN f.guestcost * b.slots
                WHEN memid != 0 THEN f.membercost * b.slots
                END) < 1000
ORDER BY 2
 
--##7
SELECT 
facid,
EXTRACT(MONTH FROM starttime) AS month,
SUM(slots)
FROM bookings
WHERE EXTRACT(YEAR FROM starttime) = 2019
GROUP BY ROLLUP(1,2)
ORDER BY 1,2
