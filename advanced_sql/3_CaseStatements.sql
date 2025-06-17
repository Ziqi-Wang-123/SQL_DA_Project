-- CASE EXPRESSIONS
SELECT
    CASE
        WHEN column_name = 'Value1' THEN 'Description for Value1'
        WHEN column_name = 'Value2' THEN 'Description for Value2'
        ELSE 'Other' 
    END AS column_description
FROM
    table_name;

/*
- `CASE` - begins the expression
- `WHEN` - specifies the condition(s) to look at
- `THEN` - what to do when the condition is `TRUE`
- `ELSE` (optional) - provides output if none of the `WHEN`  conditions are met
- `END` - concludes the `CASE` expression      */

-- Problem 1
/*
From the job_postings_fact table, categorize the salaries from job postings that are data analyst jobs, 
and that have yearly salary information. Put salary into 3 different categories:

If the salary_year_avg is greater than or equal to $100,000, then return ‘high salary’.
If the salary_year_avg is greater than or equal to $60,000 but less than $100,000, then return ‘Standard salary.’
If the salary_year_avg is below $60,000 return ‘Low salary’.
Also, order from the highest to the lowest salaries.*/

SELECT job_id, job_title, salary_year_avg,
CASE
  WHEN salary_year_avg >= 100000 THEN 'High Salary'
  WHEN salary_year_avg < 60000 THEN 'Low Salary'
  ELSE 'Standard Salary'
END AS salary_category
From job_postings_fact
WHERE job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC;

-- Problem 2
/* Count the number of unique companies that offer work from home (WFH) versus those requiring work to be on-site. 
Use the job_postings_fact table to count and compare the distinct companies based on their WFH policy 
(job_work_from_home).*/

SELECT count(distinct company_id),
CASE WHEN job_work_from_home =False THEN 'on-site'
ELSE 'wfh'
END AS job_policy
FROM job_postings_fact
GROUP BY job_policy;

-- Problem 3
/* Write a SQL query using the job_postings_fact table that returns the following columns:

job_id
salary_year_avg
experience_level (derived using a CASE WHEN)
remote_option (derived using a CASE WHEN)
Only include rows where salary_year_avg is not null.

Instructions
Experience Level
Create a new column called experience_level based on keywords in the job_title column:
Contains "Senior" → 'Senior'
Contains "Manager" or "Lead" → 'Lead/Manager'
Contains "Junior" or "Entry" → 'Junior/Entry'
Otherwise → 'Not Specified'
Use ILIKE instead of LIKE to perform case-insensitive matching (PostgreSQL-specific).

Remote Option
Create a new column called remote_option:
If job_work_from_home is true → 'Yes'
Otherwise → 'No'
Filter and Order
Filter out rows where salary_year_avg is NULL
Order the results by job_id*/

SELECT
job_id,
salary_year_avg,
CASE
  WHEN job_title ILIKE '%Senior%' THEN  'Senior'
  WHEN job_title ILIKE '%manager%' OR job_title ILIKE '%lead%' THEN 'Lead/Manager'
  WHEN job_title ILIKE '%junior%' OR job_title ILIKE '%entry%' THEN 'Junior/Entry'
  Else 'Not Specified'
END AS experience_level,
CASE
  WHEN job_work_from_home=True THEN 'Yes'
  ELSE 'No'
  END AS remote_option
FROM job_postings_fact
WHERE salary_year_avg is NOT NULL
ORDER BY job_id;






/* ✅ LIKE vs ILIKE in SQL (especially PostgreSQL):
| Keyword | Case-Sensitive? | Example Match                                    | Notes                                                 |
| ------- | --------------- | ------------------------------------------------ | ----------------------------------------------------- |
| `LIKE`  | ✅ Yes           | `'Abc' LIKE 'A%'` → ✅<br>`'abc' LIKE 'A%'` → ❌   | Only matches if the **case matches**.                 |
| `ILIKE` | ❌ No            | `'Abc' ILIKE 'a%'` → ✅<br>`'abc' ILIKE 'A%'` → ✅ | Matches **regardless of case** (PostgreSQL-specific). |
*/
