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
INSERT INTO employee VALUES 
('Jones', '123 Maple St', 'Oldtown'),
('Smith', '456 Oak St', 'Springfield'),
('Brown', '789 Pine St', 'Metropolis'),
('Miller', '222 Elm St', 'New York'),
('Taylor', '111 Birch St', 'Los Angeles');

INSERT INTO company VALUES 
('First Bank Corporation', 'New York'),
('Small Bank Corporation', 'Los Angeles');

INSERT INTO works VALUES 
('Jones', 'First Bank Corporation', 80000),
('Smith', 'First Bank Corporation', 90000),
('Brown', 'Small Bank Corporation', 70000),
('Miller', 'First Bank Corporation', 120000),
('Taylor', 'Small Bank Corporation', 95000);

INSERT INTO manages VALUES 
('Smith', 'Jones'),
('Brown', 'Smith'),
('Miller', 'Taylor');

-- Step 3: Queries

-- (a) Find the names of all employees who work for First Bank Corporation.
SELECT employee_name
FROM works
WHERE company_name = 'First Bank Corporation';

-- (b) Find the names and cities of residence of all employees who work for First Bank Corporation.
SELECT employee.employee_name, employee.city
FROM employee
JOIN works ON employee.employee_name = works.employee_name
WHERE works.company_name = 'First Bank Corporation';

-- (c) Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.
SELECT employee.employee_name, employee.street, employee.city
FROM employee
JOIN works ON employee.employee_name = works.employee_name
WHERE works.company_name = 'First Bank Corporation' AND works.salary > 10000;

-- (d) Find all employees in the database who live in the same cities as the companies for which they work.
SELECT employee.employee_name
FROM employee
JOIN works ON employee.employee_name = works.employee_name
JOIN company ON works.company_name = company.company_name
WHERE employee.city = company.city;

-- (e) Find all employees in the database who live in the same cities and on the same streets as do their managers.
SELECT employee.employee_name
FROM employee
JOIN manages ON employee.employee_name = manages.employee_name
JOIN employee AS manager ON manages.manager_name = manager.employee_name
WHERE employee.city = manager.city AND employee.street = manager.street;

-- (f) Find all employees in the database who do not work for First Bank Corporation.
SELECT employee.employee_name
FROM employee
WHERE employee.employee_name NOT IN (
    SELECT works.employee_name
    FROM works
    WHERE works.company_name = 'First Bank Corporation'
);

-- (g) Find all employees in the database who earn more than each employee of Small Bank Corporation.
SELECT employee.employee_name
FROM employee
JOIN works ON employee.employee_name = works.employee_name
WHERE works.salary > ALL (
    SELECT works.salary
    FROM works
    WHERE works.company_name = 'Small Bank Corporation'
);

-- (h) Find all companies located in every city in which Small Bank Corporation is located.
SELECT company.company_name
FROM company
WHERE NOT EXISTS (
    SELECT company.city
    FROM company AS small_bank
    WHERE small_bank.company_name = 'Small Bank Corporation'
    AND small_bank.city NOT IN (
        SELECT company.city
        FROM company
        WHERE company.company_name = company.company_name
    )
);

-- (i) Find all employees who earn more than the average salary of all employees of their company.
SELECT employee.employee_name
FROM employee
JOIN works ON employee.employee_name = works.employee_name
WHERE works.salary > (
    SELECT AVG(works.salary)
    FROM works
    WHERE works.company_name = works.company_name
);

-- (j) Find the company that has the most employees.
SELECT works.company_name
FROM works
GROUP BY works.company_name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- (k) Find the company that has the smallest payroll.
SELECT works.company_name
FROM works
GROUP BY works.company_name
ORDER BY SUM(works.salary) ASC
LIMIT 1;

-- (l) Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation.
SELECT company.company_name
FROM company
JOIN works ON company.company_name = works.company_name
GROUP BY company.company_name
HAVING AVG(works.salary) > (
    SELECT AVG(works.salary)
    FROM works
    WHERE works.company_name = 'First Bank Corporation'
);

-- Step 4: Verify Results
SELECT * FROM employee;
SELECT * FROM works;
SELECT * FROM company;
SELECT * FROM manages;
