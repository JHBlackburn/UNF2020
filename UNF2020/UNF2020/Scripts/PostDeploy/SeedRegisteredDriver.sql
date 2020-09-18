GO
SET NOCOUNT ON

DECLARE @numberOfDrivers INT  = 1500;

DROP TABLE IF EXISTS #tempDriversLicenseStatusAndState
CREATE TABLE #tempDriversLicenseStatusAndState
(
	DriversLicenseStatus VARCHAR(100),
	DriversLicenseState VARCHAR(100)
)
	INSERT INTO #tempDriversLicenseStatusAndState
	(
		DriversLicenseStatus,
		DriversLicenseState
	)
		VALUES -- Setting relative frequency of each status in each state
			( 'ACTIVE', 'FL'),
			( 'ACTIVE', 'FL'),
			( 'ACTIVE', 'FL'),
			( 'ACTIVE', 'FL'),
			('SUSPENDED', 'FL'),
			('REVOKED', 'FL'),
			('ACTIVE', 'GA'),
			('ACTIVE', 'GA'),
			('ACTIVE', 'GA'),
			('ACTIVE', 'GA'),
			('SUSPENDED', 'GA'),
			('REVOKED', 'GA'),
			( 'ACTIVE', 'WY'),
			( 'ACTIVE', 'WY'),
			( 'ACTIVE', 'WY'),
			( 'ACTIVE', 'WY'),
			('SUSPENDED', 'WY'),
			('REVOKED', 'WY'),
			( 'ACTIVE', 'NY'),
			( 'ACTIVE', 'NY'),
			( 'ACTIVE', 'NY'),
			( 'ACTIVE', 'NY'),
			('SUSPENDED', 'NY'),
			('REVOKED', 'NY'),
			( 'ACTIVE', 'CA'),
			( 'ACTIVE', 'CA'),
			( 'ACTIVE', 'CA'),
			( 'ACTIVE', 'CA'),
			('SUSPENDED', 'CA'),
			('REVOKED', 'CA')


DROP TABLE IF EXISTS #tempRegisteredDriver
CREATE TABLE #tempRegisteredDriver
(
	SocialSecurityNumber VARCHAR(100) PRIMARY KEY,
	DriversLicenseNumber VARCHAR(100),
	DriversLicenseState VARCHAR(100),
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	Gender VARCHAR(10) NOT NULL,
	DateOfBirth DATE NOT NULL,
	HeightInInches INT NOT NULL,
	RegisteredAddress NVARCHAR(500) NULL,
	DriversLicenseStatus VARCHAR(100) NULL,
	IssuedDate  DATE NULL,
	ExpirationDate DATE NULL,
	SuspendedDate DATE NULL,
	RevokedDate DATE NULL
)


	INSERT INTO #tempRegisteredDriver
	(
		SocialSecurityNumber,
		DriversLicenseNumber,
		FirstName,
		LastName,
		Gender,
		DateOfBirth,
		HeightInInches
	)
	SELECT TOP (SELECT @numberOfDrivers)
		SocialSecurityNumber = ssp.SocialSecurityNumber,
		DriversLicenseNumber = CONCAT('FAKE-DL-NUM-', CAST(ROW_NUMBER() OVER(ORDER BY ssp.SocialSecurityNumber) AS VARCHAR(100))),
		FirstName = ssp.FirstName,
		LastName = ssp.LastName,
		Gender = ssp.Gender,
		DateOfBirth = ssp.DateOfBirth,
		HeightInInches = ssp.HeightInInches
		

	FROM government.SocialSecurityPerson ssp
	ORDER BY NEWID()

DECLARE @i INT = 1;
WHILE @i <= @numberOfDrivers
	BEGIN
	DECLARE @thisDriversLicenseNumber VARCHAR(100) = (SELECT TOP 1  rd.DriversLicenseNumber FROM  #tempRegisteredDriver rd WHERE DriversLicenseStatus IS NULL ORDER BY NEWID())

		UPDATE t
			SET 
				DriversLicenseState = (SELECT TOP 1 DriversLicenseState FROM #tempDriversLicenseStatusAndState ORDER BY NEWID()),
				IssuedDate = (SELECT DATEADD(MONTH, -(FLOOR(RAND()*(DATEDIFF(MONTH, t.DateOfBirth, GETDATE())-192)) + 192), GETDATE())),
				DriversLicenseStatus = (SELECT TOP 1 DriversLicenseStatus FROM #tempDriversLicenseStatusAndState ORDER BY NEWID()),
				RevokedDate = null
		
			FROM #tempRegisteredDriver as t
			WHERE t.DriversLicenseNumber = @thisDriversLicenseNumber

			UPDATE t
			SET 
				ExpirationDate = (SELECT DATEADD(YEAR, FLOOR(RAND()*9), DATEFROMPARTS(YEAR(GETDATE()), MONTH(t.DateOfBirth), DAY(t.DateOfBirth)))),
				RegisteredAddress =  CONCAT(CAST(FLOOR(RAND(@i)*999999) AS NVARCHAR(100)), ' Fake Street Fake City, ', t.DriversLicenseState, ' ', CAST(FLOOR(RAND(@i)*99999) AS NVARCHAR(100)))

		
			FROM #tempRegisteredDriver as t
			WHERE t.DriversLicenseNumber = @thisDriversLicenseNumber

			UPDATE t
			SET 
				RevokedDate =  DATEADD(MONTH, RAND()*DATEDIFF(MONTH, t.IssuedDate, GETDATE()), t.IssuedDate),
				ExpirationDate = null

			FROM #tempRegisteredDriver as t
			WHERE t.DriversLicenseNumber = @thisDriversLicenseNumber
			AND t.DriversLicenseStatus = 'REVOKED'


		UPDATE t
				SET 
					SuspendedDate =  DATEADD(MONTH, RAND()*DATEDIFF(MONTH, t.IssuedDate, GETDATE()), t.IssuedDate),
					ExpirationDate = null
		
				FROM #tempRegisteredDriver as t
				WHERE t.DriversLicenseNumber = @thisDriversLicenseNumber
				AND t.DriversLicenseStatus = 'SUSPENDED'


		SET @i += 1
	END
	





	
	/************************************************/
	/********* BEGIN MERGE INTO TARGET TABLE ********/
	/************************************************/
	MERGE government.RegisteredDriver as t
		USING 
			(
				SELECT 
						temp.SocialSecurityNumber,
						temp.DriversLicenseNumber,
						temp.DriversLicenseState,
						temp.FirstName,
						temp.LastName,
						temp.Gender,
						temp.DateOfBirth,
						temp.HeightInInches,
						temp.RegisteredAddress,
						temp.DriversLicenseStatus,
						temp.IssuedDate,
						temp.ExpirationDate,
						temp.SuspendedDate,
						temp.RevokedDate

				FROM #tempRegisteredDriver as temp
			) as s

		ON t.SocialSecurityNumber = s.SocialSecurityNumber

		WHEN MATCHED THEN UPDATE
			SET
				t.DriversLicenseNumber = s.DriversLicenseNumber,		
				t.DriversLicenseState = s.DriversLicenseState,		
				t.FirstName = s.FirstName,
				t.LastName = s.LastName,
				t.Gender = s.Gender,
				t.DateOfBirth = s.DateOfBirth,		
				t.HeightInInches = s.HeightInInches,	
				t.RegisteredAddress = s.RegisteredAddress,	
				t.DriversLicenseStatus = s.DriversLicenseStatus,		
				t.IssuedDate = s.IssuedDate,  
				t.ExpirationDate = s.ExpirationDate,
				t.SuspendedDate = s.SuspendedDate,
				t.RevokedDate = s.RevokedDate

		WHEN NOT MATCHED THEN INSERT
			VALUES
				(
					s.SocialSecurityNumber,
					s.DriversLicenseNumber,
					s.DriversLicenseState,
					s.FirstName,
					s.LastName,
					s.Gender,
					s.DateOfBirth,
					s.HeightInInches,
					s.RegisteredAddress,
					s.DriversLicenseStatus,
					s.IssuedDate,
					s.ExpirationDate,
					s.SuspendedDate,
					s.RevokedDate
				)
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
		;
	/************************************************/
	/******************END MERGE ********************/
	/************************************************/
