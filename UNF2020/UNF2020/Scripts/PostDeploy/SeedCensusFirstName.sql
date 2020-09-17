GO

DROP TABLE IF EXISTS #tempCensusFirstName
CREATE TABLE #tempCensusFirstName
(
	FirstName VARCHAR(100),
	Gender VARCHAR(10),
	CensusYear INT NOT NULL,
	PopularityRank INT NOT NULL,

)
INSERT INTO #tempCensusFirstName
	(
		FirstName,
		Gender,
		CensusYear,
		PopularityRank
	)
	VALUES
	('Ashley', 'Female', 2020, 1),
	('Jessica', 'Female', 2020, 2),
	('Jennifer', 'Female', 2020, 3),
	('Megan', 'Female', 2020, 4),
	('Sarah', 'Female', 2020, 5),
	('Amanda', 'Female', 2020, 6),
	('Brittany', 'Female', 2020, 7),
	('Heather', 'Female', 2020, 8),
	('Stephanie', 'Female', 2020, 9),
	('Colleen', 'Female', 2020, 10),
	('Crystal', 'Female', 2020, 11),
	('Winnie', 'Female', 2020, 12),
	('Christopher', 'Male', 2020, 1),
	('Michael', 'Male', 2020, 2),
	('Joshua', 'Male', 2020, 3),
	('Daniel', 'Male', 2020, 4),
	('David', 'Male', 2020, 5),
	('Matthew', 'Male', 2020, 6),
	('Brandon', 'Male', 2020, 7),
	('James', 'Male', 2020, 8),
	('Ryan', 'Male', 2020, 9),
	('John', 'Male', 2020, 10),
	('Christian', 'Male', 2020, 11),
	('Raymond', 'Male', 2020, 12)


	/************************************************/
	/********* BEGIN MERGE INTO TARGET TABLE ********/
	/************************************************/
	MERGE government.CensusFirstName as t
		USING 
			(
				SELECT 
						temp.FirstName,
						temp.Gender,
						temp.CensusYear,
						temp.PopularityRank

				FROM #tempCensusFirstName as temp
			) as s

		ON t.FirstName = s.FirstName

		WHEN MATCHED THEN UPDATE
			SET
				t.Gender = s.Gender,
				t.CensusYear = s.CensusYear,
				t.PopularityRank = s.PopularityRank

		WHEN NOT MATCHED THEN INSERT
			VALUES
				(
					s.FirstName,
					s.Gender,
					s.CensusYear,
					s.PopularityRank
				)
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
		;
	/************************************************/
	/******************END MERGE ********************/
	/************************************************/

