-- 查询等待统计信息

-- Use Azure SQL Database
SELECT [wait_type] , [waiting_tasks_count] , [wait_time_ms] , [wait_time_ms] / [waiting_tasks_count] AS [avg_wait_time_ms] , [max_wait_time_ms] , [signal_wait_time_ms]
FROM sys.dm_db_wait_stats
ORDER BY [avg_wait_time_ms] DESC
