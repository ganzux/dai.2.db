--Creación de la tabla TEMP
DROP TABLE temp;
CREATE TABLE temp(
salario NUMBER(10),
numeroemp NUMBER(10),
nombre VARCHAR2(15));

-- Inicio
DECLARE
	-- Declaramos el cursor c1
	CURSOR c1 IS
		SELECT sal,empno,ename
		FROM emp
		ORDER BY sal DESC;
	-- Y la varialbe lectora
	c1_rec c1%ROWTYPE;
	
	-- Y una variable para el número de repeticiones
	repeticiones NUMBER(2):='&repeticiones';

BEGIN
OPEN c1;
	LOOP
		FETCH c1 INTO c1_rec;
		EXIT WHEN c1%NOTFOUND OR repeticiones=0;
		INSERT INTO temp VALUES (c1_rec.sal,c1_rec.empno,c1_rec.ename);
		repeticiones:=repeticiones-1;
	END LOOP;
CLOSE c1;	
END;
/



select * from temp;