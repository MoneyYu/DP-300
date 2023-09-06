-- Disable TDE for newly-created databases on SQL Managed Instance 
USE [AdventureWorks2019];
GO
ALTER DATABASE [AdventureWorks2019] SET ENCRYPTION OFF;
GO
DROP DATABASE ENCRYPTION KEY
GO


-- Create credential for Azure Storage Account
USE master
CREATE CREDENTIAL [https://<mystorageaccountname>.blob.core.windows.net/<mystorageaccountcontainername>]
  -- this name must match the container path, start with https and must not contain a forward slash at the end
WITH IDENTITY='SHARED ACCESS SIGNATURE'
  -- this is a mandatory string and should not be changed
 , SECRET = 'sharedaccesssignature'
   -- this is the shared access signature key that you obtained in section 1.
GO

-- List all available credentials
SELECT * from sys.credentials


-- Backup database to Azure Storage Account
USE [master]

BACKUP DATABASE [AdventureWorks2019] 
TO  URL = N'https://msftutorialstorage.blob.core.windows.net/sql-backup/AdventureWorks2019_backup_2020_01_01_000001.bak' 
WITH  COPY_ONLY, CHECKSUM
GO


-- Restore database from Azure Storage Account
USE [master]
RESTORE DATABASE [AdventureWorks2019] FROM 
URL = N'https://msftutorialstorage.blob.core.windows.net/sql-backup/AdventureWorks2019_backup_2020_01_01_000001.bak'