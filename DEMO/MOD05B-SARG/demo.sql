-- SARGarbility

USE AdventureWorks2019;
GO;

-- Non SARGable (Index Scan)
SELECT
    [Name]
FROM [Production].[Location]
WHERE LEFT([Name],1) = 'P'

-- SARGable (Index Seek)
SELECT
    [Name]
FROM [Production].[Location]
WHERE [Name] LIKE 'P%'