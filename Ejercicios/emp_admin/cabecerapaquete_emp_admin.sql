CREATE OR REPLACE PACKAGE emp_admin AS
-- Declaración externa de tipos ,cursor y exception publicos
TYPE EmpRecTyp IS RECORD (emp_id NUMBER, sal NUMBER);
CURSOR desc_salary RETURN EmpRecTyp;
invalid_salary EXCEPTION;
-- Declaración de procedimientos y funciones publicos
FUNCTION hire_employee (last_name VARCHAR2, first_name VARCHAR2,
email VARCHAR2, phone_number VARCHAR2, job_id VARCHAR2, salary NUMBER,
commission_pct NUMBER, manager_id NUMBER, department_id NUMBER)
RETURN NUMBER;
PROCEDURE fire_employee (emp_id NUMBER); -- overloaded subprogram
PROCEDURE fire_employee (emp_email VARCHAR2); -- overloaded subprogram
PROCEDURE raise_salary (emp_id NUMBER, amount NUMBER);
FUNCTION nth_highest_salary (n NUMBER) RETURN EmpRecTyp;
END emp_admin;
/

