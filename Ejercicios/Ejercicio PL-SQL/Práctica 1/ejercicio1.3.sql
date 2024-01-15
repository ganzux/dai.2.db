-- Creamos la tabla cat_emp
DROP TABLE cat_emp;
CREATE TABLE cat_emp(
id_emp NUMBER(4) PRIMARY KEY,
empleado VARCHAR2(10),
categ VARCHAR2(1));

DECLARE
	-- Declaramos el numero de empleado pidiéndolo
	num_emp NUMBER(5):='&num_emp';
	categoria CHAR(1):='D';
	temp emp.sal%TYPE;
	nombre emp.ename%TYPE;
	
BEGIN
	SELECT sal,ename INTO temp,nombre FROM emp WHERE empno=num_emp;

	IF temp<3000 THEN
		categoria:='C';
	ELSIF temp<=4000 THEN
		categoria:='B';
	ELSE
		categoria:='A';
	END IF;
	
	INSERT INTO cat_emp VALUES (num_emp,nombre,categoria);
END;
/