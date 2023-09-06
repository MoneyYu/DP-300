USE tempdb;
GO

-- Create test table and index.  
CREATE TABLE t_lock
(
    c1 INT,
    c2 INT
);
GO

CREATE INDEX t_lock_ci ON t_lock (c1);
GO

-- Insert values into test table  
INSERT INTO t_lock
VALUES
(1, 1);
INSERT INTO t_lock
VALUES
(2, 2);
INSERT INTO t_lock
VALUES
(3, 3);
INSERT INTO t_lock
VALUES
(4, 4);
INSERT INTO t_lock
VALUES
(5, 5);
INSERT INTO t_lock
VALUES
(6, 6);
GO

-- Session 1  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN;
SELECT c1
FROM t_lock WITH (HOLDLOCK, ROWLOCK);

-- Session 2  
BEGIN TRAN;
UPDATE t_lock
SET c1 = 10;