-- =============================================
-- Author:		Steven玄
-- ALTER date:  20210120
-- Description:	查詢資料表內的索引破碎化百分比情形   
-- =============================================

SELECT OBJECT_NAME(dt.object_id) AS [TableName], --資料表名稱
       si.name AS [IndexName],                   --索引名稱
       dt.avg_fragmentation_in_percent,          --邏輯片段的百分比 (索引中失序的頁面)。
       dt.avg_page_space_used_in_percent
FROM
(
    SELECT object_id,
           index_id,
           avg_fragmentation_in_percent,
           avg_page_space_used_in_percent
    FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED')
    WHERE index_id <> 0
) AS dt --does not return information about heaps
    INNER JOIN sys.indexes si
        ON si.object_id = dt.object_id
           AND si.index_id = dt.index_id;