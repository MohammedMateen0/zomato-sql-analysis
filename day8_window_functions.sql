SELECT
    name,
    locality,
    rating,

    ROW_NUMBER() OVER (
        ORDER BY rating DESC, name ASC
    ) AS row_num,
    -- Unique sequence, deterministic due to secondary sort

    RANK() OVER (
        ORDER BY rating DESC, name ASC
    ) AS rnk,
    -- Ties share rank, gaps exist

    DENSE_RANK() OVER (
        ORDER BY rating DESC, name ASC
    ) AS dense_rnk
    -- Ties share rank, no gaps

FROM zomato_restaurants
WHERE rating IS NOT NULL;



SELECT
    name,
    locality,
    rating,

    DENSE_RANK() OVER (
        PARTITION BY locality
        ORDER BY rating DESC, name ASC
    ) AS rank_in_locality

FROM zomato_restaurants
WHERE rating IS NOT NULL;



WITH ranked AS (
    SELECT
        name,
        locality,
        cuisine,
        rating,

        DENSE_RANK() OVER (
            PARTITION BY locality
            ORDER BY rating DESC, name ASC
        ) AS rnk

    FROM zomato_restaurants
    WHERE rating IS NOT NULL
)
SELECT *
FROM ranked
WHERE rnk <= 3;




WITH base AS (
    SELECT
        order_date,
        locality,
        order_count,

        LAG(order_count) OVER (
            PARTITION BY locality
            ORDER BY order_date
        ) AS prev_orders,

        LEAD(order_count) OVER (
            PARTITION BY locality
            ORDER BY order_date
        ) AS next_orders

    FROM daily_orders
)
SELECT
    order_date,
    locality,
    order_count,
    prev_orders,
    next_orders,

    order_count - prev_orders AS day_change,

    ROUND(
        100.0 * (order_count - prev_orders)
        / NULLIF(prev_orders, 0),
        2
    ) AS pct_change

FROM base
ORDER BY locality, order_date;



SELECT
    order_date,
    locality,
    order_count,

    -- Running Total
    SUM(order_count) OVER (
        PARTITION BY locality
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,

    -- 7-day Moving Average
    ROUND(
        AVG(order_count) OVER (
            PARTITION BY locality
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_7d,

    -- Cumulative Percentage
    ROUND(
        100.0 *
        SUM(order_count) OVER (
            PARTITION BY locality
            ORDER BY order_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        /
        SUM(order_count) OVER (PARTITION BY locality),
        2
    ) AS cumulative_pct

FROM daily_orders
ORDER BY locality, order_date;



WITH ranked AS (
    SELECT
        name,
        locality,
        rating,

        NTILE(4) OVER (
            ORDER BY rating DESC
        ) AS quartile

    FROM zomato_restaurants
    WHERE rating IS NOT NULL
)
SELECT
    name,
    locality,
    rating,
    quartile,

    CASE quartile
        WHEN 1 THEN 'Top 25%'
        WHEN 2 THEN 'Upper Mid'
        WHEN 3 THEN 'Lower Mid'
        WHEN 4 THEN 'Bottom 25%'
    END AS segment

FROM ranked;




WITH daily_activity AS (
    SELECT DISTINCT
        locality,
        order_date
    FROM daily_orders
),
numbered AS (
    SELECT
        locality,
        order_date,

        DATE_SUB(
            order_date,
            INTERVAL ROW_NUMBER() OVER (
                PARTITION BY locality
                ORDER BY order_date
            ) DAY
        ) AS grp

    FROM daily_activity
),
streaks AS (
    SELECT
        locality,
        grp,
        COUNT(*) AS streak_length,
        MIN(order_date) AS streak_start,
        MAX(order_date) AS streak_end

    FROM numbered
    GROUP BY locality, grp
)
SELECT *
FROM streaks
WHERE streak_length >= 3
ORDER BY streak_length DESC;