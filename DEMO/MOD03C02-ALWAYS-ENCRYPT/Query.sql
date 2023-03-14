USE AdventureWorks2019;
GO;

SELECT * INTO HumanResources.EmployeeAE FROM HumanResources.Employee

-- ACTION: Enable Always Encrypted for BirthDate determines
-- Right click at table, choose Encrypt Columns

SELECT * FROM HumanResources.EmployeeAE

-- Determistc
SELECT BirthDate FROM HumanResources.EmployeeAE GROUP BY BirthDate

-- Randomized
SELECT HireDate FROM HumanResources.EmployeeAE GROUP BY HireDate

-- ACTION: Reconnect with Always Encrypted option