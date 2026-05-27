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