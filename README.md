# sql-healthcare-analysis
SQL analysis of hospital readmission patterns — identifying high-risk diagnoses, age groups, and care gaps using the Diabetes 130-US Hospitals dataset.
# Hospital Readmission Analysis — SQL Project

## Project Overview
SQL-based analysis of diabetic patient readmission patterns using the 
Diabetes 130-US Hospitals dataset (87,585 records).
The goal is to identify high-risk patient profiles and key factors 
driving 30-day hospital readmissions.

## Dataset
- **Source:** Kaggle — Diabetes 130-US Hospitals (1999–2008)
- **Records:** 87,585 patients
- **Columns:** 50 features including demographics, diagnoses, medications, and outcomes
- **Note:** Columns `weight` and `payer_code` excluded due to >90% missing values

## Tools Used
- MySQL Workbench
- GitHub

## Key Findings
1. **Age:** 20-30 age group has highest readmission rate (14.73%) — counterintuitively higher than elderly patients
2. **Race:** Readmission rates consistent across races (9-11%) — race is not a strong predictor
3. **Diagnosis:** Diabetes complications (ICD-9: 250.6, 250.7) show 18%+ readmission rates
4. **Hospital Stay:** Longer stays correlate with higher readmission — sicker patients stay longer and return more
5. **Specialty:** Hematology/Oncology (17.89%) and Nephrology (15.38%) lead readmission rates
6. **Medications:** Strong correlation between medication count and readmission (4.56% → 17.39%)
7. **HbA1c Testing:** Untested patients show highest readmission rate (11.43%) — lack of monitoring is a risk factor
8. **Discharge:** Psychiatric facility discharges have 40% readmission rate
9. **Insulin:** Insulin dose changes signal unstable diabetes control — higher readmission risk
10. **Multi-factor:** Young patients (20-30) with insulin changes are highest risk group (21.56%)

## SQL Concepts Used
- GROUP BY and aggregations
- CASE statements for conditional counting
- HAVING clause for filtering groups
- DENSE_RANK() window function
- Multi-factor analysis combining demographics and clinical variables

## Business Impact
These findings can help hospital administrators:
- Flag high-risk patients before discharge
- Prioritize HbA1c testing for unmonitored patients
- Focus intervention resources on insulin-unstable patients
- Build predictive readmission risk scores
