SELECT 'Restaurants' as `Table`, COUNT(*) as `Rows` FROM zomato_restaurants
UNION ALL
SELECT 'Reviews', COUNT(*) FROM zomato_reviews;
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE zomato_reviews ADD COLUMN rating_clean DECIMAL(3,1) NULL;

UPDATE zomato_reviews
SET rating_clean = CASE
    WHEN Rating = 'Like' THEN 5.0
    WHEN Rating REGEXP '^[0-9.]+$' THEN CAST(Rating AS DECIMAL(3,1))
    ELSE NULL
END;
SELECT Rating, rating_clean, COUNT(*) 
FROM zomato_reviews 
GROUP BY Rating, rating_clean 
ORDER BY Rating;

WITH restaurant_performance AS (
SELECT
	r.Name,
	r.Cost,
    r.Cuisines,
    r.Collections,
    AVG(rev.rating_clean) as avg_rating,
    COUNT(rev.rating_clean) as total_reviews,
    MIN(rev.rating_clean) as lowest_rating,
    MAX(rev.rating_clean) as highest_rating
FROM zomato_restaurants r JOIN zomato_reviews rev ON r.Name =rev.Restaurant
GROUP BY r.Name, r.Cost, r.Cuisines, r.Collections
)
SELECT
Name,
Cost,
Cuisines,
ROUND(avg_rating,2) as avg_rating,
total_reviews,
DENSE_RANK() OVER (ORDER BY avg_rating DESC) as rating_rank
FROM restaurant_performance
ORDER BY rating_rank
LIMIT 15;

WITH stats AS(
SELECT
r.Name,
r.Cost,
r.Cuisines,
AVG(rev.rating_clean) as avg_rating,
COUNT(rev.rating_clean) as total_reviews
FROM zomato_restaurants r JOIN zomato_reviews rev ON r.Name=rev.Restaurant
GROUP BY r.Name, r.Cost, r.Cuisines
),
ranked AS(
SELECT *,
dense_rank() OVER (ORDER BY avg_rating DESC) AS overall_rank
FROM stats
),
segmented AS  (
SELECT *,
CASE
WHEN avg_rating >= 4.5 THEN 'Premium'
WHEN avg_rating >=4.0 THEN 'Good'
WHEN avg_rating >= 3.5 THEN 'Average'
ELSE 'Below Average'
END as segment
FROM ranked
)
SELECT 
segment,
COUNT(*) as restaurant_count,
ROUND(AVG(avg_rating),2) as avg_rating,
ROUND(AVG(Cost),2) as avg_cost,
ROUND(AVG(total_reviews),0) as avg_reviews_per_restaurant
FROM segmented
GROUP BY segment
ORDER BY avg_rating DESC;

create table if not exists zomato_ml_features AS 
SELECT
r.Name AS restaurant_name,
r.Cost,
r.Cuisines,
r.Collections,
r.Timings,
ROUND(avg(rev.rating_clean),2) AS avg_rating,
COUNT(rev.rating_clean) as total_reviews,
CASE
WHEN AVG(rev.rating_clean) >=4.5 THEN 'Premium'
WHEN AVG(rev.rating_clean) >=4.0 THEN 'Mid-Premium'
WHEN AVG(rev.rating_clean) >=3.5 THEN 'Standard'
ELSE 'Budget'
END as rating_segment,
CASE
WHEN r.Cost >= 1200 THEN 'High Cost'
WHEN r.Cost >=700 THEN 'Medium Cost'
ELSE 'Low Cost'
END as price_segment,
(LENGTH(r.Cuisines)-LENGTH(REPLACE(r.Cuisines,',',''))+1) as num_cuisines

FROM zomato_restaurants r
JOIN zomato_reviews rev ON r.Name = rev.Restaurant
GROUP BY r.Name, r.Cost, r.Cuisines, r.Collections, r.Timings,rev.rating_clean;

SELECT * FROM zomato_ml_features
ORDER BY avg_rating DESC,Cost DESC LIMIT 20;

SELECT
price_segment,
rating_segment,
COUNT(*) as count,
ROUND(AVG(avg_rating),2) as avg_rating,
ROUND(AVG(Cost), 2) as avg_cost
FROM zomato_ml_features
GROUP BY price_segment,rating_segment
ORDER BY avg_rating DESC;