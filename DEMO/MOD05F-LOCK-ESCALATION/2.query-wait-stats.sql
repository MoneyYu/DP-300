-- Show the lock escalation wait stats
SELECT resource_type,
       resource_associated_entity_id,
       request_status,
       request_mode,
       request_session_id,
       resource_description
FROM sys.dm_tran_locks
WHERE resource_database_id =
(
    SELECT database_id FROM sys.databases WHERE [name] = 'tempdb'
);

-- Show the blocking session
SELECT t1.resource_type,
       t1.resource_database_id,
       t1.resource_associated_entity_id,
       t1.request_mode,
       t1.request_session_id,
       t2.blocking_session_id
FROM sys.dm_tran_locks AS t1
    INNER JOIN sys.dm_os_waiting_tasks AS t2
        ON t1.lock_owner_address = t2.resource_address;