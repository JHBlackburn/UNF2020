/*DEMO Day 1 - UNF SQL Class */

/*****************************/
/********SELECT Demos*********/
/*****************************/

/* Can SELECT literals to print them to the screen*/
select 999


/* Can alias SELECTed columns*/
select 999 as MyFavoriteNumber

select 'Hello from inside the computer AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH' as ThisMessage


/* Can  SELECT multiple things by separating them by a comma*/
select 999 as MyFavoriteNumber, 666 as MyLeastFavoriteNumber


/* SQL has a ton of built in functions*/
select 
	DATEDIFF(DAY, GETDATE(), '2020-12-31') as DaysUntil2020IsFinallyOver, 
	DATEDIFF(MINUTE, GETDATE(), '2020-12-31') as MinutesUntil2020IsFinallyOver,
	DATEDIFF(SECOND, GETDATE(), '2020-12-31') as SecondsUntil2020IsFinallyOver

SELECT PI() as PI


/*SQL can also do math*/
SELECT 
	5+5 as Sum, 
	5-5 as Difference, 
	5*5 as Product, 
	5/5 as Quotient,
	POWER(5, 3) as [5To3Power]


/*Let's Try nonb-integer division*/
SELECT 8/3 as [Integer-Rounded Division]

/*The importance of datatypes*/
SELECT CAST(8 as decimal) / CAST(3 as decimal) as [Non-Integer Value]

SELECT 8 /3.0 as [Implicit Cast]



/* A Word on Aliasing */
SELECT
	ANumber = 898,
	7866 AS AnotherNumber,
	7453 YetAnotherNumber

/* SELECT STATEMENTS can have CASE Logic in them*/
SELECT (CASE 
			WHEN DATEPART(SECOND, GETDATE()) % 2 = 0 THEN 'EVEN SECOND'
			ELSE 'ODD SECOND' 
		END) as IsThisSecondEvenOrOdd



/*****************************/
/********FROM Demos*********/
/*****************************/

Select *
from jobs.Placement

/* Can restrict the columns returned if we choose*/
Select 
	Id, 
	PersonFirstName, 
	PersonLastName, 
	PersonGender, 
	StartDate
FROM jobs.Placement

/* Note the Order is NOT Deterministic can change depending on SQL Server's mode that day*/
Select 
	Id, 
	PersonFirstName, 
	PersonLastName, 
	PersonGender, 
	StartDate
FROM jobs.Placement
ORDER BY PersonLastName, PersonFirstName, StartDate





/*****************************/
/********WHERE Demos*********/
/*****************************/

Select *
from jobs.Placement
WHERE PersonFirstName = 'Brandon'

Select *
from jobs.Placement
WHERE PersonLastName = 'Anderson'


Select *
from jobs.Placement
WHERE PersonGender = 'FeMaLe'

Select *
from jobs.Placement
WHERE CompanyCity = 'Jacksonville'

/*check out the cardinality in the bottom right*/
--always true (might as well not have the where)
select * 
from jobs.Placement
where 2=2

--always false (might as well not even write the SQL at all)
select * 
from jobs.Placement
where 2=3


/*Let's talk about NULLs*/
select * 
FROM jobs.Placement
WHERE EndDate = null


/*weird right?!*/
--Even this doesn't work
select * 
FROM jobs.Placement
WHERE null = null



-- We can do calculations in the where clause

select * 
FROM jobs.Placement
WHERE EndDate >= GETDATE()

select * 
FROM jobs.Placement
WHERE LEFT(PositionTitle,1) = 'p'


/*We can do logic too!*/
Select *
from jobs.Placement
WHERE CompanyCity = 'Jacksonville' AND CompanyState = 'GA'

Select *
from jobs.Placement
WHERE CompanyCity = 'Jacksonville' OR CompanyState = 'GA'


Select *
from jobs.Placement
WHERE PersonFirstName = 'Ashley' AND CompanyCity = 'Jacksonville' 
OR PersonFirstName = 'Michael' AND Industry = 'Oil And Gas'




/*****************************/
/********GROUP BY Demos*******/
/*****************************/

/*whenever the grain of your table is lower than the report you need to write, you may need a group by*/
select * 
from jobs.Placement

/* get all the distinct peoplewho have been placed by VoTech no matter how many time*/
Select 
	PersonFirstName,
	PersonLastName 
FROM jobs.Placement
Group By 
	PersonFirstName, 
	PersonLastName

/* what happens here? why?*/
Select 
	PersonFirstName,
	PersonLastName,
	Id
FROM jobs.Placement
Group By 
	PersonFirstName, 
	PersonLastName

/* group by is usually used to get either find a special value or get statistical data*/
Select 
	PersonFirstName,
	PersonLastName,
	max(StartDate) as LatestPlacementStartDate
FROM jobs.Placement
Group By 
	PersonFirstName, 
	PersonLastName

/* can be used in conjunction with a WHERE clause*/
Select 
	PersonFirstName,
	PersonLastName,
	max(StartDate) as LatestPlacementStartDate
FROM jobs.Placement
WHERE PersonGender = 'Male'
Group By 
	PersonFirstName, 
	PersonLastName


/*There is Power in data*/
Select 
	PersonFirstName,
	PersonLastName,
	max(StartDate) as LatestPlacementStartDate,
	AVG(DATEDIFF(MONTH, StartDate, ISNULL(EndDate, GETDATE()))) as AverageMonthsPerPlacement,
	MAX(DATEDIFF(MONTH, StartDate, ISNULL(EndDate, GETDATE()))) as LongestTenureAnyPlacement,
	AVG(StartYearlySalary) as AverageStartingSalaryUSD,
	MAX(StartYearlySalary) as MaximumStartingSalaryUSD
FROM jobs.Placement
Group By 
	PersonFirstName, 
	PersonLastName


/*group by challage time*/

/*code together: analyze the average starting salary over time at CSX*/




/*****************************/
/********HAVING Demos*******/
/*****************************/

/* adds another layer of analysis to you query after grouping */
Select 
	PersonFirstName,
	PersonLastName,
	COUNT(Id) as CountOfPlacements,
	max(StartDate) as LatestPlacementStartDate,
	AVG(DATEDIFF(MONTH, StartDate, ISNULL(EndDate, GETDATE()))) as AverageMonthsPerPlacement,
	MAX(DATEDIFF(MONTH, StartDate, ISNULL(EndDate, GETDATE()))) as LongestTenureAnyPlacement,
	AVG(StartYearlySalary) as AverageStartingSalaryUSD,
	MAX(StartYearlySalary) as MaximumStartingSalaryUSD
FROM jobs.Placement
GROUP BY
	PersonFirstName, 
	PersonLastName
HAVING COUNT(Id) >= 3


Select 
	PersonFirstName,
	PersonLastName,
	COUNT(Id) as CountOfPlacements,
	max(StartDate) as LatestPlacementStartDate,
	AVG(DATEDIFF(MONTH, StartDate, ISNULL(EndDate, GETDATE()))) as AverageMonthsPerPlacement,
	MAX(DATEDIFF(MONTH, StartDate, ISNULL(EndDate, GETDATE()))) as LongestTenureAnyPlacement,
	AVG(StartYearlySalary) as AverageStartingSalaryUSD,
	MAX(StartYearlySalary) as MaximumStartingSalaryUSD
FROM jobs.Placement
GROUP BY
	PersonFirstName, 
	PersonLastName
HAVING AVG(DATEDIFF(MONTH, StartDate, ISNULL(EndDate, GETDATE()))) < 12 --people with an avg tenure of less than 12 months