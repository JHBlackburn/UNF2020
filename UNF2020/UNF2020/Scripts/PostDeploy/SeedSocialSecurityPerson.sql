GO

DECLARE @numberOfDistinctHumans INT  = 10000;
DECLARE @oldestHumanAge INT = 89
DECLARE @youngestHumanAge INT = 18

DROP TABLE IF EXISTS #tempDistinctHuman
CREATE TABLE #tempDistinctHuman
(
	SocialSecurityNumber VARCHAR(100) NOT NULL PRIMARY KEY,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	Gender VARCHAR(10) NOT NULL,
	DateOfBirth DATE NOT NULL,
	HeightInInches INT NOT NULL
)

DECLARE @i INT =  1
WHILE @i <= @numberOfDistinctHumans
	BEGIN 

		INSERT INTO #tempDistinctHuman
		(
			SocialSecurityNumber,
			FirstName,
			LastName,
			Gender,
			DateOfBirth,
			HeightInInches
		)
		SELECT 
			SocialSecurityNumber,
			FirstName,
			LastName,
			Gender,
			DateOfBirth,
			HeightInInches
		
			FROM (SELECT TOP 1 FirstName, Gender FROM government.CensusFirstName ORDER BY NEWID()) as fn
			CROSS APPLY (SELECT TOP 1 LastName FROM government.CensusLastName ORDER BY NEWID()) as ln
			CROSS APPLY (SELECT HeightInInches = RAND()*(80-40)+40) as h
			CROSS APPLY (SELECT DateOfBirth = DATEFROMPARTS((YEAR(GETDATE()) - (RAND()*(@oldestHumanAge - @youngestHumanAge)+ 1 + @youngestHumanAge)), RAND()*(12 - 1) + 1, RAND()*(27 - 1) + 1 )) as dob
			CROSS APPLY (SELECT SocialSecurityNumber = NEWID()) as ssn
			

			SET @i += 1
	END




	/************************************************/
	/********* BEGIN MERGE INTO TARGET TABLE ********/
	/************************************************/
	MERGE government.SocialSecurityPerson as t
		USING 
			(
				SELECT 
					temp.SocialSecurityNumber,
					temp.FirstName,
					temp.LastName,
					temp.Gender,
					temp.DateOfBirth,
					temp.HeightInInches

				FROM #tempDistinctHuman as temp
			) as s

		ON t.SocialSecurityNumber = s.SocialSecurityNumber

		WHEN MATCHED THEN UPDATE
			SET
				t.FirstName = s.FirstName,
				t.LastName = s.LastName,
				t.Gender = s.Gender,
				t.DateOfBirth = s.DateOfBirth,
				t.HeightInInches = s.HeightInInches

		WHEN NOT MATCHED THEN INSERT
			VALUES
				(
					s.SocialSecurityNumber,
					s.FirstName,
					s.LastName,
					s.Gender,
					s.DateOfBirth,
					s.HeightInInches
				)
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
		;
	/************************************************/
	/******************END MERGE ********************/
	/************************************************/
