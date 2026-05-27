-- Q1: Readmission rate by age group
SELECT 
    age,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_within_30,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
GROUP BY age
ORDER BY readmission_rate_pct DESC;
-- Finding: 20-30 age group has highest readmission rate (14.73%)
-- despite being younger than other high-risk groups

-- Q2: Readmission rate by race
SELECT 
    race,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_within_30,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
WHERE race NOT IN ('?', 'Unknown')
GROUP BY race
ORDER BY readmission_rate_pct DESC;
-- Finding: Readmission rates are consistent across races (9-11%)
-- Race is not a strong differentiator for readmission risk

-- Q3: Which primary diagnosis has highest readmission rate?
-- (HAVING COUNT(*) > 100 filters out rare diagnoses for reliability)
SELECT 
    diag_1,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_within_30,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
WHERE diag_1 NOT IN ('?')
GROUP BY diag_1
HAVING COUNT(*) > 100
ORDER BY readmission_rate_pct DESC
LIMIT 15;
-- Finding: Diabetes with complications (250.6, 250.7) and liver/circulatory
-- conditions show highest readmission rates (16-19%)
-- ICD-9 codes used — decoding applied manually for interpretation

-- Q4: Does longer hospital stay reduce readmission rates?
SELECT 
    time_in_hospital,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_within_30,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
GROUP BY time_in_hospital
ORDER BY time_in_hospital ASC;
-- Finding: Readmission rate increases with hospital stay length (8% at 1 day → 14.7% at 10 days)
-- Interpretation: Sicker patients stay longer AND face higher readmission risk
-- Longer stay is a symptom of severity, not a cause of readmission

-- Q5: Which medical specialties have highest readmission rates?
-- (DENSE_RANK window function used to rank specialties)
-- (HAVING COUNT(*) > 100 ensures statistical reliability)
SELECT 
    medical_specialty,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmitted_within_30,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct,
    DENSE_RANK() OVER (ORDER BY SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) DESC) AS rank_by_readmission
FROM github.diabetic_data
WHERE medical_specialty NOT IN ('?')
GROUP BY medical_specialty
HAVING COUNT(*) > 100
ORDER BY readmission_rate_pct DESC
LIMIT 10;
-- Finding: Hematology/Oncology (17.89%) and Nephrology (15.38%) lead readmissions
-- High-volume specialties like Internal Medicine manage volume with lower rates (11.35%)
-- Chronic disease specialties carry highest readmission burden

-- Q6: Do more medications correlate with higher readmission rates?
-- Q6: Do more medications correlate with higher readmission rates?

SELECT 
    num_medications,
    COUNT(*) AS total_patients,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
GROUP BY num_medications
HAVING COUNT(*) > 100
ORDER BY num_medications ASC;
-- Finding: Strong positive correlation between medication count and readmission rate
-- 1 medication: 4.56% readmission vs 35 medications: 17.39%
-- Number of medications is a strong proxy for patient complexity

-- Q7: Does HbA1c test result impact readmission rates?
SELECT 
    A1Cresult,
    COUNT(*) AS total_patients,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
GROUP BY A1Cresult
ORDER BY readmission_rate_pct DESC;
-- Finding: Patients with no HbA1c test recorded have highest readmission rate (11.43%)
-- Patients tested — even with abnormal results — show lower readmission rates (9.68-10.03%)
-- Interpretation: Lack of diabetes monitoring is itself a readmission risk factor
-- Clinical implication: Routine HbA1c testing may reduce unnecessary readmissions

-- Q8: Which discharge destination leads to highest readmission?
SELECT 
    discharge_disposition_id,
    COUNT(*) AS total_patients,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
GROUP BY discharge_disposition_id
HAVING COUNT(*) > 100
ORDER BY readmission_rate_pct DESC
LIMIT 10;
-- Finding: Psychiatric (40%) and rehab facility (27.49%) discharges have highest readmission rates
-- Patients not discharged home are already complex, high-risk cases
-- Discharge destination is a strong readmission predictor

-- Q9: Does insulin medication change impact readmission?

SELECT 
    insulin,
    COUNT(*) AS total_patients,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
GROUP BY insulin
ORDER BY readmission_rate_pct DESC;
-- Finding: Insulin dose changes (up or down) correlate with higher readmission rates
-- Down: 13.89%, Up: 13.09% vs Steady: 11.25%, No insulin: 9.99%
-- Interpretation: Insulin adjustments signal unstable diabetes control = higher readmission risk

-- Q10: Multi-factor readmission risk summary
-- Combining age, insulin change, and medication count

SELECT 
    age,
    insulin,
    ROUND(AVG(num_medications), 1) AS avg_medications,
    COUNT(*) AS total_patients,
    ROUND(SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS readmission_rate_pct
FROM github.diabetic_data
GROUP BY age, insulin
HAVING COUNT(*) > 50
ORDER BY readmission_rate_pct DESC
LIMIT 15;
-- Finding: Young patients (20-30) with insulin changes show highest readmission risk (21.56%)
-- Insulin instability is dangerous across ALL age groups
-- Higher avg medications in older groups confirms complexity increases with age
-- This multi-factor view identifies the highest-risk patient profiles in the dataset
