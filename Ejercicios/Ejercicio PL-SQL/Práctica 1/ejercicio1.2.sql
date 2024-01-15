-- Genereamos una tabla TEMP
DROP TABLE temp;
CREATE TABLE temp(
col1 NUMBER(9,2),
col2 NUMBER(9,2),
msg CHAR(40),
fecha date
);

-- Sentencia PL / SQL
DECLARE
	contador temp.col1%TYPE:=1;
	cadena temp.msg%TYPE;
	
BEGIN
LOOP
	-- Si el módulo de contador entre 2 es cero
	IF MOD(contador,2) = 0 THEN
		cadena:=TO_CHAR(contador)||' es par';
	-- Si no, es que es impar
	ELSE
		cadena:=TO_CHAR(contador)||' es impar';
	END IF;
	-- Lo insertamos en la tabla
	INSERT INTO temp VALUES(contador,contador*100,cadena,SYSDATE);
	-- Y sumamos uno al contador
	contador:=contador+1;
	-- Saliendo cuando el contador haya hecho el 10
	EXIT WHEN contador = 11;
END LOOP;
-- Guardamos
COMMIT;
END;
/
