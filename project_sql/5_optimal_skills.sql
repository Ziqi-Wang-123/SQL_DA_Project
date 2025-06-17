/*
Question: What are the most optimal skills to learn 
(aka it’s in high demand and a high-paying skill) for a data analyst?)

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
offering strategic insights for career development in data analysis
*/

WITH skills_demand AS(
     SELECT 
     sd.skill_id,
     sd.skills,
     count(jp.job_id) AS demand_count
 FROM job_postings_fact jp 
 INNER JOIN skills_job_dim sjd ON jp.job_id=sjd.job_id
 INNER JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
 WHERE jp.job_title_short= 'Data Analyst'
 AND jp.salary_year_avg IS NOT NULL
 AND jp.job_work_from_home = True
 GROUP BY sd.skill_id
),

average_salary AS (
     SELECT 
     sd.skill_id,
   ROUND(AVG(jp.salary_year_avg),0) AS avg_salary
 FROM job_postings_fact jp 
 INNER JOIN skills_job_dim sjd ON jp.job_id=sjd.job_id
 INNER JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
 WHERE jp.job_title_short= 'Data Analyst'
 AND jp.salary_year_avg IS NOT NULL
 AND jp.job_work_from_home = True
 GROUP BY sd.skill_id
)

-- Return high demand and high salaries for 10 skills 

SELECT
  skills_demand.skills,
  skills_demand.demand_count,
  ROUND(average_salary.avg_salary, 2) AS avg_salary --ROUND to 2 decimals 
FROM
  skills_demand
	INNER JOIN
	  average_salary ON skills_demand.skill_id = average_salary.skill_id
-- WHERE demand_count > 10
ORDER BY
  demand_count DESC, 
	avg_salary DESC
LIMIT 10 --Limit 25
; 


-- rewriting  this same query more concisely

SELECT
   sd.skill_id,
   sd.skills,
   count(sjd.job_id) AS demand_count,
   ROUND(avg(jp.salary_year_avg),0) AS avg_salary
FROM job_postings_fact jp 
 INNER JOIN skills_job_dim sjd ON jp.job_id=sjd.job_id
 INNER JOIN skills_dim sd ON sjd.skill_id=sd.skill_id
 WHERE jp.job_title_short= 'Data Analyst'
 AND jp.salary_year_avg IS NOT NULL
 AND jp.job_work_from_home = True
GROUP BY sd.skill_id
HAVING count(sjd.job_id)>10
ORDER BY
  demand_count DESC, 
	avg_salary DESC
LIMIT 10;

/* 
selecting sd.skills in the SELECT clause 
but not including it in the GROUP BY clause

why it works here:
In postgresql,If all non-aggregated columns functionally depend on the GROUP BY columns, 
the query is allowed. 

sd.skills (skill name) functionally depends on skill_id
There is only one skill name per skill ID.

*/