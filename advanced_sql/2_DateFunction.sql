/* 
**Date Functions in SQL**: Used to perform operations on date and time values

- **`::DATE`:** Converts to a date format by removing the time portion
- **`AT TIME ZONE`:** Converts a timestamp to a specified time zone
- **`EXTRACT`**: Gets specific date parts (e.g., year, month, day)
*/

SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

-- 📝 **Notes:**

-- `::` - used for casting, which means converting a value from one data type to another


-- Let’s make the job_posted_date easier to read by seeing it in date format.
SELECT
	job_title_short AS title,
	job_location AS location,
	job_posted_date::DATE AS date--Format the date
FROM
	job_postings_fact
ORDER BY
    job_posted_date::DATE DESC;

/*
## ⏲️ `AT TIME ZONE`

📝 **Notes:**

- `AT TIME ZONE` - converts timestamps between different time zones
- It can be used on timestamps with or without time zone information
- Recall:
    - **TIMESTAMP**
        - A specific date and time without timezone: **`2024-02-06 15:04:05`**
        - Format: **`YYYY-MM-DD HH:MI:SS`**
    - **TIMESTAMP WITH TIME ZONE**
        - A specific date and time with time zone information: **`2024-02-06 15:04:05+00:00`**
        - Similar to **`TIMESTAMP`**, but includes time zone information
- ⚠️Note:
    - **Timestamps with Time Zone**:
        - Stored as UTC, displayed per query's or system's time zone
        - **`AT TIME ZONE`** converts UTC to the specified time zone correctly

- **Timestamps without Time Zone (our situation)**:
    - Treated as local time in PostgreSQL
    - Using **`AT TIME ZONE`** assumes the machine's time zone for conversion; specify it, or the default is UTC

        */

SELECT
    job_title_short,
    job_location,
		job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact
LIMIT 10;

/* 
## 🧬`EXTRACT`

- `EXTRACT` - gets field (e.g., year, month, day) from a date/time value */

SELECT
	job_title_short,
	job_location,
    job_posted_date::DATE AS date,
	EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
	EXTRACT(YEAR FROM job_posted_date) AS job_posted_year
FROM
	job_postings_fact
LIMIT 10;


SELECT
	COUNT(job_id) as job_posted_count,
	EXTRACT(MONTH FROM job_posted_date) as job_posted_month
FROM
	job_postings_fact
WHERE
	job_title_short = 'Data Analyst'
GROUP BY
  job_posted_month
ORDER BY
  job_posted_count DESC;

-- CREATE TABLE table_name AS ... is used to create a new table and populate it with the result of a query.
/*
✅ Use Cases
1. Quickly create a new table from an existing query
2. Back up data (e.g., CREATE TABLE backup_users AS SELECT * FROM users;)
3. Create summarized/aggregated tables for reporting or performance */

-- For January
CREATE TABLE january_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- For February
CREATE TABLE february_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- For March
CREATE TABLE march_jobs AS 
	SELECT * 
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

-- Practice 1. 
/* Find the average salary both yearly (salary_year_avg) and hourly (salary_hour_avg) for job postings 
using the job_postings_fact table that were posted after June 1, 2023. 
Group the results by job schedule type. Order by the job_schedule_type in ascending order. */

SELECT job_schedule_type,
  avg(salary_year_avg) as avg_year_salary,
  avg(salary_hour_avg) as avg_hour_salary
FROM job_postings_fact
WHERE job_posted_date::date > '2023-06-01'
GROUP BY job_schedule_type
ORDER BY job_schedule_type;

-- Problem 2
/* Count the number of job postings for each month, adjusting the job_posted_date to be in 'America/New_York' 
time zone before extracting the month. Assume the job_posted_date is stored in UTC. Group by and order by the month.*/

SELECT 
EXTRACT(MONTH from (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')) AS job_posted_month,
COUNT(job_id)
FROM job_postings_fact
GROUP BY EXTRACT(MONTH from (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'))
ORDER BY EXTRACT(MONTH from (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'));

-- Problem 3
/* Find companies (include company name) that have posted jobs offering health insurance, 
where these postings were made in the second quarter of 2023. 
Use date extraction to filter by quarter. And order by the job postings count from highest to lowest.*/

SELECT cd.name,
count(job_id)
FROM job_postings_fact jp 
INNER JOIN company_dim cd on jp.company_id=cd.company_id
WHERE 
jp.job_health_insurance = TRUE AND
EXTRACT(QUARTER FROM job_posted_date) = 2
GROUP BY cd.name
HAVING COUNT(job_id) > 0
ORDER BY count(job_id) DESC;