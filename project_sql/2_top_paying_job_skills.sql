/*
Question: What are the top-paying data analyst jobs, and what skills are required?

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
helping job seekers understand which skills to develop that align with top salaries
*/

with top_paying_jobs AS (SELECT
	job_id,
	job_title,
	salary_year_avg,
    name AS company_name
FROM job_postings_fact jp
LEFT JOIN company_dim cd ON jp.company_id=cd.company_id
WHERE job_title_short = 'Data Analyst'
AND job_location = 'Anywhere'
AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10)

SELECT tp.*,
sd.skills
FROM top_paying_jobs tp 
INNER JOIN skills_job_dim sjd on tp.job_id=sjd.job_id
INNER JOIN skills_dim sd on sjd.skill_id=sd.skill_id
ORDER BY tp.salary_year_avg DESC;