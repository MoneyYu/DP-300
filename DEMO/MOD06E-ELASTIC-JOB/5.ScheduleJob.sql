-- Connect to the job database specified when creating the job agent

EXEC jobs.sp_update_job @job_name = 'CreateTableTest',
                        @enabled = 1,
                        @schedule_interval_type = 'Minutes',
                        @schedule_interval_count = 15;