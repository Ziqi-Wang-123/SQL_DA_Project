/*
Question: What are the most in-demand skills for data analysts?

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
 providing insights into the most valuable skills for job seekers.
 */

 SELECT sd.skills, count(jp.job_id) AS demand_count
 FROM job_postings_fact jp 
 INNER JOIN skills_job_dim sjd ON jp.job_id=sjd.job_id
 INNER JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
 WHERE jp.job_title_short= 'Data Analyst'
 GROUP BY sd.skills
 ORDER BY count(jp.job_id) DESC
 LIMIT 5;