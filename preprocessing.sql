USE udemy;

-- Check data type and character length of columns
SELECT column_name, data_type, 
    CASE
        WHEN data_type LIKE 'char%' THEN character_maximum_length
        WHEN data_type LIKE 'varchar%' THEN character_maximum_length
        WHEN data_type LIKE 'binary%' THEN character_maximum_length
        WHEN data_type LIKE 'varbinary%' THEN character_maximum_length
        WHEN data_type LIKE 'numeric%' THEN CONCAT(numeric_precision, ',', numeric_scale)
        WHEN data_type LIKE 'decimal%' THEN CONCAT(numeric_precision, ',', numeric_scale)
        WHEN data_type LIKE 'datetime%' THEN datetime_precision
        ELSE ''
    END AS size
FROM information_schema.columns
WHERE table_name = 'business_courses';


-- Change data type of table
ALTER TABLE business_courses
ALTER COLUMN course_id VARCHAR(500);

ALTER TABLE business_courses
ALTER COLUMN course_title VARCHAR(500);

ALTER TABLE business_courses
ALTER COLUMN price NUMERIC(10,2);

ALTER TABLE business_courses
ALTER COLUMN free_or_paid VARCHAR(50);

ALTER TABLE business_courses
ALTER COLUMN num_subscribers INT;

ALTER TABLE business_courses
ALTER COLUMN num_reviews INT;

ALTER TABLE business_courses
ALTER COLUMN num_lectures INT;

ALTER TABLE business_courses
ALTER COLUMN level VARCHAR(500);

ALTER TABLE business_courses
ALTER COLUMN Rating NUMERIC(10,2);

ALTER TABLE business_courses
ALTER COLUMN content_duration NUMERIC(10,2);

ALTER TABLE business_courses
ALTER COLUMN published_timestamp_date DATE;


-- Rename Rating column of each table
EXEC sp_rename 'web_development_courses.Rating', 'rating', 'COLUMN';


-- Add new subject column in each table
ALTER TABLE web_development_courses
ADD subject VARCHAR(500);

UPDATE design_courses
SET [subject] = 'graphics_design';


-- Combine all tables to create final dataset to be used
SELECT * INTO udemy_courses
FROM
(
	SELECT * FROM business_courses
	UNION 
	SELECT * FROM design_courses
	UNION 
	SELECT * FROM music_courses
	UNION 
	SELECT * FROM web_development_courses
) AS combined_data;


-- Add new column - revenue
ALTER TABLE udemy_courses
ADD revenue NUMERIC(10,2) 

UPDATE udemy_courses
SET revenue = price * num_subscribers;