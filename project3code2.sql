use Project3;
create table jobData(
ds date,
job_id int,
actor_id int,
`event` varchar(50),
`language` varchar(100),
time_spent int,
org varchar(50)
); 
insert into jobData values ('2020-11-30',21,1001,'skip','English',15,'A'),
('2020-11-30',22,1006,'transfer','Arabic',25,'B'),
('2020-11-29',23,1003,'decision','Persian',20,'C'),
('2020-11-28',23,1005,'transfer','Persian',22,'D'),
('2020-11-28',25,1002,'decision','Hindi',11,'B'),
('2020-11-27',11,1007,'decision','French',104,'D'),
('2020-11-26',23,1004,'skip','Persian',56,'A'),
('2020-11-25',20,1003,'transfer','Italian',45,'C');

select * from jobData;

SELECT
    ds,
    AVG(time_spent) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_throughput
FROM
    jobData;
    
SELECT
    `language`,
    COUNT(*) / SUM(COUNT(*)) OVER () * 100 AS percentage_share
FROM
    jobData
WHERE
    ds >= DATE_ADD(ds, INTERVAL -30 DAY)
GROUP BY
    `language`;
    
SELECT
    job_id,
    actor_id,
    `event`,
    `language`,
    time_spent,
    org,
    ds,
    COUNT(*) AS duplicate_count
FROM
    jobData
GROUP BY
    job_id,
    actor_id,
    `event`,
    `language`,
    time_spent,
    org,
    ds
HAVING
    COUNT(*) > 1;

SELECT
  ds AS review_date,
  COUNT(*)/24 AS jobs_reviewed_per_hour
FROM
  jobData
WHERE
  ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY review_date ORDER BY review_date;





















