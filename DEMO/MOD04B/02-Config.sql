USE QueryStoreDemo;
GO

-- create a table
CREATE TABLE dbo.db_store
(
    c1 CHAR(3) NOT NULL,
    c2 CHAR(3) NOT NULL,
    c3 SMALLINT NULL
);
GO

-- create a stored procedure
CREATE PROC dbo.proc_1 @par1 SMALLINT
AS
SET NOCOUNT ON;
SELECT c1,
       c2
FROM dbo.db_store
WHERE c3 = @par1;
GO
-- populate the table (this may take a couple of minutes)
SET NOCOUNT ON;
INSERT INTO [dbo].db_store
(
    c1,
    c2,
    c3
)
SELECT '18',
       '2f',
       2;
GO 20000
INSERT INTO [dbo].db_store
(
    c1,
    c2
)
SELECT '171',
       '1ff';
GO 4000  
INSERT INTO [dbo].db_store
(
    c1,
    c2,
    c3
)
SELECT '172',
       '1ff',
       0;
GO 10
INSERT INTO [dbo].db_store
(
    c1,
    c2,
    c3
)
SELECT '172',
       '1ff',
       4;
GO 15000

-- enable Query Store on the database
ALTER DATABASE [QueryStoreDemo] SET QUERY_STORE = ON;
GO