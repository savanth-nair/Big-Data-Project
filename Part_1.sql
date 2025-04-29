CREATE OR REPLACE DATABASE bde_at1_db;

USE DATABASE bde_at1_db;
CREATE OR REPLACE STORAGE INTEGRATION azure_bde_at1
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = 'e8911c26-cf9f-4a9c-878e-527807be8791'
  STORAGE_ALLOWED_LOCATIONS = ('azure://savanthstorage.blob.core.windows.net/assignment1');

DESC STORAGE INTEGRATION azure_bde_at1;

CREATE OR REPLACE STAGE stage_bde_at1
STORAGE_INTEGRATION = azure_bde_at1
URL='azure://savanthstorage.blob.core.windows.net/assignment1';

list @stage_bde_at1;

CREATE OR REPLACE FILE FORMAT file_format_csv
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
NULL_IF = ('\\N', 'NULL', 'NUL', '')
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
;

CREATE OR REPLACE EXTERNAL TABLE YOUTUBE_TRENDING_DATA_CSV
(
VIDEO_ID varchar as (value:c1::varchar), 
TITLE varchar as (value:c2::varchar),
PUBLISHEDAT TIMESTAMP_NTZ as (value:c3::TIMESTAMP_NTZ),
CHANNEL_ID varchar as (value:c4::varchar),
CHANNELTITLE varchar as (value:c5::varchar),
CATEGORYID int as (value:c6::int),    
TRENDING_DATE date as (value:c7::date),     
VIEW_COUNT int as (value:c8::int),
LIKES int as (value:c9::int),
DISLIKES int as (value:c10::int),
COMMENT_COUNT int as (value:c11::int),
COMMENT_DISABLED varchar as (value:c12::varchar)
)
WITH LOCATION = @stage_bde_at1
FILE_FORMAT = file_format_csv
PATTERN = '.*[.]csv';

-- Transfering the columns to the table created 

CREATE OR REPLACE TABLE TABLE_YOUTUBE_TRENDING as 
SELECT 
VIDEO_ID as VIDEO_ID, 
TITLE as TITLE,
PUBLISHEDAT as PUBLISHEDAT,
CHANNEL_ID as CHANNEL_ID,
CHANNELTITLE as CHANNELTITLE,
CATEGORYID as CATEGORYID,    
TRENDING_DATE as TRENDING_DATE,     
VIEW_COUNT as VIEW_COUNT,
LIKES as LIKES,
DISLIKES as DISLIKES,
COMMENT_COUNT as COMMENT_COUNT,
COMMENT_DISABLED as COMMENT_DISABLED,
split_part(metadata$filename,'_', 1)::varchar as COUNTRY
from
YOUTUBE_TRENDING_DATA_CSV;

-- Displaying the rows of the created table table_youtube_trending 

SELECT * FROM
TABLE_YOUTUBE_TRENDING
LIMIT 10;

-- Checking all country's data 

SELECT distinct COUNTRY 
FROM TABLE_YOUTUBE_TRENDING; 

--Checking the total number of records in the youtube trending table

SELECT COUNT(*) FROM TABLE_YOUTUBE_TRENDING;

-- Creating an external table to load youtube category data 

CREATE OR REPLACE EXTERNAL TABLE TABLE_YOUTUBE_CATEGORY_JSON
WITH LOCATION = @stage_bde_at1
FILE_FORMAT = (TYPE=JSON)
PATTERN = '.*[.]json';

-- Displaying the json file record from created table 

SELECT * FROM TABLE_YOUTUBE_CATEGORY_JSON;

--- Transfering data from json files to Category Table
  
CREATE OR REPLACE TABLE TABLE_YOUTUBE_CATEGORY
AS
SELECT
  COUNTRY,
  value:id::string as  "ID",
  value:snippet.title::string AS "CATEGORY_TITLE"
  FROM
    (SELECT PARSE_JSON(value) AS CAT,
     SPLIT_PART(metadata$filename,'_', 1)::VARCHAR AS COUNTRY
     FROM TABLE_YOUTUBE_CATEGORY_JSON),
  LATERAL FLATTEN(input => cat:items);

-- Displaying  the rows of the created table table_youtube_category

SELECT * FROM TABLE_YOUTUBE_CATEGORY LIMIT 10;
 
-- Checking all countries data 
 
SELECT DISTINCT COUNTRY FROM TABLE_YOUTUBE_CATEGORY;

-- Creating final table called table_youtube_final by combining youtube trending and youtube category tables


CREATE OR REPLACE TABLE TABLE_YOUTUBE_FINAL
AS
SELECT 
UUID_STRING() AS ID,
VIDEO_ID, 
TITLE,
PUBLISHEDAT,
CHANNEL_ID,
CHANNELTITLE,
CATEGORYID,
CATEGORY_TITLE,
TRENDING_DATE,     
VIEW_COUNT,
LIKES,
DISLIKES,
COMMENT_COUNT,
COMMENT_DISABLED,
T.COUNTRY
FROM TABLE_YOUTUBE_TRENDING AS T
LEFT JOIN TABLE_YOUTUBE_CATEGORY AS C
ON T.COUNTRY = C.COUNTRY
AND T.CATEGORYID = C.ID ORDER BY T.COUNTRY;

-- Displaying the rows of the created table table_youtube_final

SELECT * FROM TABLE_YOUTUBE_FINAL LIMIT 10;
 
-- Checking total number of records in the final table

SELECT COUNT(*) FROM TABLE_YOUTUBE_FINAL;