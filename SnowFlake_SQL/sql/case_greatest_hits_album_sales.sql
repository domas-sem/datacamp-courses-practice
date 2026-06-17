-- Purpose: Analyze total sales driven by "Greatest Hits" albums.
-- Context: Snowflake SQL practice using CTEs and CASE expressions to flag specific album types.
-- Skills: Common Table Expressions (CTEs), CASE expression, string matching with ILIKE, joins, aggregation.

WITH album_map AS (
    -- Combine albums with artists and flag "Greatest Hits" albums
    SELECT
        al.album_id,
        al.title AS album_name,
        ar.name AS artist_name,
        CASE
            WHEN al.title ILIKE '%greatest%' THEN TRUE
            ELSE FALSE
        END AS is_greatest_hits
    FROM store.album AS al
    JOIN store.artist AS ar
        ON al.artist_id = ar.artist_id
),
trimmed_invoicelines AS (
    -- Keep only the columns needed for album-level revenue analysis
    SELECT
        il.invoice_id,
        tr.album_id,
        inv.total
    FROM store.invoiceline AS il
    LEFT JOIN store.invoice AS inv
        ON il.invoice_id = inv.invoice_id
    LEFT JOIN store.track AS tr
        ON il.track_id = tr.track_id
)

SELECT
    am.album_name,
    am.artist_name,
    SUM(ti.total) AS total_sales_driven
FROM trimmed_invoicelines AS ti
JOIN album_map AS am
    ON ti.album_id = am.album_id
-- Focus only on albums flagged as "Greatest Hits"
WHERE am.is_greatest_hits = TRUE
GROUP BY
    am.album_name,
    am.artist_name
ORDER BY
    total_sales_driven DESC;