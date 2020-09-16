--Source: Wikipedia.org https://en.wikipedia.org/wiki/Zodiac Accessed 09.16.2020

DECLARE @numberOfYearsAfter1900 INT = 150;


DROP TABLE IF EXISTS #tempZodiacSign
CREATE TABLE #tempZodiacSign
(
	ZodiacName VARCHAR(100),
	TropicalZodiacStartDate DATE NOT NULL PRIMARY KEY,
	TropicalZodiacEndDate DATE NOT NULL

)

DROP TABLE IF EXISTS #tempZodiacSign_SeedSet
CREATE TABLE #tempZodiacSign_SeedSet
(
	ZodiacName VARCHAR(100) PRIMARY KEY,
	TropicalZodiacStartDate DATE NOT NULL,
	TropicalZodiacEndDate DATE NOT NULL
)

INSERT INTO #tempZodiacSign_SeedSet
	(
		ZodiacName,
		TropicalZodiacStartDate,
		TropicalZodiacEndDate
	)
	VALUES
		('Aquarius', '1900-01-20', '1900-02-19'),
		('Pisces', '1900-02-20', '1900-03-21'),
		('Aries', '1900-03-21', '1900-04-20'),
		('Taurus', '1900-04-21', '1900-05-21'),
		('Gemini', '1900-05-22', '1900-06-21'),
		('Cancer', '1900-06-22', '1900-07-23'),
		('Leo', '1900-07-24', '1900-08-23'),
		('Virgo', '1900-08-24', '1900-09-23'),
		('Libra', '1900-09-24', '1900-10-23'),
		('Scorpio', '1900-10-24', '1900-11-22'),
		('Sagittarius', '1900-11-23', '1900-12-22'),
		('Capricorn', '1900-12-23', '1901-01-20')


DECLARE @i INT = 0

WHILE @i <= @numberOfYearsAfter1900
	BEGIN
		INSERT INTO #tempZodiacSign
		(
			ZodiacName,
			TropicalZodiacStartDate,
			TropicalZodiacEndDate
		)
		SELECT 
			ZodiacName,
			DATEADD(YEAR, @i, TropicalZodiacStartDate) as TropicalZodiacStartDate,
			DATEADD(YEAR, @i, TropicalZodiacEndDate) as TropicalZodiacEndDate

			FROM #tempZodiacSign_SeedSet

		SET @i += 1
	END





    /************************************************/
	/********* BEGIN MERGE INTO TARGET TABLE ********/
	/************************************************/
	MERGE astrology.Zodiac as t
		USING 
			(
				SELECT 
						temp.ZodiacName,
						temp.TropicalZodiacStartDate,
						temp.TropicalZodiacEndDate

				FROM #tempZodiacSign as temp
			) as s

		ON t.TropicalZodiacStartDate = s.TropicalZodiacStartDate

		WHEN MATCHED THEN UPDATE
			SET
				t.ZodiacName = s.ZodiacName,
				t.TropicalZodiacEndDate = s.TropicalZodiacEndDate

		WHEN NOT MATCHED THEN INSERT
			VALUES
				(
					s.ZodiacName,
					s.TropicalZodiacStartDate,
					s.TropicalZodiacEndDate
				)
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
		;
	/************************************************/
	/******************END MERGE ********************/
	/************************************************/

