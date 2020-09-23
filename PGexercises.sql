--##1
SELECT * FROM members

--##2
SELECT * FROM facilities

--##3
SELECT * FROM bookings

--##4
SELECT
name,
membercost
FROM facilities

--##5
SELECT
name,
membercost
FROM facilities
WHERE membercost > 0 

--##6
SELECT
facid, 
name, 
membercost, 
monthlymaintenance
FROM facilities
WHERE membercost > 0 
AND membercost < (0.02 * monthlymaintenance)
 
--##
--##
--##
--##
--##