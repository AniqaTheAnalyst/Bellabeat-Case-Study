# Bellabeat Smart Device Usage Analysis
### Google Data Analytics Capstone Project

**Prepared by:** Aniqa Raihana  
**Completed:** June 2026  
**Tools:** SQL · Python · Tableau  
**Dataset:** [FitBit Fitness Tracker Data — Kaggle](https://www.kaggle.com/datasets/arashnic/fitbit)

---

## Overview

This is an end-to-end data analysis project completed as part of the **Google Data Analytics Professional Certificate** capstone.

The goal was to analyze FitBit smart device usage data from 35 users across 2 months to identify behavioral trends and provide data-driven marketing recommendations for **Bellabeat** — a wellness technology company that develops smart health products for women.

---

## Business Task

> Analyze smart device fitness data to understand how consumers use non-Bellabeat devices, then apply those insights to one Bellabeat product to guide marketing strategy.

**Stakeholders:** Urška Sršen (Cofounder), Sando Mur (Cofounder), Bellabeat Marketing Team

---

## Data Sources

| File | Description | Rows |
|------|-------------|------|
| dailyActivity_merged.csv | Steps, calories, active minutes per day | 1,397 |
| hourlySteps_merged.csv | Steps broken down by hour | 46,008 |
| sleepDay_merged.csv | Sleep duration and quality | 410 |
| weightLogInfo_merged.csv | Weight and BMI logs | 98 |

**Data limitations:**
- Only 35 users — small sample size
- Sleep data available for one month only (April–May 2016)
- Weight data logged by only 8 out of 35 users
- No demographic data (age, gender) available

---

## Tools Used

| Tool | Purpose |
|------|---------|
| Python (pandas, numpy) | Data loading, cleaning, combining datasets |
| SQL (SQL Server) | KPI analysis, aggregations, CTEs |
| Tableau Public | Interactive dashboard and visualizations |
| Kaggle Notebooks | Development environment |

---

## Data Cleaning Process

- Combined data from two folders (March–April and April–May 2016)
- Removed 180 duplicate rows caused by April 12 date overlap between folders
- Removed 138 rows with zero steps (device not worn)
- Fixed date formats across all tables
- Dropped unnecessary columns (Fat — 94% missing, WeightPounds, LogId)
- Verified zero null values across all cleaned datasets

---

## Key Performance Indicators

| KPI | Result | Benchmark | Status |
|-----|--------|-----------|--------|
| Average daily steps | 8,078 | 10,000 | ⚠️ Below goal |
| Sedentary time | 66% of day | <60% | ❌ Above limit |
| Days meeting step goal | 34% | 100% | ❌ Below goal |
| Average sleep hours | 7.0 hrs | 8 hrs | ⚠️ Below goal |
| Sleep efficiency | 91.6% | >85% | ✅ Above benchmark |
| Restless minutes | 39 min | <30 min | ❌ Above limit |
| High device engagement | 8.6% | — | ❌ Very low |
| Overweight/Obese users | 48% | — | ⚠️ Notable |

---

## Key Findings

**Activity**
Users average 8,078 steps per day — 19% below the recommended 10,000 step goal. Only 34% of tracked days meet the daily step target, and users spend 66% of their day sedentary.

**Peak Activity Times**
Afternoon (12pm–6pm) sees the highest activity with an average of 484 steps per hour. Evening (6pm–10pm) shows the highest intensity at 441 steps per hour despite fewer hours.

**User Segmentation**
51% of users fall into the sedentary or lightly active category, with only 22.9% classified as very active.

**Device Engagement**
Only 8.6% of users wear their device consistently (75%+ of days). 28.6% show low engagement, suggesting a significant drop-off risk.

**Sleep**
Users average 7 hours of sleep per night — 1 hour below the recommended 8 hours. Sleep efficiency is healthy at 91.6%, but users spend an average of 39 minutes restless in bed each night.

**Weight & BMI**
48% of users who logged weight data fall into the overweight or obese category, suggesting a link between sedentary behavior and weight management challenges.

---

## Recommendations To Bellabeat

Based on the analysis, the following marketing strategies are recommended for the **Bellabeat App and Leaf tracker:**

**1. Afternoon Push Notifications**
Since activity peaks in the afternoon, Bellabeat should send motivational step reminders at 11am to encourage users into their most active period.

**2. Personalized Step Challenges**
With 51% of users sedentary or lightly active, the app should offer tiered step challenges — starting at 5,000 steps for beginners and progressing to 10,000 — with streak rewards to maintain engagement.

**3. Sleep Coaching Features**
Users sleep 1 hour less than recommended and spend 39 minutes restless. Bellabeat Time watch should be marketed as a sleep improvement tool with guided wind-down routines and sleep quality scores.

**4. Re-engagement Notifications**
With only 8.6% consistently wearing their device, Bellabeat should implement automated re-engagement messages after 3 days of inactivity — "We miss you" style nudges with weekly progress summaries.

**5. Weight Management Positioning**
With 48% of users overweight or obese, Bellabeat Spring (smart water bottle) and the app should be co-marketed as a complete weight management ecosystem — combining hydration, activity, and sleep tracking.

---

## Dashboard

Built in Tableau Desktop
> 📊 Dashboard screenshot available in repository
> ![Bellabeat Dashboard](bellabeat_dashboard.png)
---

## Project Structure

```
bellabeat-case-study/
├── README.md
├── bellabeat_analysis.ipynb     ← Python cleaning notebook
├── bellabeat_analysis.sql       ← Full SQL analysis script
├── dashboard/
│   └── bellabeat_dashboard.png  ← Dashboard screenshot
└── data/
    └── (link to Kaggle dataset)
```

