USE master;
GO

-- Drop the classifier function if it already exists
DROP FUNCTION IF EXISTS dbo.ClassifyByUser;
GO

-- Create the classifier function
CREATE FUNCTION dbo.ClassifyByUser()
RETURNS sysname
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @workload_group_name sysname;

    -- Default workload group
    SET @workload_group_name = 'default';

    -- Classify by user name
    IF SUSER_NAME() = 'ProductionUser'
        SET @workload_group_name = 'ProductionGroup';
    ELSE IF SUSER_NAME() = 'ReportingUser'
        SET @workload_group_name = 'ReportingGroup';
    ELSE IF SUSER_NAME() = 'DevelopmentUser'
        SET @workload_group_name = 'DevelopmentGroup';

    RETURN @workload_group_name;
END;
GO
