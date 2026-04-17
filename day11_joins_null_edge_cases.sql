SELECT
r.name,
r.locality,
d.order_count,
d.order_date
FROM zomato_restaurants r
INNER JOIN daily_orders d ON r.id=d.restaurant_id;


SELECT 
r.name,
r.locality,
COALESCE(d.order_count,0) as order_count,
d.order_date
FROM zomato_restaurants r
LEFT JOIN daily_orders d ON r.id=d.restaurant_id
ORDER BY r.name,d.order_date;

SELECT 
r1.name AS restaurant1,
r2.name AS restaurant2,
r1.locality,
r1.rating AS rating1,
r2.rating AS rating2,
r1.rating-r2.rating AS rating_diff
FROM zomato_restaurants r1
JOIN zomato_restaurants r2
ON r1.locality = r2.locality
AND r1.id<r2.id
WHERE r1.rating > r2.rating + 0.5;

SELECT r.name, r.locality, r.rating
FROM zomato_restaurants r
LEFT JOIN daily_orders d ON r.id = d.restaurant_id
WHERE d.restaurant_id IS NULL;

SELECT r.name,r.locality, r.rating
FROM zomato_restaurants r 
WHERE NOT EXISTS (
SELECT 1
FROM daily_orders d
WHERE d.restaurant_id =r.id);

SELECT r.name,r.locality, r.rating
FROM zomato_restaurants r
WHERE r.id NOT IN (SELECT restaurant_id FROM daily_orders);


SELECT 
    name,
    rating,
    votes,
    avg_cost,
    COALESCE(avg_cost, 500) AS cost_clean,
    NULLIF(locality, 'Gachibowli') AS locality_clean,
    CASE 
        WHEN rating IS NULL THEN 'Missing Rating'
        WHEN rating >= 4.5 THEN 'Excellent'
        WHEN rating >= 4.0 THEN 'Good'
        ELSE 'Average'
    END as rating_category
FROM zomato_restaurants;

SELECT 
    locality,
    COUNT(*) as total_rows,
    COUNT(rating) as restaurants_with_rating,
    COUNT(CASE WHEN rating >= 4.5 THEN 1 END) as premium_restaurants
FROM zomato_restaurants
GROUP BY locality;

SELECT DISTINCT 
    l.locality,
    c.cuisine
FROM (SELECT DISTINCT locality FROM zomato_restaurants) l
CROSS JOIN (SELECT DISTINCT cuisine FROM zomato_restaurants) c
ORDER BY l.locality, c.cuisine;
