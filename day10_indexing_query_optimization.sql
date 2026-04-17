
CREATE INDEX idx_locality ON zomato_restaurants(locality);
CREATE INDEX idx_rating ON zomato_restaurants(rating);
CREATE INDEX idx_locality_rating ON zomato_restaurants(locality, rating);  
CREATE INDEX idx_cuisine_locality ON zomato_restaurants(cuisine, locality);

EXPLAIN SELECT * FROM zomato_restaurants WHERE locality = 'Gachibowli';

EXPLAIN SELECT * FROM zomato_restaurants
WHERE UPPER(locality) = 'GACHIBOWLI';   

EXPLAIN SELECT * FROM zomato_restaurants
WHERE locality = 'Gachibowli'; 

EXPLAIN SELECT * FROM zomato_restaurants
WHERE cuisine LIKE '%Biryani%';

EXPLAIN SELECT * FROM zomato_restaurants
WHERE cuisine LIKE 'Biryani%';     

EXPLAIN SELECT * FROM zomato_restaurants
WHERE id = '12'; 

EXPLAIN SELECT * FROM zomato_restaurants
WHERE locality = 'Gachibowli' OR cuisine = 'Biryani';

EXPLAIN SELECT * FROM zomato_restaurants WHERE locality = 'Gachibowli'
UNION ALL
SELECT * FROM zomato_restaurants WHERE cuisine = 'Biryani'
  AND locality != 'Gachibowli';  

EXPLAIN SELECT r.name, COUNT(o.id) AS order_count
FROM zomato_restaurants r
LEFT JOIN daily_orders o ON r.id = o.restaurant_id AND o.order_date >= '2024-01-01'
WHERE r.locality = 'Banjara Hills'
  
GROUP BY r.name
ORDER BY order_count DESC;

EXPLAIN ANALYZE
SELECT locality, AVG(rating) as avg_rating, COUNT(*) as count
FROM zomato_restaurants
GROUP BY locality
HAVING COUNT(*) > 5
ORDER BY avg_rating DESC;

