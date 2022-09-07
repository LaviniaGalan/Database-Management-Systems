Use HospitalCopy
GO


CREATE OR ALTER PROCEDURE AddMedicationSupplierRecovery
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
			DECLARE @ToInsert INT = 1
			DECLARE @MedicationID INT 
			DECLARE @SupplierID INT

			BEGIN TRY 
				EXEC ValidateMedicationParameters @ActiveSubstance 
				INSERT INTO LogTable VALUES ('> Inserting data in Medication table...')

				INSERT INTO Medication(ActiveSubstance) 
				VALUES (@ActiveSubstance)

				SET @MedicationID = @@IDENTITY
				
				INSERT INTO LogTable VALUES ('> Data inserted in Medication table!')
				INSERT INTO LogTable VALUES ('> Transaction saved - Medication_SavePoint!')
				SAVE TRAN Medication_SavePoint

			END TRY
			BEGIN CATCH
				SET @ToInsert = 0 
				PRINT(ERROR_MESSAGE() + ' ' +  CAST(ERROR_SEVERITY() AS VARCHAR(10)))
				INSERT INTO LogTable VALUES (ERROR_MESSAGE())
			END CATCH


			BEGIN TRY 
				EXEC ValidateSupplierParameters @Email, @PhoneNo
				INSERT INTO LogTable VALUES ('> Inserting data in Supplier table...')

				INSERT INTO Supplier(Email, PhoneNo)
				VALUES (@Email, @PhoneNo)

				SET @SupplierID = @@IDENTITY

				INSERT INTO LogTable VALUES ('> Data inserted in Supplier table!')
				INSERT INTO LogTable VALUES ('> Transaction saved - Supplier_SavePoint!')

				SAVE TRAN Supplier_SavePoint
			END TRY
			BEGIN CATCH
				SET @ToInsert = 0 
				PRINT(ERROR_MESSAGE() + ' ' +  CAST(ERROR_SEVERITY() AS VARCHAR(10)))
				ROLLBACK TRAN Medication_SavePoint
				-- COMMIT TRAN
				INSERT INTO LogTable VALUES (ERROR_MESSAGE())
				INSERT INTO LogTable VALUES('> There was an error, the transaction is rollbacked to Medication_SavePoint.')
				
			END CATCH

			IF @ToInsert = 1
			BEGIN

				BEGIN TRY 
					EXEC ValidateMedicationSupplierParameters @MedName, @LOT, @UseByDate
					INSERT INTO LogTable VALUES('> Inserting data in Medication_Supplier table...')

					INSERT INTO Medication_Supplier(MedicationID, SupplierID, MedName, LOT, UseByDate)
					VALUES (@MedicationID, @SupplierID, @MedName, @LOT, @UseByDate)

					INSERT INTO LogTable VALUES('> Data inserted in Medication_Supplier table!')
					COMMIT TRAN
					INSERT INTO LogTable VALUES('> Procedure ended successfully, the transaction is commited.')
					SELECT LogMessage FROM LogTable

				END TRY
				BEGIN CATCH
					PRINT(ERROR_MESSAGE() + ' ' +  CAST(ERROR_SEVERITY() AS VARCHAR(10)))
					
					ROLLBACK TRAN Supplier_SavePoint
					INSERT INTO LogTable VALUES (ERROR_MESSAGE())
					INSERT INTO LogTable VALUES('> There was an error, the transaction is rollbacked to Supplier_SavePoint.')
					COMMIT TRAN
					SELECT LogMessage FROM LogTable
				END CATCH

			END
			ELSE
			BEGIN
				INSERT INTO LogTable VALUES (' > Transaction finished.')
				SELECT LogMessage FROM LogTable
				COMMIT TRAN
			END

	END
GO



-- Happy scenario, all entities inserted. 
EXEC AddMedicationSupplierRecovery 'Magnesium', 'email@yahoo.com', '0231888999', 'Magne+', 98765, '05-30-2021'

SELECT * FROM Medication
SELECT * FROM Supplier
SELECT * FROM Medication_Supplier

DELETE FROM Medication_Supplier
WHERE MedName = 'Magne+'
DELETE FROM Medication
WHERE ActiveSubstance = 'Magnesium'
DELETE FROM Supplier
WHERE Email = 'email@yahoo.com'

-- Bad scenario, invalid medication.
EXEC AddMedicationSupplierRecovery 'a', 'email@yahoo.com', '0231888999', 'Magne+', 98765, '05-30-2021'


-- Bad scenario, invalid supplier.
EXEC AddMedicationSupplierRecovery 'Magnesium', 'emailinvalid', '0231888999', 'Magne+', 98765, '05-30-2021'


-- Bad scenario, invalid parameters for many to many table.
EXEC AddMedicationSupplierRecovery 'Magnesium', 'email@yahoo.com', '0231888999', 'Magne+', 98765, '05-30-2016'

