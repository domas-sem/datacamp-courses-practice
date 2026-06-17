-- Purpose: Assess data quality of track metadata by comparing composer and artist information.
-- Context: Snowflake SQL practice using CASE expressions for simple data quality rules.
-- Skills: CASE expression, NULL handling, JOINs, basic data quality categorization.

SELECT
    tr.name AS track_name,
    tr.composer,
    ar.name AS artist_name,
    CASE
        -- A track lacks detail if the composer field is missing
        WHEN tr.composer IS NULL THEN 'Track Lacks Detail'
        -- Matching artist name and composer suggests consistent metadata
        WHEN tr.composer = ar.name THEN 'Matching Artist'
        -- All other cases are treated as inconsistent metadata
        ELSE 'Inconsistent Data'
    END AS data_quality
FROM store.track AS tr
LEFT JOIN store.album AS al
    ON tr.album_id = al.album_id
LEFT JOIN store.artist AS ar
    ON al.artist_id = ar.artist_id;