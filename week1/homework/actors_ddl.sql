-- DDL to creaate actors table 
 CREATE TABLE 
   ivanecky.actors (
    actor VARCHAR,
    actor_id VARCHAR, 
    films ARRAY(
      ROW(
         film VARCHAR, 
         votes INTEGER,
         rating DOUBLE, 
         film_id VARCHAR,
         year INTEGER
       )
    ),
    quality_class VARCHAR,
    is_active BOOLEAN,
    current_year INTEGER 
 )

 WITH (
    FORMAT = 'PARQUET',
    partitioning = ARRAY['current_year']
 )


