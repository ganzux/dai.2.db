-- Genereamos una tabla TEMP
DROP TABLE temp;
CREATE TABLE temp(
col1 NUMBER(9,2),
col2 NUMBER(9,2),
msg CHAR(40),
fecha date
);

DECLARE
	cont1 NUMBER(2):=1;
	cont2 NUMBER(2):=1;
	
BEGIN
	LOOP
		cont2:=1;
		LOOP
			INSERT INTO temp VALUES(cont1,cont2,'EN BUCLE EXTERNO',SYSDATE);
			cont2:=cont2+1;
			EXIT WHEN cont2=5;
		END LOOP;
		cont1:=cont1+1;
	EXIT WHEN cont1=6;
	END LOOP;
END;
/