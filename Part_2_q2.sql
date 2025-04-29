-- Checking which category_title only appears in one country

SELECT CATEGORY_TITLE FROM TABLE_YOUTUBE_CATEGORY
GROUP BY CATEGORY_TITLE
HAVING COUNT(*)=1;

-- Result = In the Category title column, Nonprofits & Activism only appears in one country. 