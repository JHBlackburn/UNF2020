
SET NOCOUNT ON

DECLARE @totalRecordCount INT = 1000
DECLARE @earliestStartYear INT = 2014


DROP TABLE IF EXISTS #tempPersonLastName
CREATE TABLE #tempPersonLastName
(
	LastName VARCHAR(100)
)

INSERT INTO #tempPersonLastName
	(
		LastName
	)
	VALUES
	('Smith'),
	('Johnson'),
	('Williams'),
	('Brown'),
	('Jones'),
	('Garcia'),
	('Miller'),
	('Davis'),
	('Rodriguez'),
	('Martinez'),
	('Hernandez'),
	('Lopez'),
	('Gonzalez'),
	('Wilson'),
	('Anderson')


DROP TABLE IF EXISTS #tempPersonFirstName
CREATE TABLE #tempPersonFirstName
(
	FirstName VARCHAR(100),
	Gender VARCHAR(10)
)
INSERT INTO #tempPersonFirstName
	(
		FirstName,
		Gender
	)
	VALUES
	('Ashley', 'Female'),
	('Jessica', 'Female'),
	('Jennifer', 'Female'),
	('Megan', 'Female'),
	('Sarah', 'Female'),
	('Amanda', 'Female'),
	('Brittany', 'Female'),
	('Heather', 'Female'),
	('Stephanie', 'Female'),
	('Colleen', 'Female'),
	('Crystal', 'Female'),
	('Winnie', 'Female'),
	('Christopher', 'Male'),
	('Michael', 'Male'),
	('Joshua', 'Male'),
	('Daniel', 'Male'),
	('David', 'Male'),
	('Matthew', 'Male'),
	('Brandon', 'Male'),
	('James', 'Male'),
	('Ryan', 'Male'),
	('John', 'Male'),
	('Christian', 'Male'),
	('Raymond', 'Male')


DROP TABLE IF EXISTS #tempCompany
CREATE TABLE #tempCompany
(
	CompanyName VARCHAR(100),
	Industry VARCHAR(100),
	CompanyCity VARCHAR(100),
	CompanyState VARCHAR(100)

)
INSERT INTO #tempCompany
	(
		CompanyName,
		Industry,
		CompanyCity, 
		CompanyState

	)
	VALUES
		('FIS', 'Finacial', 'Jacksonville', 'FL'),
		('Sourtheastern Grocers', 'Grocery', 'Jacksonville', 'FL'),
		('CSX', 'Transportation', 'Jacksonville', 'FL'),
		('Fidelity National Financial', 'Finacial', 'Jacksonville', 'FL'),
		('Bi-LO', 'Grocery', 'Jacksonville', 'FL'),
		('Florida Blue', 'Insurance', 'Jacksonville', 'FL'),
		('Common Wealth Land Title', 'Insurance', 'Jacksonville', 'FL'),
		('Baptist Health', 'Healthcare', 'Jacksonville', 'FL'),
		('Stein Mart', 'Retail Clothing', 'Jacksonville', 'FL'),
		('Duval County Public Schools', 'Education', 'Jacksonville', 'FL'),
		('Crowley Holdings', 'Transportation', 'Jacksonville', 'FL'),
		('Suddath', 'Transportation', 'Jacksonville', 'FL'),
		('Florida East Coast', 'Transportation', 'Jacksonville', 'FL'),
		('Black Knight', 'Financial', 'Jacksonville', 'FL'),
		('EverBank', 'Financial', 'Jacksonville', 'FL'),
		('Gate Petrolium', 'Oil and Gas', 'Jacksonville', 'FL'),
		('University of North Florida', 'Education', 'Jacksonville', 'FL'),
		('Florida State College', 'Education', 'Jacksonville', 'FL'),
		('CES', 'IT Consulting', 'St. Augustine', 'FL'),
		('Ring Power CAT', 'Manufacturing', 'St. Augustine', 'FL'),
		('City of Saint Augustine', 'Government', 'St. Augustine', 'FL'),
		('Flagler Hospital', 'Healthcare', 'St. Augustine', 'FL'),
		('A D Davis Construction', 'Construction', 'St. Augustine', 'FL'),
		('Audioflix', 'Software', 'St. Augustine', 'FL'),
		('University of Florida', 'Education', 'Gainesville', 'FL'),
		('UF Health', 'Healthcare', 'Gainesville', 'FL'),
		('Veterans Affairs Medical Center', 'Healthcare', 'Gainesville', 'FL'),
		('Nationwide Insurance Company', 'Insurance', 'Gainesville', 'FL'),
		('Infinite Energy, Inc.', 'Oil and Gas', 'Gainesville', 'FL'),
		('Alachua County', 'Government', 'Gainesville', 'FL'),
		('RTI Surgical', 'Manufacturing', 'Gainesville', 'FL'),
		('Memorial University Medical Center', 'Healthcare', 'Savannah', 'GA'),
		('Kroger', 'Grocers', 'Savannah', 'GA'),
		('Invesco', 'Finacial', 'Atlanta', 'GA'),
		('CNN', 'Telecommunications', 'Atlanta', 'GA')



DROP TABLE IF EXISTS #tempPosition
CREATE TABLE #tempPosition
(
	PositionTitle VARCHAR(100),
	SalaryRangeStartUSD decimal(18,2),
	SalaryRangeEndUSD decimal(18,2)

)

INSERT INTO #tempPosition
	(
		PositionTitle,
		SalaryRangeStartUSD,
		SalaryRangeEndUSD
	)
	VALUES
	('Junior Data Scientist', 80000, 99999.99),
	('Senior Data Scientist', 100000, 150000),
	('Senior Software Developer', 100000, 150000),
	('Software Developer I', 75000, 90000),
	('Software Developer II', 85000, 110000),
	('Enterprise Data Archetect', 105000, 145000),
	('Director - Business Intellegence', 125000, 155000),
	('Call Center Analyst', 38000, 52000),
	('Business Systems Analyst I', 44000, 55000),
	('Business Systems Analyst II', 48000, 62000),
	('Business Systems Analyst III', 52000, 68000),
	('Product Owner', 50000, 85000),
	('Senior Project Manager', 85000, 135000),
	('ETL Developer', 75000, 95000),
	('Senior ETL Developer', 85000, 110000)


DROP TABLE IF EXISTS #tempPlacement
CREATE TABLE #tempPlacement
(
	Id				INt NOT NULL,
	PersonFirstName varchar (100) null,
	PersonLastName	varchar (100) null,
	PersonGender	varchar (100) null,
	CompanyName		varchar (100) null,
	CompanyCity		varchar (100) null,
	CompanyState	varchar (100) null,
	Industry		varchar(100) null,
	PositionTitle   varchar(100) null,
	StartYearlySalary decimal (14, 2) null,
	StartDate Date null,
	EndDate Date null,
)
DECLARE @placementId INT = 1
WHILE @placementId <= @totalRecordCount
	BEGIN
		
		INSERT INTO #tempPlacement
			(
				Id,				
				PersonFirstName,
				PersonLastName,	
				PersonGender,	
				CompanyName,		
				CompanyCity,	
				CompanyState,	
				Industry,		
				PositionTitle,  
				StartYearlySalary,
				StartDate,
				EndDate
		)
		SELECT 	
				@placementId,				
				PersonFirstName,
				PersonLastName,	
				PersonGender,	
				CompanyName,		
				CompanyCity,	
				CompanyState,	
				Industry,		
				PositionTitle,  
				StartYearlySalary,
				StartDate = (SELECT StartDate = (CASE 
													WHEN RandomDate > GETDATE() THEN DATEADD(YEAR, -1, RandomDate)
													ELSE RandomDate
												END)
												FROM (SELECT RandomDate = DATEFROMPARTS(RAND()*(YEAR(GETDATE()) - @earliestStartYear)+1 + @earliestStartYear, RAND()*(12 - 1) + 1, RAND()*(27 - 1) + 1 )
													 ) as someRandomDate
								),
				EndDate = NULL
		FROM (SELECT TOP 1 PersonFirstName = FirstName, PersonGender = Gender FROM #tempPersonFirstName ORDER BY NEWID()) as fn
		CROSS APPLY (SELECT TOP 1 PersonLastName = LastName FROM #tempPersonLastName ORDER BY NEWID()) as ln
		CROSS APPLY (SELECT TOP 1 CompanyName, CompanyCity, CompanyState, Industry FROM #tempCompany ORDER BY NEWID()) as c
		CROSS APPLY (SELECT TOP 1 PositionTitle, StartYearlySalary = CAST(RAND()*(SalaryRangeEndUSD - SalaryRangeStartUSD) + SalaryRangeStartUSD AS DECIMAL(14,2)) FROM #tempPosition ORDER BY NEWID()) as p


	SET @placementId += 1
	END

	UPDATE temp
	SET 
		temp.EndDate = endDates.EndDate
	FROM #tempPlacement as temp
	JOIN (
		SELECT 
			Id,
			EndDate = FIRST_VALUE(StartDate) OVER(Partition By PersonFirstName, PersonLastName ORDER BY StartDate DESC ROWS BETWEEN 1 PRECEDING and 1 PRECEDING)
			FROM #tempPlacement t
	) as endDates
	on temp.Id = endDates.Id

	/************************************************/
	/********* BEGIN MERGE INTO TARGET TABLE ********/
	/************************************************/
	MERGE jobs.Placement as t
		USING 
			(
				SELECT 
						temp.Id,
						temp.PersonFirstName,
						temp.PersonLastName,	
						temp.PersonGender,	
						temp.CompanyName,		
						temp.CompanyCity,	
						temp.CompanyState,	
						temp.Industry,		
						temp.PositionTitle,  
						temp.StartYearlySalary,
						temp.StartDate,
						temp.EndDate

				FROM #tempPlacement as temp
			) as s

		ON t.Id = s.Id

		WHEN MATCHED THEN UPDATE
			SET
				t.PersonFirstName = s.PersonFirstName,
				t.PersonLastName = s.PersonLastName,
				t.PersonGender = s.PersonGender,	
				t.CompanyName = s.CompanyName,		
				t.CompanyCity = s.CompanyCity,	
				t.CompanyState = s.CompanyState,	
				t.Industry = s.Industry,		
				t.PositionTitle = s.PositionTitle,  
				t.StartYearlySalary = s.StartYearlySalary,
				t.StartDate = s.StartDate,
				t.EndDate = s.EndDate

		WHEN NOT MATCHED THEN INSERT
			VALUES
				(
					s.Id,
					s.PersonFirstName,
					s.PersonLastName,	
					s.PersonGender,	
					s.CompanyName,		
					s.CompanyCity,	
					s.CompanyState,	
					s.Industry,		
					s.PositionTitle,  
					s.StartYearlySalary,
					s.StartDate,
					s.EndDate
				)
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
		;
	/************************************************/
	/******************END MERGE ********************/
	/************************************************/
