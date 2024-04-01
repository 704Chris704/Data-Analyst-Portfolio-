/* Assignment: This assignment looks through data of test score from
a senior class in a fictional high school.

Use SQL to answer the following questions:
1. What is the average score of each student?
2. Who are the top 10 performing students?
3. What is the distribution of genders in the data?
4. How do part time jobs and extracirricular activities affect performance?
5. How is performance affected by attendence?
6. How do weekly study hours affect academic performance?
7. Do students with different career aspriations perform better?
*/

ALTER TABLE student_project.dbo.student_scores
DROP COLUMN average_score; -- drops the average score

-- 1. What is the average score of each student?

-- adds a column titled average_score
ALTER TABLE student_project.dbo.student_scores
ADD average_score FLOAT; 

-- adds the averager score rounded to 2 decimal places under average_score
UPDATE student_project.dbo.student_scores
SET average_score = ROUND((CAST(math_score AS int) + CAST(history_score AS int) + CAST(physics_score AS int) 
                    + CAST(chemistry_score AS int) + CAST(biology_score AS int) 
                    + CAST(english_score AS int) + CAST(geography_score AS int)) / 7.0, 2); 

-- 2. Who are the top 10 performing students

-- returns the top 10 average score with names in descending order
SELECT TOP 10 id, average_score, first_name, last_name
FROM student_project.dbo.student_scores
ORDER BY average_score DESC;

--3. What is the distribution of genders in the data?

-- Shows the total amount of each gender
SELECT 
    SUM(CASE WHEN gender = 'MALE' THEN 1 ELSE 0 END) AS MALE,
    SUM(CASE WHEN gender = 'FEMALE' THEN 1 ELSE 0 END) AS FEMALE
FROM student_project.dbo.student_scores;

-- 4. How do part time jobs and extracirricular activities affect performance?

--Shows the average scores of people with and without part time jobs
SELECT 
    AVG(CASE WHEN part_time_job = 1 THEN average_score END) AS avg_with_part_time_job,
    AVG(CASE WHEN part_time_job = 0 THEN average_score END) AS avg_without_part_time_job
FROM student_project.dbo.student_scores;

-- 5. How is performance affected by attendence?

-- Shows the avaerage score organized by the amount of absent days
SELECT absence_days, AVG(average_score) AS average_score
FROM student_project.dbo.student_scores
GROUP BY absence_days
ORDER BY absence_days;

-- 6. How do weekly study hours affect academic performance?

-- Shows the average score organized by study hours
SELECT weekly_self_study_hours, AVG(average_score) AS average_score
FROM student_project.dbo.student_scores
GROUP BY weekly_self_study_hours
ORDER BY weekly_self_study_hours;

-- What is the ideal amount of study hours accoring to this dataset?
SELECT weekly_self_study_hours, AVG(average_score) AS average_score
FROM student_project.dbo.student_scores
GROUP BY weekly_self_study_hours
ORDER BY average_score DESC;

-- 7. Do students with different career aspriations perform better?

-- Shows the average score on tests organized by average test score
SELECT career_aspiration, AVG(average_score) AS average_score
FROM student_project.dbo.student_scores
GROUP BY career_aspiration
ORDER BY career_aspiration;

-- Which career aspiration had the highest average?
SELECT career_aspiration, AVG(average_score) AS average_score
FROM student_project.dbo.student_scores
GROUP BY career_aspiration
ORDER BY average_score DESC;
