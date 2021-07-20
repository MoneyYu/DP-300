-- Ownership chain

USE AdventureWorks2019;
GO
CREATE LOGIN [DP300User1] WITH PASSWORD = 'P@ssw0rd';
CREATE USER [DP300User1] FOR LOGIN [DP300User1];
GO
CREATE ROLE [SalesReader];
GO
ALTER ROLE [SalesReader] ADD MEMBER [DP300User1];
GO
GRANT SELECT, EXECUTE ON SCHEMA::Sales TO [SalesReader];
GO

CREATE PROCEDURE Sales.DemoProc
AS
SELECT P.Name,
       SUM(SOD.LineTotal) AS TotalSales,
       SOH.OrderDate
FROM Production.Product P
    INNER JOIN Sales.SalesOrderDetail SOD
        ON SOD.ProductID = P.ProductID
    INNER JOIN Sales.SalesOrderHeader SOH
        ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY P.Name,
         SOH.OrderDate
ORDER BY TotalSales DESC;
GO