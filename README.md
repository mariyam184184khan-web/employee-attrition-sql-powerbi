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

The analysis of employee attrition highlights several important trends:  

1. **Tenure is a key factor** – Employees with 0–2 years at the company are most likely to leave, while long-term employees (10+ years) are the most stable. This suggests that **early retention programs** could significantly reduce attrition.  

2. **Age influences turnover** – Younger employees (<30 years) show the highest attrition, indicating the need for strategies to **engage and retain early-career talent**.  

3. **Income and compensation matter** – Low-income employees are leaving more frequently, whereas high-income employees tend to stay. Competitive compensation and clear growth opportunities could help reduce attrition.  

4. **Overtime and work conditions impact retention** – Employees working overtime and those with lower environment satisfaction are more likely to leave. This highlights the importance of **work-life balance initiatives** and improving the work environment.  

5. **Demographic factors** – Male and single employees show higher attrition rates, while older, married, or divorced employees tend to be more stable.  

6. **Department and role-specific risks** – R&D and Sales have the highest attrition, while HR and technical roles are relatively stable. This indicates **targeted interventions** may be needed in high-risk departments.  

**Overall Insight:**  
Attrition is strongly influenced by a combination of **tenure, age, income, overtime, satisfaction, and department**. By addressing these factors, HR can implement targeted strategies to **improve retention, reduce turnover, and maintain a stable workforce**.

