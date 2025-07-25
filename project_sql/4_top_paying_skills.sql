/*
Questions: What are the top skills based on salary?

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts 
and helps identify the most financially rewarding skills to acquire or improve.
*/


 SELECT sd.skills, 
   ROUND(AVG(jp.salary_year_avg),0) AS avg_salary
 FROM job_postings_fact jp 
 INNER JOIN skills_job_dim sjd ON jp.job_id=sjd.job_id
 INNER JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
 WHERE jp.job_title_short= 'Data Analyst'
 AND jp.salary_year_avg IS NOT NULL
 GROUP BY sd.skills
 ORDER BY avg_salary DESC;