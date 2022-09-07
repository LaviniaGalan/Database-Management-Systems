USE HospitalCopy
GO

SELECT *
FROM Manager

UPDATE Manager
SET Name = 'Name'
WHERE ManagerID = 1

-- Dirty read 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRAN
	UPDATE Manager
	SET Name = 'Name_T1'
	WHERE ManagerID = 1

	ROLLBACK TRAN


-- Non-Repeatable Read
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

BEGIN TRAN
	SELECT *
	FROM Manager
	WHERE ManagerID < 3

	SELECT *
	FROM Manager
	WHERE ManagerID < 3

	COMMIT TRAN

-- Phantom Read:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

BEGIN TRAN
	SELECT *
	FROM Nurse
	WHERE NurseID > 2

	SELECT * 
	FROM Nurse
	WHERE NurseID > 2

	COMMIT TRAN

--Deadlock

SELECT * 
FROM Manager

BEGIN TRAN
	UPDATE Manager
	SET Name = 'Name_T1_1'
	WHERE ManagerID = 1

	UPDATE Manager
	SET Name = 'Name_T1_2'
	WHERE ManagerID = 2
	
	COMMIT TRAN


-- Solution:
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

SELECT resource_type, request_mode, request_type,request_status, request_session_id
FROM sys.dm_tran_locks 
WHERE request_owner_type='TRANSACTION'