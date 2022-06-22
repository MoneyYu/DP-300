--Connect to the job database specified when creating the job agent

-- Execute the latest version of a job
EXEC jobs.sp_start_job 'CreateTableTest';

-- -- Execute the latest version of a job and receive the execution id
-- declare @je uniqueidentifier;
-- exec jobs.sp_start_job 'CreateTableTest', @job_execution_id = @je output;
-- select @je;

-- select * from jobs.job_executions where job_execution_id = @je;

-- -- Execute a specific version of a job (e.g. version 1)
-- exec jobs.sp_start_job 'CreateTableTest', 1;