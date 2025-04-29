DELETE FROM TABLE_YOUTUBE_FINAL a
WHERE EXISTS ( SELECT *
                   FROM TABLE_YOUTUBE_DUPLICATES b
                   WHERE a.ID = b.ID
                 );