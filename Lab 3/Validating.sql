USE HospitalCopy
GO


CREATE OR ALTER FUNCTION ValidateActiveSubstance (@ActiveSubstance VARCHAR(50))
RETURNS INT AS
BEGIN	
	DECLARE @ReturnedValue INT = 0
	IF LEN(@ActiveSubstance) <= 3
		SET @ReturnedValue = -1
	RETURN @ReturnedValue
END
GO

CREATE OR ALTER FUNCTION ValidateMedName (@MedName VARCHAR(50))
RETURNS INT AS
BEGIN	
	DECLARE @ReturnedValue INT = 0
	IF LEN(@MedName) <= 2
		SET @ReturnedValue = -1
	RETURN @ReturnedValue
END
GO

CREATE OR ALTER FUNCTION ValidateEmail (@Email VARCHAR(50))
RETURNS INT AS
BEGIN	
	DECLARE @ReturnedValue INT = 0
	IF LEN(@Email) <= 8 OR @Email NOT LIKE '%@%'
		SET @ReturnedValue = -1
	RETURN @ReturnedValue
END
GO

CREATE OR ALTER FUNCTION ValidatePhoneNumber (@PhoneNo VARCHAR(13))
RETURNS INT AS
BEGIN	
	DECLARE @ReturnedValue INT = 0
	IF LEN(@PhoneNo) < 7 OR LEN(@PhoneNo) > 13
		SET @ReturnedValue = -1
	RETURN @ReturnedValue
END
GO

CREATE OR ALTER FUNCTION ValidateLOT (@LOT INT)
RETURNS INT AS
BEGIN	
	DECLARE @ReturnedValue INT = 0
	IF @LOT <= 0
		SET @ReturnedValue = -1
	RETURN @ReturnedValue
END
GO

CREATE OR ALTER FUNCTION ValidateUseByDate (@UseByDate DATE)
RETURNS INT AS
BEGIN	
	DECLARE @ReturnedValue INT = 0
	IF @UseByDate < GETDATE() OR @UseByDate > DATEADD(year, 10, GETDATE())
		SET @ReturnedValue = -1
	RETURN @ReturnedValue
END
GO

CREATE OR ALTER PROCEDURE ValidateParameters 
	@ActiveSubstance VARCHAR(50),
	@Email VARCHAR(50),
	@PhoneNo VARCHAR(13),
	@MedName VARCHAR(50),
	@LOT INT,
	@UseByDate DATE
	AS
	BEGIN
			IF dbo.ValidateActiveSubstance(@ActiveSubstance) = -1
			BEGIN
				RAISERROR('Invalid active substance!', 16, 1)
			END


			IF dbo.ValidateEmail(@Email) = -1
			BEGIN
				RAISERROR('Invalid supplier email!', 16, 1)
			END

			IF dbo.ValidatePhoneNumber(@PhoneNo) = -1
			BEGIN
				RAISERROR('Invalid supplier phone number!', 16, 1)
			END


			IF dbo.ValidateMedName(@MedName) = -1
			BEGIN
				RAISERROR('Invalid medication name!', 16, 1)
			END

			IF dbo.ValidateLOT(@LOT) = -1
			BEGIN
				RAISERROR('Invalid LOT!', 16, 1)
			END
			IF dbo.ValidateUseByDate(@UseByDate) = -1
			BEGIN
				RAISERROR('Invalid UseBy Date!', 16, 1)
			END

END
GO


CREATE OR ALTER PROCEDURE ValidateMedicationParameters
	@ActiveSubstance VARCHAR(50)
	AS
		BEGIN
			INSERT INTO LogTable VALUES (' > Validating Medication Parameters...')
			IF dbo.ValidateActiveSubstance(@ActiveSubstance) = -1
			BEGIN
				RAISERROR('Invalid active substance!', 16, 1)
			END
			INSERT INTO LogTable VALUES (' > Validating Medication Parameters Ended Successfully!')
		END
	GO


CREATE OR ALTER PROCEDURE ValidateSupplierParameters
	@Email VARCHAR(50),
	@PhoneNo VARCHAR(13)
	AS
		BEGIN
			INSERT INTO LogTable VALUES (' > Validating Supplier Parameters...')
			IF dbo.ValidateEmail(@Email) = -1
				BEGIN
					RAISERROR('Invalid supplier email!', 16, 1)
				END

				IF dbo.ValidatePhoneNumber(@PhoneNo) = -1
				BEGIN
					RAISERROR('Invalid supplier phone number!', 16, 1)
				END
				INSERT INTO LogTable VALUES (' > Validating Supplier Parameters Ended Successfully!')
		END
	GO

CREATE OR ALTER PROCEDURE ValidateMedicationSupplierParameters
	@MedName VARCHAR(50),
	@LOT INT,
	@UseByDate DATE
	AS
		BEGIN
			INSERT INTO LogTable VALUES (' > Validating Medication_Supplier Parameters...')
			IF dbo.ValidateMedName(@MedName) = -1
			BEGIN
				RAISERROR('Invalid medication name!', 16, 1)
			END

			IF dbo.ValidateLOT(@LOT) = -1
			BEGIN
				RAISERROR('Invalid LOT!', 16, 1)
			END
			IF dbo.ValidateUseByDate(@UseByDate) = -1
			BEGIN
				RAISERROR('Invalid UseBy Date!', 16, 1)
			END
			INSERT INTO LogTable VALUES (' > Validating Medication_Supplier Parameters Ended Successfully!')
		END
	GO
