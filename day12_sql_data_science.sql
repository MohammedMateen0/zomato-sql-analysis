WITH first_order AS (
SELECT restaurant_id,
locality,
DATE_TRUNC('week',MIN(order_date)) AS cohort_week
FROM daily_orders
GROUP BY restaurant_id,locality
),
cohort_data AS (
SELECT 
f.cohort_week,
DATE_TRUNC('week',d.order_date) AS activity_week,
COUNT(DISTINCT d.restaurant_id) AS active_restaurants
FROM daily_orders d
JOIN first_order f ON d.restaurant_id=f.restaurant_id
GROUP BY f.cohort_week,activity_week
)
SELECT 
cohort_week,
activity_week,
active_restaurants,
FIRST_VALUE(active_restaurants) OVER (PARTITION BY cohort_week ORDER BY activity_week) AS cohort_size,
ROUND(100.0 * active_restaurants*1.0/FIRST_VALUE(active_restaurants) OVER (PARTITION BY cohort_week ORDER BY activity_week),2) AS retention_pct
FROM cohort_data
ORDER BY cohort_week,activity_week;

WITH funnel_steps AS(
SELECT 
order_date,
locality,
COUNT(CASE WHEN order_count>0 THEN 1 END) AS step1_viewed,
COUNT(CASE WHEN order_count>=5 THEN 1 END) AS step2_ordered,
COUNT(CASE WHEN order_count >=20 THEN 1 END) AS step3_highvalue
FROM daily_orders
GROUP BY order_date,locality
)
SELECT
locality,
SUM(step1_viewed) AS total_views,
SUM(step2_ordered) AS total_orders,
SUM(step3_highvalue) AS high_value_orders,
ROUND(100.0 * SUM(step2_ordered)/NULLIF(SUM(step1_viewed),0),2) AS view_to_order_pct,
ROUND(100.0 * SUM(step3_highvalue)/NULLIF(SUM(step2_ordered),0),2)AS order_to_highvalue_pct
FROM funnel_steps
GROUP BY locality;

WITH features AS (
SELECT 
r.name,
r.locality,
r.cuisine,
r.rating,
r.votes,
r.avg_cost,

COUNT(d.order_date) AS total__order_days,
SUM(d.order_count) AS total_orders,
AVG(d.order_count) AS avg_daily_orders,
MAx(d.order_count) AS peak_orders,
MIN(d.order_count) AS min_orders,

MAX(d.order_date) - MIN(d.order_date) AS active_days,
AVG(r.rating) OVER (PARTITION BY r.locality) AS locality_avg_rating,

MAX(d.order_date) AS last_order_date,
CURRENT_DATE - MAX(d.order_date) AS days_since_last_order
FROM zomato_restaurants r
LEFT JOIN daily_orders d ON r.id =d.restaurant_id
GROUP BY r.id,r.name,r.locality,r.cuisine,r.rating,r.votes,r.avg_cost
)
SELECT  
*,
NTILE(5) OVER (ORDER BY total_orders DESC) AS order_valume_bucket,
CASE
WHEN days_since_last_order <=7 THEN 'Vary ACtive'
WHEN days_since_last_order <= 30 THEN 'ACTIVE'
ELSE 'Churned'
END AS activity_segment
FROM features
ORDER BY total_orders DESC;

WITH ordered_events AS (
SELECT
restaurant_id,
order_date,
order_count,
LAG(order_date) OVER (PARTITION BY restaurant_id ORDER BY order_date) AS prev_date
FROM daily_orders
),
sessionized AS (
SELECT 
        restaurant_id,
        order_date,
        order_count,
        SUM(
            CASE 
                WHEN (order_date - prev_date > 2) OR prev_date IS NULL 
                THEN 1 
                ELSE 0 
            END
        ) OVER (PARTITION BY restaurant_id ORDER BY order_date) AS session_id
    FROM ordered_events
)
SELECT
restaurant_id,
session_id,
MIN(order_date) AS session_start,
MAX(order_date) AS session_end,
SUM(order_count) AS session_total_orders,
COUNT(*) AS days_in_session
FROM sessionized
GROUP BY restaurant_id, session_id;

SELECT * FROM zomato_restaurants
WHERE RANDOM() <0.3;

SELECT * FROM zomato_restaurants
TABLESAMPLE BERNOULLI(20);