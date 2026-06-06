-- ============================================================
-- BELLABEAT SMART DEVICE USAGE ANALYSIS
-- Google Data Analytics Capstone Project
-- Prepared by: Aniqa Raihana | June 2026
-- Tool: SQL Server Management Studio
-- Database: BELLABEAT
-- ============================================================

USE BELLABEAT;


-- 1: DATA OVERVIEW

-- Preview cleaned datasets
SELECT * FROM daily_activity;
SELECT * FROM hourly_steps;
SELECT * FROM sleep_day;
SELECT * FROM weight_log_info;



-- 2: KEY PERFORMANCE INDICATORS (KPIs)


-- KPI 1: Average Daily Metrics
SELECT
    AVG(TotalSteps)         AS avg_daily_steps,
    AVG(VeryActiveMinutes)  AS avg_very_active_minutes,
    AVG(SedentaryMinutes)   AS avg_sedentary_minutes,
    AVG(Calories)           AS avg_calories
FROM daily_activity;


-- KPI 2: Average Active vs Sedentary Minutes
WITH CTE AS (
    SELECT
        VeryActiveMinutes,
        FairlyActiveMinutes,
        LightlyActiveMinutes,
        SedentaryMinutes,
        (VeryActiveMinutes + FairlyActiveMinutes + 
         LightlyActiveMinutes) AS TotalActiveMinutes
    FROM daily_activity
)
SELECT
    ROUND(AVG(TotalActiveMinutes), 0)               AS avg_active_minutes,
    ROUND(AVG(SedentaryMinutes), 0)                 AS avg_sedentary_minutes,
    ROUND(AVG(TotalActiveMinutes) * 100.0 / 1440, 1) AS active_pct,
    ROUND(AVG(SedentaryMinutes) * 100.0 / 1440, 1)  AS sedentary_pct
FROM CTE;


-- KPI 3: Percentage of Days Meeting 10,000 Step Goal
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN TotalSteps >= 10000 THEN 1 ELSE 0 END)
        / COUNT(TotalSteps), 1
    ) AS pct_days_meeting_goal
FROM daily_activity;


-- KPI 4: Sleep Analysis
SELECT
    ROUND(AVG(TotalMinutesAsleep / 60.0), 1)                          AS avg_hours_asleep,
    ROUND(AVG(TotalTimeInBed / 60.0), 1)                              AS avg_hours_in_bed,
    ROUND(AVG(TotalMinutesAsleep * 100.0 / NULLIF(TotalTimeInBed,0)), 1) AS sleep_efficiency_pct,
    ROUND(AVG(TotalTimeInBed - TotalMinutesAsleep), 0)                AS avg_minutes_restless
FROM sleep_day;



-- 3: ACTIVITY ANALYSIS


-- Peak Activity by Time of Day
SELECT
    CASE
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 6  AND 11 THEN 'Morning (6am-12pm)'
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 12 AND 17 THEN 'Afternoon (12pm-6pm)'
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 18 AND 21 THEN 'Evening (6pm-10pm)'
        ELSE 'Night (10pm-6am)'
    END AS time_of_day,
    ROUND(AVG(StepTotal), 0) AS avg_steps,
    SUM(StepTotal)           AS total_steps
FROM hourly_steps
GROUP BY
    CASE
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 6  AND 11 THEN 'Morning (6am-12pm)'
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 12 AND 17 THEN 'Afternoon (12pm-6pm)'
        WHEN DATEPART(HOUR, ActivityHour) BETWEEN 18 AND 21 THEN 'Evening (6pm-10pm)'
        ELSE 'Night (10pm-6am)'
    END
ORDER BY avg_steps DESC;



-- 4: USER SEGMENTATION


-- Segment Users by Average Daily Steps
WITH CTE AS (
    SELECT
        CASE
            WHEN AVG(TotalSteps) < 5000  THEN 'Sedentary'
            WHEN AVG(TotalSteps) < 7500  THEN 'Lightly Active'
            WHEN AVG(TotalSteps) < 10000 THEN 'Fairly Active'
            ELSE 'Very Active'
        END AS activity_level
    FROM daily_activity
    GROUP BY Id
)
SELECT
    activity_level,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM CTE
GROUP BY activity_level
ORDER BY user_count DESC;



-- 5: DEVICE ENGAGEMENT ANALYSIS


-- User-Level Device Usage Rate
SELECT
    Id,
    COUNT(DISTINCT ActivityDate)                          AS days_tracked,
    62 - COUNT(DISTINCT ActivityDate)                     AS days_missed,
    ROUND(COUNT(DISTINCT ActivityDate) * 100.0 / 62, 1)  AS usage_rate_pct
FROM daily_activity
GROUP BY Id
ORDER BY days_tracked DESC;


-- Engagement Level Summary
WITH user_usage AS (
    SELECT
        Id,
        COUNT(DISTINCT ActivityDate) AS days_tracked,
        COUNT(DISTINCT ActivityDate) * 100.0 / 62 AS usage_rate_pct,
        MIN(ActivityDate) AS first_day,
        MAX(ActivityDate) AS last_day
    FROM daily_activity
    GROUP BY Id
),
categorized AS (
    SELECT
        Id,
        days_tracked,
        ROUND(usage_rate_pct, 1) AS usage_rate_pct,
        first_day,
        last_day,
        CASE
            WHEN usage_rate_pct >= 75 THEN 'High Engagement'
            WHEN usage_rate_pct >= 50 THEN 'Moderate Engagement'
            ELSE 'Low Engagement'
        END AS engagement_level
    FROM user_usage
)
SELECT
    engagement_level,
    COUNT(*) AS users,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM categorized
GROUP BY engagement_level
ORDER BY users DESC;


-- 6: SLEEP VS ACTIVITY RELATIONSHIP

-- Average Steps vs Average Sleep Per User
SELECT
    da.Id,
    ROUND(AVG(da.TotalSteps), 0)           AS avg_steps,
    ROUND(AVG(sd.TotalMinutesAsleep / 60.0), 1) AS avg_hours_asleep
FROM daily_activity da
JOIN sleep_day sd ON da.Id = sd.Id
GROUP BY da.Id
ORDER BY avg_steps DESC;


-- 7: BMI & WEIGHT ANALYSIS

-- BMI Category Distribution
SELECT
    CASE
        WHEN BMI < 18.5              THEN 'Underweight'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal'
        WHEN BMI BETWEEN 25 AND 29.9   THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage,
    ROUND(AVG(BMI), 1) AS avg_bmi
FROM weight_log_info
GROUP BY
    CASE
        WHEN BMI < 18.5              THEN 'Underweight'
        WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal'
        WHEN BMI BETWEEN 25 AND 29.9   THEN 'Overweight'
        ELSE 'Obese'
    END
ORDER BY user_count DESC;


-- SECTION 8: KPI SUMMARY TABLE


SELECT 'Avg Daily Steps'    AS metric, 8078 AS actual_value, 10000 AS benchmark, 'Steps' AS unit
UNION ALL
SELECT 'Sedentary Time %',  66,   60,  '%'
UNION ALL
SELECT 'Step Goal Met %',   34,   100, '%'
UNION ALL
SELECT 'Avg Sleep Hours',   7,    8,   'Hours'
UNION ALL
SELECT 'Sleep Efficiency %',92,   85,  '%'
UNION ALL
SELECT 'Restless Minutes',  39,   30,  'Minutes'
UNION ALL
SELECT 'High Engagement %', 9,    100, '%'
UNION ALL
SELECT 'Overweight/Obese %',48,   0,   '%';



-- END OF ANALYSIS
