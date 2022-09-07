USE HospitalCopy

ALTER DATABASE HospitalCopy
SET ALLOW_SNAPSHOT_ISOLATION ON

SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
	UPDATE Manager
	SET Name = Name + 'AA'
	WHERE ManagerID = 3

	COMMIT TRAN

SELECT *
FROM Manager



SELECT resource_type, request_mode, request_type,request_status, request_session_id
FROM sys.dm_tran_locks 
WHERE request_owner_type='TRANSACTION'

SELECT *
FROM sys.databases
WHERE database_id = DB_ID('HospitalCopy')