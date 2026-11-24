CREATE DATABASE CX_193_FINANCE_PROJECT;



/*
BASIC

1. Count total records in the dataset.
2. Find distinct investment avenues.
3. Calculate average age by gender.
4. Count number of investors for each avenue.
5. Find most preferred investment option.
6. Retrieve records where age < 30.
7. Count investors whose objective is “Safety”.
8. Display top 5 most common savings objectives.
9. Find number of investors choosing Fixed Deposits.
10. Group investors by source of information.
*/



SELECT * FROM FINANCE_DATA;


SELECT COUNT (*) AS TOTAL_RECORDS 
FROM FINANCE_DATA;


SELECT DISTINCT INVESTMENT_AVENUES FROM 
FINANCE_DATA;

SELECT GENDER, AVG(AGE) AS AVERAGE_AGE FROM
FINANCE_DATA
GROUP BY GENDER;

SELECT INVESMENT_AVENUES,COUNT(*) AS TOTAL_INVESTORS
FROM FINANCE_DATA
GROUP BY INVESTMENT_AVENUES;

SELECT INVESTMENT_AVENUES, COUNT(*) AS TOTAL_INVESTORS
FROM FINANCE_DATA
GROUP BY INVESTMENT_AVENUES ORDER BY TOTAL_INVESTORS DESC ; 

SELECT * FROM FINANCE_DATA WHERE AGE <30;

SELECT COUNT (*) AS INVESTORS 
FROM FINANCE_DATA
WHERE OBJECTIVES
ORDER BY TOTAL_COUNT DESC;


SELECT COUNT (*) AS FIXED_DEPOSITS
FROM FINANCE_DATA WHERE INVESTMENT_AVENUES= 'FIXED DEPOSITS';


SELECT SOURCE,
 COUNT(*) AS TOTAL_INVESTORS
 FROM FINANCE_DATA GROUP BY SOURCE 
 ORDER BY TOTAL_INVESTORS DESC;

 /*
 1. Group investors by age range and investment avenue.
2. Calculate percentage contribution of each avenue.
3. Compare average age for Equity vs Fixed Deposit investors.
4. Identify dominant factor influencing investment decisions.
5. Analyse purpose vs duration of investment.
6. Rank investment avenues by popularity.
7. Count investors monitoring investments frequently.
8. Find correlation between objective and avenue.
9. Identify top reason for Mutual Fund investment.
10.Create a view for long-term investors.
1. Create CTEs for investor segmentation.
2. Rank investors based on risk appetite.
3. Identify hidden trends using window functions.
4. Build view for fast reporting.
5. Detect inconsistencies between objective and avenue.
6. Perform cohort analysis based on age.
*/




SELECT * FROM FINANCE_DATA;


SELECT*
    WHEN age BETWEEN 18 AND 30 THEN '18-30'
    WHEN age BETWEEN 31 AND 45 THEN '31-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS age_range,
  investment_avenue,
  COUNT(*) AS investor_count
FROM investors
GROUP BY age_range, investment_avenue;


SELECT *
FROM investors
WHERE (objective = 'Capital Preservation' AND investment_avenue = 'Equity')
   OR (objective = 'High Growth' AND investment_avenue = 'Fixed Deposit');


 SELECT * Investment_Avenues AVG(Age) AS Average_Age
FROM Finance_Data
WHERE Investment_Avenues IN
('Equity', 'Fixed Deposit')
GROUP BY Investment_avenues;

SELECT
    Factor,
    COUNT(*) AS Total_Investors
FROM Finance_Data
GROUP BY Factor
ORDER BY Total_Investors DESC;


SELECT
    Objective,
    Duration,
    COUNT(*) AS Total_Investors
FROM Finance_Data
GROUP BY Objective, Duration
ORDER BY Objective, Total_Investors DESC;

SELECT
    Investment_Avenues,
    COUNT(*) AS Total_Investors,
    DENSE_RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS Popularity_Rank
FROM Finance_Data
GROUP BY Investment_Avenues;


SELECT
    COUNT(*) AS Frequent_Investors
FROM Finance_Data
WHERE Invest_Monitor IN ('Daily', 'Weekly');

SELECT
    Objective,
    Investment_Avenues,
    COUNT(*) AS Investor_Count
FROM Finance_Data
GROUP BY
    Objective,
    Investment_Avenues
ORDER BY
    Objective,
    Investor_Count DESC;


    SELECT TOP 1
    Reason_Mutual,
    COUNT(*) AS Total_Investors
FROM Finance_Data
GROUP BY Reason_Mutual
ORDER BY Total_Investors DESC;


CREATE VIEW Long_Term_Investors AS
SELECT *
FROM Finance_Data
WHERE Duration = 'More than 5 years';


/*
ADVANCED
1. Create CTEs for investor segmentation.
2. Ran
k investors based on risk appetite.
3. Identify hidden trends using window functions.
4. Build view for fast reporting.
5. Detect inconsistencies between objective and avenue.
6. Perform cohort analysis based on age.
*/



( SELECT
        Gender,
        Age,
        Investment_Avenues,
        CASE
            WHEN Age < 25 THEN 'Young Investor'
            WHEN Age BETWEEN 25 AND 35 THEN 'Adult Investor'
            WHEN Age BETWEEN 36 AND 50 THEN 'Middle Age Investor'
            ELSE 'Senior Investor'
        END AS Investor_Category
    FROM Finance_Data
)
SELECT
    Investor_Category,
    Investment_Avenues,
    COUNT(*) AS Total_Investors
FROM Investor_Segmentation
GROUP BY
    Investor_Category,
    Investment_Avenues
ORDER BY Total_Investors DESC;


SELECT
    Age,
    Gender,
    Risk_Appetite,
    DENSE_RANK() OVER (
        ORDER BY
        CASE
            WHEN Risk_Appetite = 'High' THEN 3
            WHEN Risk_Appetite = 'Medium' THEN 2
            WHEN Risk_Appetite = 'Low' THEN 1
            ELSE 0
        END DESC
    ) AS Risk_Rank
FROM Finance_Data;




    SELECT
        Investment_Avenues,
        COUNT(*) AS Total_Investors
    FROM Finance_Data
    GROUP BY Investment_Avenues
)
SELECT
    Investment_Avenues,
    Total_Investors,

    RANK() OVER (
        ORDER BY Total_Investors DESC
    ) AS Popularity_Rank,

    SUM(Total_Investors) OVER (
        ORDER BY Total_Investors DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS Cumulative_Investors,

    ROUND(
        Total_Investors * 100.0 /
        SUM(Total_Investors) OVER (), 2
    ) AS Percentage_Contribution

FROM Avenue_Count;


CREATE VIEW Investor_Reporting AS
SELECT
    Investment_Avenues,
    COUNT(*) AS Total_Investors,
    AVG(CAST(Age AS DECIMAL(10,2))) AS Average_Age,
    MIN(Age) AS Minimum_Age,
    MAX(Age) AS Maximum_Age
FROM Finance_Data
GROUP BY Investment_Avenues;




SELECT
    Objective,
    Investment_Avenues,
    COUNT(*) AS Total_Investors
FROM Finance_Data
WHERE
    (Objective = 'Short-term Savings'
     AND Investment_Avenues <> 'Fixed Deposit')

    OR

    (Objective = 'Retirement Planning'
     AND Investment_Avenues NOT IN
     ('Equity', 'Mutual Fund'))

    OR

    (Objective = 'Capital Appreciation'
     AND Investment_Avenues NOT IN
     ('Equity', 'Mutual Fund'))

GROUP BY
    Objective,
    Investment_Avenues
ORDER BY Total_Investors DESC;










































;


