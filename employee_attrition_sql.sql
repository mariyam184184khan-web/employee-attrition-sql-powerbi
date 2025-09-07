-- ======================================================
-- Drop table if it already exists
-- ======================================================

DROP TABLE IF EXISTS employeeattrition;

-- ======================================================
-- Create Employee Attrition Table
-- ======================================================

CREATE TABLE employeeattrition (
    age                     INT,
    attrition               VARCHAR(5),
    department              VARCHAR(100),
    educationfield          VARCHAR(100),
    employeenumber          INT PRIMARY KEY,
    environmentsatisfaction SMALLINT,
    gender                  VARCHAR(20),
    joblevel                SMALLINT,
    jobrole                 VARCHAR(100),
    jobsatisfaction         SMALLINT,
    maritalstatus           VARCHAR(50),
    monthlyincome           INT,
    overtime                VARCHAR(10),
    worklifebalance         SMALLINT,
    yearsatcompany          INT
);

Select * from employeeattrition Limit 5;

-- ======================================================
-- 1. Employee Basic Information
-- ======================================================
CREATE TABLE employee_details (
    employeenumber INT PRIMARY KEY,
    age INT,
    gender VARCHAR(20),
    maritalstatus VARCHAR(50)
);

-- ======================================================
-- 2. Job Related Information
-- ======================================================
CREATE TABLE job_details (
    employeenumber INT PRIMARY KEY REFERENCES employee_details(employeenumber),
    department VARCHAR(100),
    educationfield VARCHAR(100),
    joblevel SMALLINT,
    jobrole VARCHAR(100)
);

-- ======================================================
-- 3. Satisfaction Scores
-- ======================================================
CREATE TABLE satisfaction_scores (
    employeenumber INT PRIMARY KEY REFERENCES employee_details(employeenumber),
    environmentsatisfaction SMALLINT CHECK (environmentsatisfaction BETWEEN 1 AND 4),
    jobsatisfaction SMALLINT CHECK (jobsatisfaction BETWEEN 1 AND 4),
    worklifebalance SMALLINT CHECK (worklifebalance BETWEEN 1 AND 4)
);

-- ======================================================
-- 4. Attrition and Compensation
-- ======================================================
CREATE TABLE attrition_info (
    employeenumber INT PRIMARY KEY REFERENCES employee_details(employeenumber),
    attrition VARCHAR(5),
    monthlyincome INT,
    overtime VARCHAR(10),
    yearsatcompany INT
);

-- ======================================================
-- POPULATING NORMALIZED TABLES
-- ======================================================

-- Insert into Employee Details (basic info only)
INSERT INTO employee_details (employeenumber, age, gender, maritalstatus)
SELECT employeenumber, age, gender, maritalstatus
FROM employeeattrition;

-- Insert into Job Details (job-related fields)
INSERT INTO job_details (employeenumber, department, educationfield, joblevel, jobrole)
SELECT employeenumber, department, educationfield, joblevel, jobrole
FROM employeeattrition;

-- Insert into Satisfaction Scores (ratings columns only)
INSERT INTO satisfaction_scores (employeenumber, environmentsatisfaction, jobsatisfaction, worklifebalance)
SELECT employeenumber, environmentsatisfaction, jobsatisfaction, worklifebalance
FROM employeeattrition;

-- Insert into Attrition and Compensation (attrition, salary, overtime, tenure)
INSERT INTO attrition_info (employeenumber, attrition, monthlyincome, overtime, yearsatcompany)
SELECT employeenumber, attrition, monthlyincome, overtime, yearsatcompany
FROM employeeattrition;

-- ======================================================
-- View: Employee Attrition KPIs
-- This view calculates the key company-level metrics
-- ======================================================

CREATE OR REPLACE VIEW vw_employee_attrition_kpis AS
SELECT
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate,
    ROUND(AVG(ai.yearsatcompany), 2) AS avg_tenure,
    ROUND(AVG(ai.monthlyincome), 2) AS avg_monthly_income,
    ROUND(AVG(ed.age), 2) AS avg_age
FROM employee_details ed
JOIN attrition_info ai
    ON ed.employeenumber = ai.employeenumber;

-- ======================================================
-- View: Attrition by Department
-- This view calculates total employees, attrition count,
-- and attrition rate grouped by Department.
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_department AS
SELECT
    jd.department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM job_details jd
JOIN attrition_info ai
    ON jd.employeenumber = ai.employeenumber
GROUP BY jd.department
ORDER BY attrition_rate DESC;

-- ======================================================
-- View: Attrition by Education Field
-- This view calculates total employees, attrition count,
-- and attrition rate grouped by Education Field.
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_educationfield AS
SELECT
    jd.educationfield,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM job_details jd
JOIN attrition_info ai
    ON jd.employeenumber = ai.employeenumber
GROUP BY jd.educationfield
ORDER BY attrition_rate DESC;

-- ======================================================
-- View: Attrition by Gender
-- This view calculates total employees, attrition count,
-- and attrition rate grouped by Gender.
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_gender AS
SELECT
    pd.gender,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM personal_details pd
JOIN attrition_info ai
    ON pd.employeenumber = ai.employeenumber
GROUP BY pd.gender
ORDER BY attrition_rate DESC;

-- ======================================================
-- View: Attrition by Marital Status
-- Uses normalized tables: employee_details + attrition_info
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_maritalstatus AS
SELECT
    ed.maritalstatus,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM employee_details ed
JOIN attrition_info ai
    ON ed.employeenumber = ai.employeenumber
GROUP BY ed.maritalstatus
ORDER BY attrition_rate DESC;

-- ======================================================
-- View: Attrition by Age Group
-- Groups employees into age buckets and calculates attrition
-- Uses normalized tables: employee_details + attrition_info
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_agegroup AS
SELECT
    CASE
        WHEN ed.age < 30 THEN '<30'
        WHEN ed.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN ed.age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM employee_details ed
JOIN attrition_info ai
    ON ed.employeenumber = ai.employeenumber
GROUP BY age_group
ORDER BY age_group;

-- ======================================================
-- View: Attrition by Tenure Band
-- Groups employees into tenure bands and calculates attrition
-- Uses normalized tables: attrition_info + employee_details
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_tenureband AS
SELECT
    CASE
        WHEN ai.yearsatcompany BETWEEN 0 AND 2 THEN '0-2 Years'
        WHEN ai.yearsatcompany BETWEEN 3 AND 5 THEN '3-5 Years'
        WHEN ai.yearsatcompany BETWEEN 6 AND 10 THEN '6-10 Years'
        WHEN ai.yearsatcompany BETWEEN 11 AND 15 THEN '11-15 Years'
        ELSE '15+ Years'
    END AS tenure_band,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM attrition_info ai
JOIN employee_details ed
    ON ai.employeenumber = ed.employeenumber
GROUP BY tenure_band
ORDER BY tenure_band;

-- ======================================================
-- View: Attrition by Income Category
-- Groups employees into Low / Mid / High categories
-- Based on max salary = 20000
-- ======================================================

-- ======================================================
-- View: Attrition by Income Category
-- Groups employees into Low / Mid / High salary categories
-- Uses attrition_info table directly
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_incomecategory AS
SELECT
    CASE
        WHEN ai.monthlyincome < 7000 THEN 'Low'
        WHEN ai.monthlyincome BETWEEN 7000 AND 14000 THEN 'Mid'
        ELSE 'High'
    END AS income_category,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM attrition_info ai
GROUP BY income_category
ORDER BY income_category;

-- ======================================================
-- View: Attrition by Overtime
-- Groups employees by Overtime (Yes/No) and calculates attrition
-- Uses attrition_info table directly
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_overtime AS
SELECT
    ai.overtime,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM attrition_info ai
GROUP BY ai.overtime
ORDER BY attrition_rate DESC;

-- ======================================================
-- View: Attrition by Environment Satisfaction
-- Groups employees by environment satisfaction rating (1–4)
-- and calculates attrition rate
-- Uses satisfaction_scores + attrition_info
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_environmentsatisfaction AS
SELECT
    ss.environmentsatisfaction,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM satisfaction_scores ss
JOIN attrition_info ai
    ON ss.employeenumber = ai.employeenumber
GROUP BY ss.environmentsatisfaction
ORDER BY ss.environmentsatisfaction;

-- ======================================================
-- View: Attrition by Work-Life Balance
-- Groups employees by work-life balance rating (1–4)
-- and calculates attrition rate
-- Uses satisfaction_scores + attrition_info
-- ======================================================

CREATE OR REPLACE VIEW vw_attrition_by_worklifebalance AS
SELECT
    ss.worklifebalance,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END) AS total_attrition,
    ROUND( (COUNT(CASE WHEN ai.attrition = 'Yes' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2) AS attrition_rate
FROM satisfaction_scores ss
JOIN attrition_info ai
    ON ss.employeenumber = ai.employeenumber
GROUP BY ss.worklifebalance
ORDER BY ss.worklifebalance;

