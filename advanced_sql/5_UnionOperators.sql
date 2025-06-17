-- Get jobs and companies from January
SELECT 
	job_title_short,
	company_id,
	job_location
FROM
	january_jobs

UNION -- combine the two tables 

-- Get jobs and companies from February 
SELECT 
	job_title_short,
	company_id,
	job_location
FROM
	february_jobs;

/*

Combine result sets of two or more `SELECT` statements into a single result set. 

- `UNION`: Remove duplicate rows
- `UNION ALL`: Includes all duplicate rows

⚠️Note: Each SELECT statement within the UNION 
must have the same number of columns in the result sets with similar data types.


| Feature        | `JOIN`                          | `UNION`                                     |
| -------------- | ------------------------------- | ------------------------------------------- |
| Combines by    | Columns (side by side)          | Rows (stacked)                              |
| Used for       | Related data in multiple tables | Similar data from different tables          |
| Output shape   | Wider (more columns)            | Taller (more rows)                          |
| Duplicate rows | Possible, depending on `JOIN`   | Removed with `UNION`, kept with `UNION ALL` |

*/

-- Problem 1
/* Create a unified query that categorizes job postings into two groups: those with salary information 
(salary_year_avg or salary_hour_avg is not null) and those without it. 
Each job posting should be listed with its job_id, job_title, and an indicator of whether salary information is provided.*/

SELECT * FROM (
SELECT job_id, job_title, 
CASE WHEN salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL THEN 'Information Provided'
ELSE 'Information Not Available'
END AS salary_information
FROM job_postings_fact
)
WHERE salary_information = 'Information Provided'

UNION ALL

SELECT * FROM (
SELECT job_id, job_title, 
CASE WHEN salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL THEN 'Information Provided'
ELSE 'Information Not Available'
END AS salary_information
FROM job_postings_fact
)
WHERE salary_information = 'Information Not Available';

-- Problem 2
/*Analyze the monthly demand for skills by counting the number of job postings for each skill in the first quarter 
(January to March), utilizing data from separate tables for each month. Ensure to include skills from all job postings across these months. */

-- CTE for combining job postings from January, February, and March
WITH combined_job_postings AS (
    SELECT job_id, job_posted_date
    FROM january_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM february_jobs
    UNION ALL
    SELECT job_id, job_posted_date
    FROM march_jobs
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
    SELECT
        skills_dim.skills,  
        EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
        EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,  
        COUNT(combined_job_postings.job_id) AS postings_count 
    FROM
        combined_job_postings
    INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
    GROUP BY
        skills_dim.skills, 
        year, 
        month
)
-- Main query to display the demand for each skill during the first quarter
SELECT
    skills,  
    year,  
    month,  
    postings_count 
FROM
    monthly_skill_demand
ORDER BY
    skills, 
    year,
    month;  