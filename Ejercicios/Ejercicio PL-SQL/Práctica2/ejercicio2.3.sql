-- Genereamos una tabla TEMP
DROP TABLE temp;
CREATE TABLE temp(
col1 NUMBER(5),
col2 NUMBER(5),
msg CHAR(75));

/* Declaramos un cursor al que le pasamos el número de departamento
y carga de la tabla emp los datos de ese departamento */
DECLARE
	CURSOR c1 (departamento NUMBER) IS
		SELECT * FROM emp
		WHERE deptno = departamento;

	departamento NUMBER(5):='&departamento';
	columna1 temp.col1%TYPE:=0;
	columna2 temp.col2%TYPE:=0;
	mensaje VARCHAR2(60):='NOMINA TOTAL DEL DEPARTAMENTO '||departamento||' = ';
	saltotal NUMBER(8):=0;

-- INICIO
BEGIN
	FOR c1_reg IN c1(departamento) LOOP
	
		IF c1_reg.sal>2000 THEN
			columna1:=columna1+1;
		END IF;
		
		IF c1_reg.comm>c1_reg.sal THEN
			columna2:=columna2+1;
		END IF;
		
		saltotal:=saltotal+c1_reg.sal;
	END LOOP;
	-- Lo metemos en la tabla
	mensaje := mensaje || TO_CHAR(saltotal);
	INSERT INTO temp VALUES (columna1,columna2,mensaje);
END;
/




select * from emp where deptno=10;