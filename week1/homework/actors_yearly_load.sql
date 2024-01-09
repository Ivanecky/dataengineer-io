-- Query to populate the actors table one year at a time
INSERT INTO ivanecky.actors 

SELECT 
    actor,
    actor_id,
    ARRAY(
        ROW(
            film, 
            votes, 
            rating,
            film_id 
        )
    ), 
    CASE 
        WHEN AVG(rating) > 8 THEN 'star'
        WHEN AVG(rating) > 7 AND AVG(rating) <= 8 THEN 'good'
        WHEN AVG(rating) > 6 AND AVG(rating) <= 7 THEN 'average'
        WHEN AVG(rating) <= 6 THEN 'bad'
    END AS quality_class,
    1 AS is_active,
    1959 AS current_year 
FROM 
    bootcamp.actor_films
WHERE 
    year = 1959