CREATE USER [lettucebo@hotmail.com] FROM EXTERNAL PROVIDER;

EXEC sp_addrolemember 'db_datareader', 'lettucebo@hotmail.com';