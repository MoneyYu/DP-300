USE AdventureWorks2019;

SELECT p.ProductID,
       [Name],
       AVG([UnitPrice]) AS [Average List Price]
FROM Production.Product p
    INNER JOIN [Sales].[SalesOrderDetail] s
        ON p.ProductID = s.[ProductID]
GROUP BY p.ProductID,
         [Name]
HAVING AVG([UnitPrice]) > 1000
ORDER BY p.ProductID;