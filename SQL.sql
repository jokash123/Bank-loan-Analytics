CREATE DATABASE PROJECT1;
USE PROJECT1;
select * from finance_1;
select * from finance_2;

/*Year wise loan amount Status*/
select year(issue_d) as YEAR,
CONCAT(ROUND(sum(loan_amnt)/1000000,1),'M') as LOAN_AMOUNT 
from finance_1 
GROUP BY YEAR 
ORDER BY YEAR;

/*Grade and sub grade wise revol_bal*/
SELECT F1.GRADE,
F1.SUB_GRADE,
CONCAT(ROUND(SUM(F2.REVOL_BAL)/1000000,1),'M') AS REOL_BAL
FROM finance_1 AS F1 
JOIN 
finance_2 AS F2 
ON F1.ID=F2.ID 
GROUP BY F1.GRADE,F1.SUB_GRADE 
ORDER BY F1.GRADE;

/*Total Payment for Verified Status Vs Total Payment for Non Verified Status*/
SELECT F1.verification_status,
CONCAT(ROUND(SUM(F2.total_pymnt)/1000000,1),'M')
FROM finance_1 AS F1 
JOIN 
finance_2 AS F2 
ON F1.ID=F2.ID
WHERE F1.verification_status='Verified' OR F1.verification_status='Not Verified'
GROUP BY F1.verification_status;

/*State wise and last_credit_pull_d wise loan status*/
SELECT F1.addr_state AS STATE,
RIGHT(F2.last_credit_pull_d,4) AS YEAR,
COUNT(CASE WHEN F1.loan_status ='Fully Paid' THEN F1.loan_status END) AS "Fully Paid",
COUNT(CASE WHEN F1.loan_status ='Charged Off' THEN F1.loan_status END) AS "Charged Off",
COUNT(CASE WHEN F1.loan_status ='Current' THEN F1.loan_status END) AS "Current"
FROM finance_1 AS F1 
JOIN 
finance_2 AS F2 
ON F1.ID=F2.ID
GROUP BY STATE,YEAR
ORDER BY STATE,YEAR;

/*Home ownership Vs last payment date status*/
SELECT RIGHT(F2.last_pymnt_d,4) AS YEAR,
round(SUM(CASE WHEN F1.home_ownership ='MORTGAGE' THEN F2.last_pymnt_amnt END),2) AS "MORTGAGE",
round(SUM(CASE WHEN F1.home_ownership ='OWN' THEN F2.last_pymnt_amnt END),2) AS "OWN",
round(SUM(CASE WHEN F1.home_ownership ='RENT' THEN F2.last_pymnt_amnt END),2) AS "RENT",
round(SUM(CASE WHEN F1.home_ownership ='OTHER' THEN F2.last_pymnt_amnt END),2) AS "OTHER",
round(SUM(CASE WHEN F1.home_ownership ='NONE' THEN F2.last_pymnt_amnt END),2) AS "NONE"
FROM finance_1 AS F1
JOIN 
finance_2 AS F2
ON F1.ID=F2.ID
WHERE RIGHT(F2.last_pymnt_d,4) >=2008
GROUP BY YEAR
ORDER BY YEAR;


/*SELECT RIGHT(F2.last_pymnt_d,4) AS YEAR,
F1.home_ownership AS OWNERSHIP,
SUM(F2.last_pymnt_amnt) AS LAST_PAYMENT
FROM finance_2 AS F2
JOIN 
finance_1 AS F1 
ON F2.ID=F1.ID
WHERE RIGHT(F2.last_pymnt_d,4) >=2008
GROUP BY YEAR,OWNERSHIP
ORDER BY YEAR;*/
