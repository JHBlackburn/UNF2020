
/*****************************************************/
/*****************More WHERE Practice ****************/
/*****************************************************/

/*EQUALS*/

	--strings go in quotes
	SELECT * 
	FROM jobs.Placement
	WHERE PersonFirstName = 'ashley'

	--use quotes for dates
	SELECT * 
	FROM jobs.Placement
	WHERE StartDate = '2020-01-01'

	--no quotes needed for numbers 
	SELECT * 
	FROM jobs.Placement
	WHERE StartYearlySalary = 64452.49

/* NOT EQUALS*/

	--all placements where the company is not based in jacksonville
	SELECT *
	FROM jobs.Placement
	WHERE CompanyCity != 'Jacksonville' -- Notice: != is (microsoft) T-SQL

	--all placements where the company is not based in Georgia
	SELECT *
	FROM jobs.Placement
	WHERE CompanyState <> 'GA' -- Notice: <> is ANSI SQL


/*string comparison*/

	--containing the word 'developer'
	SELECT *
	FROM jobs.Placement
	WHERE PositionTitle like '%developer%'

	--starts with the word 'BUSINESS'
	SELECT *
	FROM jobs.Placement
	WHERE PositionTitle like 'BUSINESS%'

	
	--ends with the word 'analyst'
	SELECT *
	FROM jobs.Placement
	WHERE PositionTitle like '%analyst'


/*LOGICAL OR*/
	--All placements with the city is Jacksonville or Gainesville
	SELECT *
	FROM jobs.Placement
	WHERE CompanyCity = 'Jacksonville' OR CompanyCity = 'Gainesville'

	-- when you have longer lists of OR's you can use the IN operator
	SELECT *
	FROM jobs.Placement
	WHERE CompanyCity IN ('Jacksonville', 'Gainesville')


/*LOGICAL NOT (COMPLEMENT)*/
	-- add NOT in front of anything that resolves to true or false to get the opposite
	SELECT *
	FROM jobs.Placement
	WHERE NOT (CompanyCity IN ('Jacksonville', 'Gainesville'))

	--exactly the same as this more obvious syntax
	SELECT *
	FROM jobs.Placement
	WHERE CompanyCity NOT IN ('Jacksonville', 'Gainesville')



	-- all the people making more that 150k
	SELECT *
	FROM jobs.Placement
	WHERE NOT (StartYearlySalary < 150000)

	-- all the people NOT working at CSX, Suddath, Crowley, or Florida east coast
	SELECT *
	FROM jobs.Placement
	WHERE CompanyName NOT IN ('CSX', 'Suddath', 'Crowley', 'Florida East Coast')




/*Greater than Less Than for numbers and dates*/

	--All Placements with Salary's (strictly) less than 40k
	SELECT *
	FROM jobs.Placement
	WHERE StartYearlySalary < 40000

	--All Placements with Salary's (strictly) greater than 150k
	SELECT *
	FROM jobs.Placement
	WHERE StartYearlySalary > 150000

	
	--All Placements with after the start of 2020 (including new years)
	SELECT *
	FROM jobs.Placement
	WHERE StartDate >= '1/1/2020'

	--All Placements that left their position in 2020 before corona virus shutdown (3/1/2020) (exclusive)
	SELECT *
	FROM jobs.Placement
	WHERE EndDate >= '2020-01-01' AND EndDate < '2020-03-01'
	-- below statement is equivilent using the BETWEEN keyword
	SELECT *
	FROM jobs.Placement
	WHERE EndDate BETWEEN '2020-01-01' AND '2020-02-29'


	-- anyone who left a job in the last month (rolling)
	SELECT *
	FROM jobs.Placement
	WHERE EndDate BETWEEN DATEADD(MONTH, -1, GETDATE()) AND GETDATE()


/*ORDER OF OPERATIONS and using Parenthasis*/

		-- use parenthases with OR's when AND's are around
		SELECT *
		FROM jobs.Placement
		where StartYearlySalary> 100000 
		AND ( MONTH(StartDate) = 8 OR MONTH(StartDate) = 9 )


		-- if you DO mean to apply the AND first, it's a good idea to use parenthasis or formatting to alert users you did it on purpose
		SELECT *
		FROM jobs.Placement
		where (StartYearlySalary> 100000 AND MONTH(StartDate) = 8) OR MONTH(StartDate) = 9

		-- the same applies to using the NOT operator
		SELECT *
		FROM jobs.Placement
		where NOT (StartYearlySalary> 100000 AND MONTH(StartDate) = 8)

		-- ...is different that
		SELECT *
		FROM jobs.Placement
		where NOT StartYearlySalary> 100000 AND MONTH(StartDate) = 8


	-- DO QUIZ 2 (on WHERE)
	--answers to quiz 2
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------

	--1. All drivers that got their drivers license in 2003 or after
	select * 
	from government.RegisteredDriver
	where IssuedDate >= '1/1/2003'



	--2. All drivers with license revoked between the start of 2020 and today
	select * 
	from government.RegisteredDriver
	where  DriversLicenseStatus = 'Revoked' 
	and RevokedDate >= '2020-01-01'



	-- 3. All drivers with a license that was issued in the 1980s
	--using between
	select * 
	from government.RegisteredDriver
	where  IssuedDate between '1980-01-01'and '1989-12-31'

	--or using > , <
	select * 
	from government.RegisteredDriver
	where  IssuedDate >= '1980-01-01' and IssuedDate < '1990-01-01'



	-- 4. All male drivers with a height between 5 and 6 feet (inclusive)
	select * 
	from government.RegisteredDriver
	where  
		Gender = 'male' 
		and HeightInInches >= 60 
		and HeightInInches <= 72

	--5. All drivers with a suspended license that are either (strictly) shorter than 5 feet were born before WWII (12/7/1941)
	-- fix this to make it correct
	select * 
	from government.RegisteredDriver
	where DriversLicenseStatus = 'suspended'
	AND (HeightInInches < 60 
	OR DateOfBirth < '1941-12-07')



