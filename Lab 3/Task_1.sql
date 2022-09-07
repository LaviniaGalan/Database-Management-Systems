Use HospitalCopy
GO

CREATE OR ALTER PROCEDURE AddMedicationSupplierRollback 
	@ActiveSubstance VARCHAR(50),
	@Email VARCHAR(50),
	@PhoneNo VARCHAR(13),
	@MedName VARCHAR(50),
	@LOT INT,
	@UseByDate DATE

	AS
	BEGIN
		DELETE FROM LogTable
		BEGIN TRAN
			BEGIN TRY

				EXEC ValidateMedicationParameters @ActiveSubstance 
				
				DECLARE @MedicationID INT 
				INSERT INTO LogTable VALUES ('> Inserting data in Medication table...')

				INSERT INTO Medication(ActiveSubstance) 
				VALUES (@ActiveSubstance)
				
				SET @MedicationID = @@IDENTITY
				INSERT INTO LogTable VALUES ('> Data inserted in Medication table!')
				
				EXEC ValidateSupplierParameters @Email, @PhoneNo

				DECLARE @SupplierID INT

				INSERT INTO LogTable VALUES ('> Inserting data in Supplier table...')

				INSERT INTO Supplier(Email, PhoneNo)
				VALUES (@Email, @PhoneNo)

				SET @SupplierID = @@IDENTITY
				INSERT INTO LogTable VALUES ('> Data inserted in Supplier table!')

				EXEC ValidateMedicationSupplierParameters @MedName, @LOT, @UseByDate

				INSERT INTO LogTable VALUES('> Inserting data in Medication_Supplier table...')
				INSERT INTO Medication_Supplier(MedicationID, SupplierID, MedName, LOT, UseByDate)
				VALUES (@MedicationID, @SupplierID, @MedName, @LOT, @UseByDate)
				INSERT INTO LogTable VALUES('> Data inserted in Medication_Supplier table!')
				COMMIT TRAN
				INSERT INTO LogTable VALUES('> Procedure ended successfully, the transaction is commited.')
				SELECT LogMessage FROM LogTable
				RETURN
			END TRY

			BEGIN CATCH
				-- PRINT(ERROR_MESSAGE() + ' ' +  CAST(ERROR_SEVERITY() AS VARCHAR(10)))
				INSERT INTO LogTable VALUES (ERROR_MESSAGE())
				INSERT INTO LogTable VALUES('> There was an error, the transaction is rollbacked.')
				SELECT LogMessage FROM LogTable
				ROLLBACK TRAN
				RETURN
			END CATCH
		
	END
GO

-- Happy scenario, all entities inserted. 
EXEC AddMedicationSupplierRollback 'Butylene Glycol', 'email_e@yahoo.com', '0231888999', 'Butylgood', 12345, '05-30-2021'

SELECT * FROM Medication
SELECT * FROM Supplier
SELECT * FROM Medication_Supplier

DELETE FROM Medication_Supplier
WHERE MedName = 'Butylgood'
DELETE FROM Medication
WHERE ActiveSubstance = 'Butylene Glycol'
DELETE FROM Supplier
WHERE Email = 'email_e@yahoo.com'

-- Bad scenario, invalid medication.
EXEC AddMedicationSupplierRollback 'a', 'email@yahoo.com', '0231888999', 'Butylgood', 12345, '05-30-2021'


-- Bad scenario, invalid supplier.
EXEC AddMedicationSupplierRollback 'Paracetamol', 'emailinvalid', '0231888999', 'Parasinus', 12345, '05-30-2021'


-- Bad scenario, invalid parameters for many to many table.
EXEC AddMedicationSupplierRollback 'Paracetamol', 'email@yahoo.com', '0231888999', 'Parasinus', 12345, '05-30-2016'

