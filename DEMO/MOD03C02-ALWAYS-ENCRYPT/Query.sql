USE AdventureWorks2019;
GO;

SELECT * INTO HumanResources.EmployeeAE FROM HumanResources.Employee

-- ACTION: Enable Always Encrypted for BirthDate determines
-- Right click at table, choose Encrypt Columns

SELECT * FROM HumanResources.EmployeeAE

-- ACTION: Reconnect with Always Encrypted option