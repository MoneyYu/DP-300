------- Test 1 - No Indexes on the Table
EXEC dbo.proc_1 0;
GO 20

-- use Top Resource Consuming Queries


------- Test 2 - Testing with a Non Clustered Index
CREATE NONCLUSTERED INDEX NCI_1 ON dbo.db_store (c3);
GO
EXEC dbo.proc_1 0;
GO 20

-- Observe execution plan

------- Test 3 - Create Another Non Clustered Index
CREATE NONCLUSTERED INDEX NCI_2 ON dbo.db_store (c3, c1);
GO
EXEC dbo.proc_1 0;
GO 20

-- Observe execution plan, logical read should larger than test 2

------- Test 4 - Force Plan
UPDATE dbo.db_store
SET c1 = '1'
WHERE c3 = '0';
UPDATE dbo.db_store
SET c2 = '3ff'
WHERE c3 = '1';
DELETE FROM dbo.db_store
WHERE c3 = 3;
INSERT INTO dbo.db_store
(
    c1,
    c2,
    c3
)
SELECT '173',
       '1fa',
       0;
GO 5

EXEC dbo.proc_1 0;
GO 20

-- Check Query Store for avg logical read

-- Force Plan
EXEC sp_query_store_force_plan @query_id = 1, @plan_id = 2;

-- Create the final, optimal index for the stored procedure
CREATE NONCLUSTERED INDEX NCI_3 ON dbo.db_store (c3) INCLUDE (c1, c2);

-- un-force plan #13 and run the stored procedure again
EXEC sp_query_store_unforce_plan @query_id = 185, @plan_id = 2;
GO
EXEC dbo.proc_1 0;
GO