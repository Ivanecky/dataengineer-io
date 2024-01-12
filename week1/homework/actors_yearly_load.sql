-- Query to populate the actors table one year at a time
INSERT INTO ivanecky.actors 

-- Get data for current year
WITH current_yr AS (
    SELECT 
        actor,
        actor_id,
        ARRAY_AGG(
            ROW(
                film, 
                votes, 
                rating,
                film_id,
                year 
            )
        ) AS films, 
        CASE 
            WHEN AVG(rating) > 8 THEN 'star'
            WHEN AVG(rating) > 7 AND AVG(rating) <= 8 THEN 'good'
            WHEN AVG(rating) > 6 AND AVG(rating) <= 7 THEN 'average'
            WHEN AVG(rating) <= 6 THEN 'bad'
        END AS quality_class,
        true AS is_active,
        year AS current_year 
    FROM 
        bootcamp.actor_films
    WHERE 
        year = 1914
    GROUP BY 
        actor,
        actor_id,
        year
),

-- Get prior year data (or last loaded)
prior_yr AS (
    SELECT 
        *
    FROM 
        ivanecky.actors 
    WHERE 
        current_year = 1913 
)

-- Join old data with new data, including all rows for both
SELECT 
    COALESCE(cy.actor, py.actor) AS actor,
    COALESCE(cy.actor_id, py.actor_id) AS actor_id,
    CASE 
        WHEN cy.films IS NULL AND py.films IS NOT NULL THEN py.films 
        WHEN cy.films IS NOT NULL AND py.films IS NULL THEN cy.films
        WHEN cy.films IS NOT NULL AND py.films IS NOT NULL THEN CONCAT(cy.films, py.films)
    END AS films, 
    CASE 
        WHEN cy.is_active = true THEN cy.quality_class
        ELSE py.quality_class
    END AS quality_class,
    CASE 
        WHEN cy.films IS NOT NULL THEN true 
        ELSE false 
    END AS is_active,
    1914 as current_year 
FROM 
    current_yr cy 
FULL JOIN 
    prior_yr py 
ON 
    cy.actor_id = cast(py.actor_id as varchar)