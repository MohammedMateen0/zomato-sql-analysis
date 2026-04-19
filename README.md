# Zomato SQL Analysis 🚀

This repository contains my structured SQL preparation for Data Science / Analytics roles.

## Week 2: Advanced SQL

### Day 8 — Window Functions

* ROW_NUMBER, RANK, DENSE_RANK
* PARTITION BY
* LAG / LEAD
* Running Totals
* Top-N per group

### Key Learning

Window functions allow row-level analysis without collapsing data, making them essential for real-world analytics problems like ranking, trends, and cohort analysis.

## Practice Source

* LeetCode SQL 50
* Real interview patterns (Amazon, Uber)

## Goal

Build strong SQL foundations for analytics, ML feature engineering, and interview readiness.
### Day 9 — CTE + Window Functions

* Multi-step CTE pipelines
* Month-over-month growth analysis
* Top-N per group using DENSE_RANK
* Deduplication using ROW_NUMBER
* Business segmentation (high growth + high rating)

**Key Insight:**
CTEs enable readable, production-style query pipelines and are essential for filtering window function outputs.

### Day 10 — Indexing & Query Optimization

* Single and composite indexes
* EXPLAIN / EXPLAIN ANALYZE
* Functions that prevent index usage
* LIKE wildcard performance
* OR vs UNION ALL rewrites
* JOIN filter placement for LEFT JOIN correctness

**Key Insight:**
Correct SQL is not enough—efficient SQL matters in production systems.

### Day 11 — JOINs, NULLs & Edge Cases

* INNER JOIN vs LEFT JOIN behavior
* Self joins for comparisons
* Anti-joins using NOT EXISTS
* NOT IN with NULL trap
* COUNT(*) vs COUNT(column)
* CROSS JOIN combinations

**Key Insight:**
Correct joins require understanding row multiplication, NULL behavior, and result-set grain.

### Day 12 — SQL for Data Science

* Cohort retention with week indexing
* Funnel conversion metrics
* Feature engineering table for ML
* Sessionization via inactivity gaps
* Sampling techniques

**Key Insight:**
SQL is used to build analytical datasets and features that directly feed ML models and product decisions.

# 🍽️ Zomato Data Analysis — End-to-End SQL Project

## 📌 Overview

This project performs an end-to-end analysis of Zomato restaurant and review data using advanced SQL. It covers data cleaning, aggregation, ranking, segmentation, and feature engineering to extract actionable business insights.

---

## 🗂️ Dataset Summary

* **Total Restaurants:** 67
* **Total Reviews:** 10,000

The dataset provides sufficient scale for meaningful statistical analysis and pattern discovery.

---

## 🧹 Data Cleaning & Preparation

* Standardized inconsistent rating values:

  * `'Like' → 5.0`
  * Invalid values → `NULL`
* Created a clean numeric column: `rating_clean`
* Used `REGEXP` and `CAST` for validation and conversion
* Ensured reliable input for downstream analytics

---

## 📊 Key Analyses

### 🔹 1. Restaurant Performance Analysis

* Computed:

  * Average rating
  * Total number of reviews
  * Minimum and maximum ratings
* Ranked restaurants using `DENSE_RANK`
* Applied review-count filtering to remove low-sample noise

👉 **Finding:**
Top restaurants combine **high ratings with consistent review volume**

---

### 🔹 2. Segmentation Analysis

Restaurants categorized into:

#### Rating Segments:

* Premium (≥ 4.5)
* Good (4.0 – 4.49)
* Average (3.5 – 3.99)
* Below Average (< 3.5)

#### Price Segments:

* High Cost (≥ 1200)
* Medium Cost (700–1199)
* Low Cost (< 700)

👉 **Finding:**
Most restaurants fall into **Average or Below Average**, indicating strong market competition.

---

### 🔹 3. Price vs Rating Insights

| Price Segment | Rating Segment | Avg Rating |
| ------------- | -------------- | ---------- |
| Medium Cost   | Premium        | 4.95       |
| Low Cost      | Premium        | 4.94       |

👉 **Key Insight:**
Low-cost restaurants perform almost identically to medium-cost restaurants in terms of ratings.

💡 **Conclusion:**
Customer satisfaction is driven more by **value and experience** than by price.

---

### 🔹 4. Market Distribution

* Premium restaurants: **Extremely rare (only 1)**
* Majority:

  * Average + Below Average → **59 out of 67**

👉 Indicates a **highly competitive, saturated market**

---

### 🔹 5. Feature Engineering (ML-Ready Dataset)

Created: `zomato_ml_features`

Includes:

* Average rating
* Total reviews
* Cost
* Cuisine count
* Price segment
* Rating segment

👉 This dataset can be used for:

* Recommendation systems
* Rating prediction models
* Customer preference analysis

---

## 🧠 Key SQL Concepts Used

* Common Table Expressions (CTEs)
* Window Functions (`DENSE_RANK`)
* Conditional logic (`CASE`, `COALESCE`, `NULLIF`)
* Data cleaning using `REGEXP`
* Aggregations and grouping
* Feature engineering in SQL
* Join optimization and handling NULLs

---

## 📈 Key Insights

* Most restaurants operate in the **mid-quality range**
* Premium-quality restaurants are rare and hard to achieve
* **Low-cost restaurants can match premium ratings**
* High-performing restaurants maintain:

  * Strong ratings
  * High review consistency
* Price is not a reliable indicator of customer satisfaction

---

## 🧠 Business Interpretation

Customers prioritize **experience, consistency, and value for money** over pricing alone. Restaurants that deliver consistent quality can outperform more expensive competitors.

---

## 📂 Repository Structure

* `day8_window_functions.sql`
* `day9_cte_window_analytics.sql`
* `day10_indexing_query_optimization.sql`
* `day11_joins_null_edge_cases.sql`
* `day12_sql_data_science.sql`
* `zomato_end_to_end_analysis.sql`

---

## 🚀 Outcome

This project demonstrates:

* Real-world SQL analytics workflows
* End-to-end data processing (clean → analyze → interpret)
* Strong foundation for Data Analyst / Data Science roles

---

## 🔗 Next Steps

* Extend analysis with visualization tools (Power BI / Tableau)
* Build ML models using engineered features
* Perform time-based trend analysis if temporal data expands

---

**Author:** Mohammed Mateen
**Focus:** SQL • Data Analytics • Machine Learning Journey


