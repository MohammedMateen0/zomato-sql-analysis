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


