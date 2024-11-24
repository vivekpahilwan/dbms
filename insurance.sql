-- Create Tables
CREATE TABLE Person (
    driver_id INT PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE Car (
    license VARCHAR(20) PRIMARY KEY,
    model VARCHAR(50),
    year INT
);

CREATE TABLE Accident (
    report_number INT PRIMARY KEY,
    date DATE,
    location VARCHAR(100)
);

CREATE TABLE Owns (
    driver_id INT,
    license VARCHAR(20),
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id) REFERENCES Person(driver_id),
    FOREIGN KEY (license) REFERENCES Car(license)
);

CREATE TABLE Participated (
    driver_id INT,
    license VARCHAR(20),
    report_number INT,
    damage_amount DECIMAL(10, 2),
    PRIMARY KEY (driver_id, license, report_number),
    FOREIGN KEY (driver_id) REFERENCES Person(driver_id),
    FOREIGN KEY (license) REFERENCES Car(license),
    FOREIGN KEY (report_number) REFERENCES Accident(report_number)
);

-- Insert Data into Tables
INSERT INTO Person VALUES (1, 'John Smith', '123 Elm St');
INSERT INTO Person VALUES (2, 'Jane Doe', '456 Oak St');
INSERT INTO Person VALUES (3, 'Mike Jones', '789 Pine St');

INSERT INTO Car VALUES ('AABB2000', 'Mazda', 2015);
INSERT INTO Car VALUES ('CCDD3000', 'Toyota', 2018);
INSERT INTO Car VALUES ('EEFF4000', 'Ford', 2020);

INSERT INTO Owns VALUES (1, 'AABB2000');
INSERT INTO Owns VALUES (2, 'CCDD3000');
INSERT INTO Owns VALUES (3, 'EEFF4000');

INSERT INTO Accident VALUES (4001, '1989-05-15', 'New York');
INSERT INTO Accident VALUES (4002, '1989-07-20', 'Los Angeles');
INSERT INTO Accident VALUES (4003, '1989-12-01', 'Chicago');

INSERT INTO Participated VALUES (1, 'AABB2000', 4001, 1500.00);
INSERT INTO Participated VALUES (2, 'CCDD3000', 4002, 2000.00);
INSERT INTO Participated VALUES (3, 'EEFF4000', 4003, 2500.00);

-- Query 1: Find the total number of people who owned cars involved in accidents in 1989
SELECT COUNT(DISTINCT Person.name) AS TotalPeople
FROM Person
JOIN Participated ON Person.driver_id = Participated.driver_id
JOIN Accident ON Participated.report_number = Accident.report_number
WHERE Accident.date BETWEEN '1989-01-01' AND '1989-12-31';

-- Query 2: Find the number of accidents involving cars belonging to “John Smith”
SELECT COUNT(*) AS AccidentsCount
FROM Accident
WHERE EXISTS (
    SELECT 1
    FROM Participated
    JOIN Owns ON Participated.license = Owns.license
    JOIN Person ON Owns.driver_id = Person.driver_id
    WHERE Person.name = 'John Smith'
    AND Accident.report_number = Participated.report_number
);

-- Query 3: Add a new accident to the database
INSERT INTO Accident VALUES (4007, '2001-09-01', 'Berkeley');
INSERT INTO Participated 
SELECT Owns.driver_id, Car.license, 4007, 3000.00
FROM Person
JOIN Owns ON Person.driver_id = Owns.driver_id
JOIN Car ON Owns.license = Car.license
WHERE Person.name = 'Mike Jones' AND Car.model = 'Toyota';

-- Query 4: Delete the Mazda belonging to “John Smith”
DELETE FROM Car
WHERE license IN (
    SELECT Owns.license
    FROM Owns
    JOIN Person ON Owns.driver_id = Person.driver_id
    WHERE Person.name = 'John Smith' AND Owns.license IN (
        SELECT Car.license
        FROM Car
        WHERE Car.model = 'Mazda'
    )
);

-- Query 5: Update the damage amount for a specific accident
UPDATE Participated
SET damage_amount = 3000.00
WHERE report_number = 4001
AND license = 'AABB2000';

-- End of File
