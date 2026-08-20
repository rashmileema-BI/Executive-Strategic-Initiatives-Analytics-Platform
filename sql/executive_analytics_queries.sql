-- =========================================================================
-- Executive Strategic Initiatives Analytics Platform
-- Database: Strategic_Initiatives_DB
-- Author: Rashmi Leema
-- =========================================================================

-- 1. Create Staging Table for Ingestion
CREATE TABLE Action_Log_Raw (
    Initiative_ID VARCHAR(50),
    Initiative_Name VARCHAR(255),
    Business_Function VARCHAR(100),
    Owner_Name VARCHAR(100),
    Start_Date DATE,
    Target_Date DATE,
    Completion_Pct INT,
    Budget_Allocated DECIMAL(18,2),
    Budget_Spent DECIMAL(18,2),
    Risk_Level VARCHAR(50),
    Dependencies_Count INT
);

-- 2. ETL Transformation & KPI Engineering Layer
CREATE OR ALTER VIEW vw_Action_Log_Clean AS
SELECT 
    Initiative_ID,
    Initiative_Name,
    UPPER(TRIM(Business_Function)) AS Business_Function,
    Owner_Name,
    Start_Date,
    Target_Date,
    Completion_Pct,
    Budget_Allocated,
    Budget_Spent,
    (Budget_Spent - Budget_Allocated) AS Budget_Variance,
    Risk_Level,
    Dependencies_Count,
    -- KPI Metric: Days Remaining or Overdue Duration
    DATEDIFF(day, CAST(GETDATE() AS DATE), Target_Date) AS Days_Remaining,
    -- Escalation Status Logic
    CASE 
        WHEN Completion_Pct < 50 AND DATEDIFF(day, CAST(GETDATE() AS DATE), Target_Date) <= 14 THEN 'Escalated'
        WHEN Risk_Level = 'High' AND Completion_Pct < 80 THEN 'Escalated'
        ELSE 'Normal'
    END AS Escalation_Status,
    -- Project Health Categorization
    CASE 
        WHEN DATEDIFF(day, CAST(GETDATE() AS DATE), Target_Date) < 0 AND Completion_Pct < 100 THEN 'Delayed'
        WHEN Completion_Pct < 50 AND DATEDIFF(day, CAST(GETDATE() AS DATE), Target_Date) <= 14 THEN 'Critical'
        WHEN Completion_Pct < 80 AND DATEDIFF(day, CAST(GETDATE() AS DATE), Target_Date) <= 30 THEN 'At Risk'
        ELSE 'On Track'
    END AS Project_Health
FROM Action_Log_Raw;
GO

-- 3. Executive KPI: Department Performance & Ranking
SELECT
    Business_Function,
    COUNT(Initiative_ID) AS Total_Initiatives,
    AVG(Completion_Pct) AS Avg_Completion_Pct,
    SUM(CASE WHEN Escalation_Status = 'Escalated' THEN 1 ELSE 0 END) AS Escalated_Count,
    SUM(CASE WHEN Project_Health = 'Delayed' THEN 1 ELSE 0 END) AS Delayed_Count,
    SUM(Budget_Allocated) AS Total_Budget,
    SUM(Budget_Spent) AS Total_Spend,
    RANK() OVER(ORDER BY AVG(Completion_Pct) DESC) AS Performance_Rank
FROM vw_Action_Log_Clean
GROUP BY Business_Function;
GO

-- 4. Risk Identification: High-Risk Initiatives with Dependencies
WITH RiskSummary AS (
    SELECT 
        Initiative_ID,
        Initiative_Name,
        Business_Function,
        Owner_Name,
        Completion_Pct,
        Days_Remaining,
        Dependencies_Count,
        Risk_Level,
        DENSE_RANK() OVER (PARTITION BY Business_Function ORDER BY Dependencies_Count DESC) AS Dep_Rank
    FROM vw_Action_Log_Clean
    WHERE Escalation_Status = 'Escalated'
)
SELECT * 
FROM RiskSummary 
WHERE Dep_Rank <= 3;
