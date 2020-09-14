create table jobs.Placement
(
	Id int not null primary key,
	PersonFirstName varchar (100) null,
	PersonLastName	varchar (100) null,
	PersonGender	varchar (100) null,
	CompanyName		varchar (100) null,
	CompanyCity		varchar (100) null,
	CompanyState	varchar (100) null,
	Industry		varchar(100) null,
	PositionTitle   varchar(100) null,
	StartYearlySalary decimal (14, 2) null,
	StartDate date null,
	EndDate date null
)

