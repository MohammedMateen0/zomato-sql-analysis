
WITH locality_stats AS (
    SELECT *,
           AVG(rating) OVER (PARTITION BY locality) AS avg_locality_rating,
           COUNT(*)    OVER (PARTITION BY locality) AS locality_count
    FROM zomato_restaurants
),
above_average AS (
    SELECT *
    FROM locality_stats
    WHERE rating > avg_locality_rating
)
SELECT name, locality, rating, ROUND(avg_locality_rating, 2) as avg_locality_rating
FROM above_average
ORDER BY locality, rating DESC;


WITH monthly_orders AS (
    SELECT
        locality,
        TO_CHAR(order_date, 'YYYY-MM') AS month,
        SUM(order_count) AS total_orders
    FROM daily_orders
    GROUP BY locality, TO_CHAR(order_date, 'YYYY-MM')
),
mom_growth AS (
    SELECT
        locality,
        month,
        total_orders,
        LAG(total_orders) OVER (PARTITION BY locality ORDER BY month) AS prev_month_orders,
        ROUND(100.0 * (total_orders - LAG(total_orders) OVER (PARTITION BY locality ORDER BY month)) 
              / NULLIF(LAG(total_orders) OVER (PARTITION BY locality ORDER BY month), 0), 2) AS growth_pct
    FROM monthly_orders
),
high_growth_localities AS (
    SELECT DISTINCT locality
    FROM mom_growth
    WHERE growth_pct > 20
),
high_rating_localities AS (
    SELECT locality, ROUND(AVG(rating), 2) AS avg_rating
    FROM zomato_restaurants
    GROUP BY locality
    HAVING AVG(rating) > 4.0
)
SELECT 
    h.locality, 
    h.avg_rating,
    'High Growth + High Rating' as category
FROM high_rating_localities h
INNER JOIN high_growth_localities g ON h.locality = g.locality
ORDER BY h.avg_rating DESC;


WITH cuisine_ratings AS (
    SELECT
        locality,
        cuisine,
        ROUND(AVG(rating), 2) AS avg_rating,
        COUNT(*) AS restaurant_count,
        DENSE_RANK() OVER (
            PARTITION BY locality 
            ORDER BY AVG(rating) DESC
        ) AS cuisine_rank
    FROM zomato_restaurants
    GROUP BY locality, cuisine
)
SELECT locality, cuisine, avg_rating, restaurant_count, cuisine_rank
FROM cuisine_ratings
WHERE cuisine_rank <= 2
ORDER BY locality, cuisine_rank;


WITH ranked AS (
    SELECT
        name,
        locality,
        rating,
        DENSE_RANK() OVER (PARTITION BY locality ORDER BY rating DESC) AS rnk
    FROM zomato_restaurants
)
SELECT name, locality, rating
FROM ranked
WHERE rnk = 3 AND locality = 'Gachibowli';


WITH dupes_ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY name, locality 
               ORDER BY id DESC
           ) AS rn
    FROM zomato_restaurants
)
SELECT * 
FROM dupes_ranked 
WHERE rn = 1;   -- Keep only the latest record for each duplicate