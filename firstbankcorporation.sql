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
SELECT e.employee_name, e.city
FROM employee e
JOIN works w ON e.employee_name = w.employee_name
WHERE w.company_name = 'First Bank Corporation';

-- (c) Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.
SELECT e.employee_name, e.street, e.city
FROM employee e
JOIN works w ON e.employee_name = w.employee_name
WHERE w.company_name = 'First Bank Corporation' AND w.salary > 10000;

-- (d) Find all employees in the database who live in the same cities as the companies for which they work.
SELECT e.employee_name
FROM employee e
JOIN works w ON e.employee_name = w.employee_name
JOIN company c ON w.company_name = c.company_name
WHERE e.city = c.city;

-- (e) Find all employees in the database who live in the same cities and on the same streets as do their managers.
SELECT e.employee_name
FROM employee e
JOIN manages m ON e.employee_name = m.employee_name
JOIN employee mgr ON m.manager_name = mgr.employee_name
WHERE e.city = mgr.city AND e.street = mgr.street;

-- (f) Find all employees in the database who do not work for First Bank Corporation.
SELECT e.employee_name
FROM employee e
WHERE e.employee_name NOT IN (
    SELECT employee_name
    FROM works
    WHERE company_name = 'First Bank Corporation'
);

-- (g) Find all employees in the database who earn more than each employee of Small Bank Corporation.
SELECT e.employee_name
FROM employee e
JOIN works w ON e.employee_name = w.employee_name
WHERE w.salary > ALL (
    SELECT w2.salary
    FROM works w2
    WHERE w2.company_name = 'Small Bank Corporation'
);

-- (h) Find all companies located in every city in which Small Bank Corporation is located.
SELECT c.company_name
FROM company c
WHERE NOT EXISTS (
    SELECT city
    FROM company sc
    WHERE sc.company_name = 'Small Bank Corporation'
    AND sc.city NOT IN (
        SELECT city
        FROM company cc
        WHERE cc.company_name = c.company_name
    )
);

-- (i) Find all employees who earn more than the average salary of all employees of their company.
SELECT e.employee_name
FROM employee e
JOIN works w ON e.employee_name = w.employee_name
WHERE w.salary > (
    SELECT AVG(w2.salary)
    FROM works w2
    WHERE w2.company_name = w.company_name
);

-- (j) Find the company that has the most employees.
SELECT w.company_name
FROM works w
GROUP BY w.company_name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- (k) Find the company that has the smallest payroll.
SELECT w.company_name
FROM works w
GROUP BY w.company_name
ORDER BY SUM(w.salary) ASC
LIMIT 1;

-- (l) Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation.
SELECT c.company_name
FROM company c
JOIN works w ON c.company_name = w.company_name
GROUP BY c.company_name
HAVING AVG(w.salary) > (
    SELECT AVG(w2.salary)
    FROM works w2
    WHERE w2.company_name = 'First Bank Corporation'
);

-- Step 4: Verify Results
SELECT * FROM employee;
SELECT * FROM works;
SELECT * FROM company;
SELECT * FROM manages;
