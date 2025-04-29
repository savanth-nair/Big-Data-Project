-- Checking which category_title has duplicates if we don’t take into account the categoryid

SELECT COUNTRY,CATEGORY_TITLE, COUNT(*) AS DUPLICATE_COUNT
FROM TABLE_YOUTUBE_CATEGORY
GROUP BY COUNTRY,CATEGORY_TITLE
HAVING COUNT(*) > 1;

-- Result = In the Category title column, Comedy has duplicates.