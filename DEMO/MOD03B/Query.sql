EXECUTE AS USER = 'DP300User1';

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