GO

DROP TABLE IF EXISTS #tempCensusLastName
CREATE TABLE #tempCensusLastName
(
	LastName VARCHAR(100),
	CensusYear INT NOT NULL,
	PopularityRank INT NOT NULL,

)
INSERT INTO #tempCensusLastName
	(
		LastName,
		CensusYear,
		PopularityRank
	)
	VALUES
	('Smith', 2020, 1),
	('Johnson', 2020, 2),
	('Williams', 2020, 3),
	('Brown', 2020, 4),
	('Jones', 2020, 5),
	('Garcia', 2020, 6),
	('Miller', 2020, 7),
	('Davis', 2020, 8),
	('Rodriguez', 2020, 9),
	('Martinez', 2020, 10),
	('Hernandez', 2020, 11),
	('Lopez', 2020, 12),
	('Gonzalez', 2020, 13),
	('Wilson', 2020, 14),
	('Anderson', 2020, 15)


	/************************************************/
	/********* BEGIN MERGE INTO TARGET TABLE ********/
	/************************************************/
	MERGE government.CensusLastName as t
		USING 
			(
				SELECT 
						temp.LastName,
						temp.CensusYear,
						temp.PopularityRank

				FROM #tempCensusLastName as temp
			) as s

		ON t.LastName = s.LastName

		WHEN MATCHED THEN UPDATE
			SET
				t.CensusYear = s.CensusYear,
				t.PopularityRank = s.PopularityRank

		WHEN NOT MATCHED THEN INSERT
			VALUES
				(
					s.LastName,
					s.CensusYear,
					s.PopularityRank

				)
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
		;
	/************************************************/
	/******************END MERGE ********************/
	/************************************************/

