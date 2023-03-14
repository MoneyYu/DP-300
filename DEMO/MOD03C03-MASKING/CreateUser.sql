-- USE Azure SQL Database

use master

use [userdb]
CREATE USER [DP300User1]
	FOR LOGIN [DP300User1]
GO

EXEC sp_addrolemember N'db_datareader', N'DP300User1'
GO
