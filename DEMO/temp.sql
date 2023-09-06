SELECT *
FROM sys.dm_db_stats_properties(OBJECT_ID('HumanResources.Employee'), 1);

SELECT sp.stats_id,
       name,
       filter_definition,
       last_updated,
       rows,
       rows_sampled,
       steps,
       unfiltered_rows,
       modification_counter
FROM sys.stats AS stat
    CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
WHERE stat.object_id = OBJECT_ID('HumanResource.Employee');

---------------------


SELECT resource_type,
       resource_associated_entity_id,
       request_status,
       request_mode,
       request_session_id,
       resource_description
FROM sys.dm_tran_locks;
--WHERE resource_database_id = <dbid>


------------

SELECT * FROM sys.dm_db_index_physical_stats (NULL, NULL, NULL, NULL, NULL);
GO


SELECT o.name,
    ips.partition_number,
    ips.index_type_desc,
    ips.record_count,
    ips.avg_record_size_in_bytes,
    ips.min_record_size_in_bytes,
    ips.max_record_size_in_bytes,
    ips.page_count,
    ips.compressed_page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') ips
INNER JOIN sys.objects o
    ON o.object_id = ips.object_id
ORDER BY record_count DESC;