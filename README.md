# Employee Attrition Analysis Project

## 📌 Project Overview
This project analyzes **employee attrition** using SQL and visualizes insights in **Power BI**. The objective is to identify patterns in employee turnover, understand factors influencing attrition, and provide actionable recommendations for HR.

---

## 🗄️ SQL Analysis

### 1. Database Structure
The dataset has been **normalized** into multiple tables:

- **employee_details** – Basic employee info: age, gender, marital status
- **job_details** – Job-related info: department, education field, job level, job role
- **satisfaction_scores** – Ratings: environment satisfaction, job satisfaction, work-life balance
- **attrition_info** – Attrition status, monthly income, overtime, tenure

### 2. Data Population
The original dataset is loaded into the `employeeattrition` table and then split into normalized tables using `INSERT INTO … SELECT …` statements.

### 3. SQL Views
The following views were created to calculate KPIs and metrics:

- `vw_employee_attrition_kpis` – Overall employee metrics  
- `vw_attrition_by_department` – Attrition by department  
- `vw_attrition_by_educationfield` – Attrition by education field  
- `vw_attrition_by_gender` – Attrition by gender  
- `vw_attrition_by_maritalstatus` – Attrition by marital status  
- `vw_attrition_by_agegroup` – Attrition by age group  
- `vw_attrition_by_tenureband` – Attrition by tenure band  
- `vw_attrition_by_incomecategory` – Attrition by salary category  
- `vw_attrition_by_overtime` – Attrition for overtime vs non-overtime  
- `vw_attrition_by_environmentsatisfaction` – Attrition by environment satisfaction  
- `vw_attrition_by_worklifebalance` – Attrition by work-life balance

These views are used directly to power the visualizations in Power BI.

---

## 📊 Power BI Dashboard Insights

### Key Metrics
- **Total Employees:** 1,500  
- **Attrition Count:** 237  
- **Attrition Rate:** 16.1%  
- **Average Tenure:** 7 years  
- **Average Monthly Salary:** 6.5K  

### Detailed Insights
1. **Attrition by Tenure Band**  
   - Highest attrition occurs within **0–2 years** range  
   - Attrition decreases as tenure increases  
   - Long-term employees (10+ years) are least likely to leave

2. **Attrition by Age Group**  
   - Employees **<30 years** have the highest attrition  
   - Attrition decreases for ages **40–49** and **50+**

3. **Attrition by Education Field**  
   - Higher attrition in **Life Sciences** and **Medical** fields  
   - Lower attrition in **Technical** and **HR** fields

4. **Attrition by Overtime Status**  
   - Employees working overtime show higher attrition

5. **Attrition by Gender**  
   - Male employees have higher attrition (**63.2%**) than females (**36.7%**)

6. **Attrition by Income Category**  
   - Highest attrition in **Low-income** category  
   - Few high-income employees leave

7. **Attrition by Department**  
   - **Research & Development** has the largest attrition count  
   - Sales follows  
   - HR has the lowest attrition

8. **Attrition by Marital Status**  
   - **Single** employees have the highest attrition  
   - Married and divorced employees leave less frequently

9. **Attrition by Environment Satisfaction**  
   - Employees with lowest satisfaction (rating = 1) have the highest attrition  
   - Attrition decreases with better satisfaction ratings

---

## 🔍 Conclusion
Attrition is strongly influenced by **tenure, age, income, overtime, and satisfaction**. Using SQL for normalized views and Power BI for visualization provides a clear view of employee turnover trends, helping HR make **data-driven retention strategies**.

