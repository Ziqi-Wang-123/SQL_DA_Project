
/* 
Questions: what are the top-paying data analyst jobs?
- Identify the top highest-paying Data Analyst roles that are available remotely.
- Focus on job postings with specified salaries (remove nulls).
- why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/

SELECT
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name AS company_name
FROM job_postings_fact jp
LEFT JOIN company_dim cd ON jp.company_id=cd.company_id
WHERE job_title_short = 'Data Analyst'
AND job_location = 'Anywhere'
AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;