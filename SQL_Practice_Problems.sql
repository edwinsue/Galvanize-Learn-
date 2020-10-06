--Question #1:
DROP TABLE IF EXISTS email;

CREATE TABLE email (
    user_id VARCHAR(80),
    timestamp DATE,
    setting VARCHAR(1)
);

INSERT INTO email (user_id, timestamp, setting)
VALUES 
('Sally',	'2020-01-01',	'Y'),
('Tim',	'2020-01-03',	'N'),
('Tim',	'2020-01-02',	'Y'),
('Tim',	'2020-01-01',	'N'),
('John',	'2020-01-01',	'N');

SELECT
user_id,
MAX(CASE WHEN setting = 'Y' THEN 0 ELSE 1 END) AS setting
FROM email
GROUP BY 1
HAVING MAX(CASE WHEN setting = 'Y' THEN 0 ELSE 1 END) = 0

--Question #2:
DROP TABLE IF EXISTS preferences;

CREATE TABLE preferences (
    user_id VARCHAR(80),
    timestamp DATE,
    setting VARCHAR(1)
);

INSERT INTO preferences (user_id, timestamp, setting)
VALUES 
('Sally', '2020-01-19',	'Y'),
('Sally', '2020-01-12',	'N'),
('Sally', '2020-01-01',	'Y'),
('Tim', '020-01-04',	'N'),
('Tim', '020-01-03',	'N'),
('Tim', '020-01-02',	'Y'),
('Tim', '020-01-01',	'N'),
('John', '2020-01-17',	'N'),
('John', '2020-01-15',	'Y'),
('John', '2020-01-10',	'N'),
('John', '2020-01-01',	'Y')
;

WITH CTE AS (
	SELECT 
	*,
	LEAD(setting,1) OVER (PARTITION BY user_id ORDER BY timestamp DESC) AS previous_setting
	FROM preferences
)

SELECT 
* 
FROM CTE 
WHERE setting = 'N' AND previous_setting = 'Y'
