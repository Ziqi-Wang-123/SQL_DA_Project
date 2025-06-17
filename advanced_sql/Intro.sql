/*
📌 How They Work Together
To connect to PostgreSQL using SQLTools in VS Code, you need both:
🛠️ 1. SQLTools (Core Extension)

This is the main framework or platform for SQL support in VS Code. It does not connect to any databases by itself. Instead, it provides the base features, such as:

SQL query editor with syntax highlighting and autocomplete
Connection manager UI
Query history and bookmarks
Output/results pane
Plugins system for database drivers

🧩 2. SQLTools PostgreSQL/CockroachDB (Driver Plugin)

This is a driver plugin for PostgreSQL databases (and also works for CockroachDB). It plugs into the 
SQLTools core and enables actual communication with a PostgreSQL server.

Once installed, it allows you to:

Connect to PostgreSQL databases
Run queries
Browse tables, columns, and schemas
View query results in VS Code

| Extension                    | Role                           | Required? |
| ---------------------------- | ------------------------------ | --------- |
| `SQLTools`                   | Core engine & interface        | ✅ Yes     |
| `SQLTools PostgreSQL Plugin` | Enables PostgreSQL connections | ✅ Yes     |

*/

CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

INSERT INTO job_applied 
(
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
)
VALUES (
    1,
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'
);

INSERT INTO job_applied 
(job_id, application_sent_date, custom_resume, resume_file_name, cover_letter_sent, cover_letter_file_name, status) 
VALUES
(2, '2024-02-02', FALSE, 'resume_02.pdf', FALSE, NULL, 'interview scheduled'),
(3, '2024-02-03', TRUE, 'resume_03.pdf', TRUE, 'cover_letter_03.pdf', 'ghosted'),
(4, '2024-02-04', TRUE, 'resume_04.pdf', FALSE, NULL, 'submitted'),
(5, '2024-02-05', FALSE, 'resume_05.pdf', TRUE, 'cover_letter_05.pdf', 'rejected');

SELECT * FROM job_applied;

ALTER TABLE table_name
-- ADD column_name datatype;
-- RENAME COLUMN column_name TO new_name;
-- ALTER COLUMN column_name TYPE datatype;
-- DROP COLUMN column_name;

ALTER TABLE job_applied
ADD contact  VARCHAR(50);

SELECT * FROM job_applied;
-- CONTACT COLUMN WILL BE FILLED IN WITH NULL VALUES


UPDATE job_applied 
SET contact = 'Erlich Bachman' 
WHERE job_id = 1;


UPDATE job_applied SET contact = 'Dinesh Chugtai' WHERE job_id = 2;
UPDATE job_applied SET contact = 'Bertram Gilfoyle' WHERE job_id = 3;
UPDATE job_applied SET contact = 'Jian Yang' WHERE job_id = 4;
UPDATE job_applied SET contact = 'Big Head' WHERE job_id = 5;

SELECT * FROM job_applied;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

SELECT * FROM job_applied;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN contact_name;

DROP TABLE job_applied;
