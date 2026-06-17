-- Purpose: Analyze total listening time per artist based on invoice line items.
-- Context: Snowflake SQL practice using CTEs to separate artist metadata and track-level sales.
-- Skills: Common Table Expressions (CTEs), JOINs, aggregation, basic time conversion (ms -> minutes).

WITH artist_info AS (
    SELECT
        al.album_id,
        ar.name AS artist_name
    FROM store.album AS al
    JOIN store.artist AS ar
        ON al.artist_id = ar.artist_id
),
track_sales AS (
    SELECT
        tr.album_id,
        tr.name AS track_name,
        tr.milliseconds / 1000 AS num_seconds
    FROM store.invoiceline AS il
    JOIN store.track AS tr
        ON il.track_id = tr.track_id
)

SELECT
    ai.artist_name,
    -- Calculate total minutes listened across all tracks for each artist
    SUM(ts.num_seconds) / 60 AS minutes_listened
FROM track_sales AS ts
JOIN artist_info AS ai
    ON ts.album_id = ai.album_id
GROUP BY
    ai.artist_name
ORDER BY
    minutes_listened DESC;