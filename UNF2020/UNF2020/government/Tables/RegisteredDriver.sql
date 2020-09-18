CREATE TABLE government.[RegisteredDriver]
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
