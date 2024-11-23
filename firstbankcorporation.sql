-- Step 1: Create the Tables
CREATE TABLE employee (
    employee_name VARCHAR(50),
    street VARCHAR(100),
    city VARCHAR(100),
    PRIMARY KEY (employee_name)
);

CREATE TABLE works (
    employee_name VARCHAR(50),
    company_name VARCHAR(100),
    salary DECIMAL(10, 2),
    PRIMARY KEY (employee_name, company_name),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);

CREATE TABLE company (
    company_name VARCHAR(100),
    city VARCHAR(100),
    PRIMARY KEY (company_name)
);

CREATE TABLE manages (
    employee_name VARCHAR(50),
    manager_name VARCHAR(50),
    PRIMARY KEY (employee_name),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name),
    FOREIGN KEY (manager_name) REFERENCES employee(employee_name)
);

-- Step 2: Insert Data
-- Insert data into employee table
INSERT INTO employee VALUES 
('Jones', '123 Maple St', 'Oldtown'),
('Smith', '456 Oak St', 'Springfield'),
('Brown', '789 Pine St', 'Metropolis');

-- Insert data into company table
INSERT INTO company VALUES 
('First Bank Corporation', 'New York'),
('Small Bank Corporation', 'Los Angeles');

-- Insert data into works table
INSERT INTO works VALUES 
('Jones', 'First Bank Corporation', 80000),
('Smith', 'First Bank Corporation', 90000),
('Brown', 'Small Bank Corporation', 70000);

-- Insert data into manages table
INSERT INTO manages VALUES 
('Smith', 'Jones'),
('Brown', 'Smith');

-- Step 3: Perform Queries
-- (a) Modify the database so that Jones now lives in Newtown
UPDATE employee
SET city = 'Newtown'
WHERE employee_name = 'Jones';

-- (b) Give all employees of First Bank Corporation a 10 percent raise
UPDATE works
SET salary = salary * 1.1
WHERE company_name = 'First Bank Corporation';

-- (c) Give all managers of First Bank Corporation a 10 percent raise
UPDATE works
SET salary = salary * 1.1
WHERE employee_name IN (
    SELECT manager_name
    FROM manages
)
AND company_name = 'First Bank Corporation';

-- (d) Give all managers of First Bank Corporation a 10 percent raise unless 
-- the salary becomes greater than $100,000; in such cases, give only a 3 percent raise
-- Option 1: Using Multiple Queries
UPDATE works
SET salary = salary * 1.03
WHERE employee_name IN (
    SELECT manager_name
    FROM manages
)
AND salary * 1.1 > 100000
AND company_name = 'First Bank Corporation';

UPDATE works
SET salary = salary * 1.1
WHERE employee_name IN (
    SELECT manager_name
    FROM manages
)
AND salary * 1.1 <= 100000
AND company_name = 'First Bank Corporation';

-- Option 2: Using CASE (Concise Solution)
UPDATE works
SET salary = salary * 
    CASE
        WHEN salary * 1.1 > 100000 THEN 1.03
        ELSE 1.1
    END
WHERE employee_name IN (
    SELECT manager_name
    FROM manages
)
AND company_name = 'First Bank Corporation';

-- (e) Delete all tuples in the works relation for employees of Small Bank Corporation
DELETE FROM works
WHERE company_name = 'Small Bank Corporation';

-- Step 4: Verify Changes
-- Query to Check Tables
SELECT * FROM employee;
SELECT * FROM works;
SELECT * FROM company;
SELECT * FROM manages;
