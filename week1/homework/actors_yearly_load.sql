-- Query to populate the actors table one year at a time
SELECT 
    actor,
    acotr_id, 
    -- code to load films array fields
    CASE 
        WHEN 