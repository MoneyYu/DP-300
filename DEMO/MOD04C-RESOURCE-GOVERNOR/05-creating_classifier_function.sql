-- Creating the classifier function
USE master;
GO

DROP FUNCTION IF EXISTS dbo.ClassifyByUser;
GO

CREATE FUNCTION ClassifyByUser
()
RETURNS sysname
WITH SCHEMABINDING
BEGIN
    DECLARE @workload_group_name VARCHAR(18);
    SET @workload_group_name = 'default';
    IF SUSER_NAME() = 'ProductionUser'
        SET @workload_group_name = 'ProductionGroup';
    ELSE IF SUSER_NAME() = 'ReportingUser'
        SET @workload_group_name = 'ReportingGroup';
    ELSE IF SUSER_NAME() = 'DevelopmentUser'
        SET @workload_group_name = 'DevelopmentGroup';
    RETURN @workload_group_name;
END;
GO