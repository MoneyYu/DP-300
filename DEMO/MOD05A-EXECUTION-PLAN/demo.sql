-- Execution plan

USE AdventureWorks2019;


-- With problem sql
SELECT p.Name AS ProductName,

    NonDiscountSales = (OrderQty * UnitPrice),

    Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)

FROM Production.Product AS p

    INNER JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID

ORDER BY ProductName DESC;

-- view the plan

-- https://faculty.business.wsu.edu/featherman/web-programming/sampletsql/