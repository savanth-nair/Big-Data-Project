-- Creating view for getting total distinct number of videos of that country

CREATE OR REPLACE VIEW CON 
AS
    SELECT COUNTRY,
    COUNT( DISTINCT VIDEO_ID) AS TOTAL_COUNTRY_VIDEO
    FROM TABLE_YOUTUBE_FINAL AS A
    GROUP BY COUNTRY;

-- Creatng a view to get the category_title that has the most distinct videos

CREATE OR REPLACE VIEW CAT
AS
SELECT * FROM 
    (
    SELECT 
    COUNTRY,
    CATEGORY_TITLE,
    COUNT(DISTINCT VIDEO_ID) AS TOTAL_CATEGORY_VIDEO,
    RANK() OVER (PARTITION BY COUNTRY ORDER BY COUNT(DISTINCT VIDEO_ID) DESC) AS RK
    FROM 
    TABLE_YOUTUBE_FINAL
    GROUP BY COUNTRY,CATEGORY_TITLE
    )
WHERE RK = 1
ORDER BY COUNTRY;

-- Fromthe above views, Query to get which category_title has the most distinct videos its percentage out of the total distinct number of videos of that country

SELECT 
A.COUNTRY,
C.CATEGORY_TITLE,
C.TOTAL_CATEGORY_VIDEO,
A.TOTAL_COUNTRY_VIDEO,
(C.TOTAL_CATEGORY_VIDEO/A.TOTAL_COUNTRY_VIDEO)*100 AS PERCENTAGE
FROM 
CON AS A
JOIN
    (
    SELECT 
    B.COUNTRY,
    B.TOTAL_CATEGORY_VIDEO,
    B.CATEGORY_TITLE
    FROM CAT AS B) 
    AS C
ON A.COUNTRY = C.COUNTRY;