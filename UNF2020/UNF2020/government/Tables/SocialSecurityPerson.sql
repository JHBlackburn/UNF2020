CREATE TABLE government.[SocialSecurityPerson]
(
	SocialSecurityNumber VARCHAR(100) NOT NULL PRIMARY KEY,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	Gender VARCHAR(10) NOT NULL,
	DateOfBirth DATE NOT NULL,
	HeightInInches INT NOT NULL
)
