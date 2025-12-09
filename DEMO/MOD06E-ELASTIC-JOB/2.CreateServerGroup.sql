-- Connect to the job database specified when creating the job agent

-- Add a target group containing server(s)
EXEC jobs.sp_add_target_group 'ServerGroup1';

-- Add a server target member
-- EXEC jobs.sp_add_target_group_member @target_group_name = 'ServerGroup1',
--                                      @target_type = 'SqlServer',
--                                      @refresh_credential_name = 'refresh_credential', --credential required to refresh the databases in a server
--                                      @server_name = 'server1.database.windows.net';

-- Include a database target member from the server target group
EXEC [jobs].sp_add_target_group_member @target_group_name = N'ServerGroup1',
@membership_type = N'Include',
@target_type = N'SqlDatabase',
@server_name = N'lab01-azure-sql-tue.database.windows.net',
@database_name = N'lab01d-elastic01-db-tue';
GO

--View the recently created target group and target group members
SELECT *
FROM jobs.target_groups
WHERE target_group_name = 'ServerGroup1';
SELECT *
FROM jobs.target_group_members
WHERE target_group_name = 'ServerGroup1';