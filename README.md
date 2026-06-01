# 🏥 Hospital Readmission Analysis — SQL Project

> SQL-based analysis of diabetic patient readmission patterns to identify high-risk profiles and care gaps using real hospital data.

---

## 📌 Project Overview

This project analyzes **87,585 diabetic patient records** from 130 US hospitals (1999–2008) to uncover the key drivers of 30-day hospital readmissions. Using structured SQL queries, I identified high-risk patient segments across age, diagnosis, medication, and discharge patterns — insights that can directly inform hospital intervention strategies.

**Business Question:** *Which patients are most likely to be readmitted within 30 days, and what clinical factors drive that risk?*

---

## 📂 Dataset

| Attribute | Details |
|-----------|---------|
| Source | [Kaggle — Diabetes 130-US Hospitals (1999–2008)](https://www.kaggle.com/datasets/brandao/diabetes) |
| Records | 87,585 patients |
| Features | 50 columns — demographics, diagnoses, medications, outcomes |
| Exclusions | `weight` and `payer_code` dropped (>90% missing values) |

---

## 🛠️ Tools Used

- **MySQL Workbench** — Query development and analysis
- **GitHub** — Version control and portfolio documentation

---

## 🔍 SQL Concepts Applied

- `GROUP BY` with aggregations (`COUNT`, `AVG`, `SUM`)
- `CASE` statements for conditional counting and rate calculation
- `HAVING` clause for filtering aggregated groups
- `DENSE_RANK()` window function for ranking diagnoses by readmission rate
- Multi-factor analysis combining demographic and clinical variables

---

## 📊 Key Findings

### 1. Age — Counterintuitive Risk
> Patients aged **20–30 have the highest readmission rate (14.73%)** — higher than elderly patients. Likely driven by irregular follow-up and lifestyle factors.

### 2. Race — Not a Strong Predictor
> Readmission rates are consistent across racial groups (9–11%), suggesting race alone is not a meaningful risk signal in this dataset.

### 3. Diagnosis — Diabetes Complications Drive Risk
> ICD-9 codes **250.6 and 250.7** (diabetic neurological and circulatory complications) show **18%+ readmission rates** — the highest among all diagnoses.

### 4. Hospital Stay Duration
> Longer hospital stays correlate with higher readmission — patients with more severe conditions stay longer and are more likely to return.

### 5. Medical Specialty
> **Hematology/Oncology (17.89%)** and **Nephrology (15.38%)** lead all specialties in readmission rate, reflecting higher patient complexity.

### 6. Medication Count
> Readmission rate rises sharply with number of medications: from **4.56% (low count) → 17.39% (high count)**. Higher medication load signals clinical complexity.

### 7. HbA1c Testing — Monitoring Gap
> Patients with **no HbA1c test recorded** show the highest readmission rate (11.43%). Lack of glucose monitoring is a clear, actionable risk factor.

### 8. Discharge Destination
> Patients discharged to **psychiatric facilities** show a **40% readmission rate** — by far the highest of any discharge category.

### 9. Insulin Management
> Changes in insulin dosage signal unstable diabetes control and correlate with higher readmission risk.

### 10. Multi-Factor High-Risk Profile
> **Young patients (20–30) with insulin dose changes** represent the single highest-risk segment at **21.56% readmission rate**.

---

## 💡 Business Impact

These findings can help hospital administrators and clinical teams:

- 🚩 Flag high-risk patients **before discharge** using multi-factor scoring
- 🩺 Prioritize **HbA1c testing** for unmonitored diabetic patients
- 💊 Monitor patients with high medication counts more closely
- 🎯 Focus intervention resources on **insulin-unstable patients aged 20–30**
- 📈 Build the foundation for a **predictive readmission risk score** using ML

---

## 📁 Repository Structure

```
sql-healthcare-analysis/
│
├── README.md               ← You are here
├── data/
│   └── dataset_info.md     ← Dataset description (raw data not uploaded due to size)
└── queries/
    ├── 01_age_analysis.sql
    ├── 02_race_analysis.sql
    ├── 03_diagnosis_analysis.sql
    ├── 04_hospital_stay.sql
    ├── 05_specialty_analysis.sql
    ├── 06_medication_count.sql
    ├── 07_hba1c_testing.sql
    ├── 08_discharge_analysis.sql
    ├── 09_insulin_analysis.sql
    └── 10_multifactor_analysis.sql
```

---

## 🚀 Next Steps

- [ ] Python EDA on the same dataset — visualizing readmission patterns
- [ ] ML model — predicting readmission probability (Logistic Regression → Random Forest)
- [ ] Dashboard — Power BI or Streamlit deployment

---

## 👤 Author

**Tofan Kumar Bhola**
[LinkedIn](https://www.linkedin.com/in/tofan-kumar-bhola) · [GitHub](https://github.com/your-username)

> *"I don't just run models — I understand the operational problems they're meant to solve."*
