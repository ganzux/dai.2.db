-- Genereamos una tabla TEMP
DROP TABLE temp;
CREATE TABLE temp(
col1 NUMBER(9,2),
col2 NUMBER(9,2),
msg CHAR(40),
fecha date
);

-- Variables
DECLARE
	cod_cli NUMBER(5):='&cod_cli';
	nombrec CHAR(10);
	plazas temp.col1%TYPE:=0;
	preciototal temp.col2%TYPE:=0;
BEGIN
	-- Damos valor a la variable nombrec
	SELECT nombre INTO nombrec
	FROM clientesv
	WHERE codigo=cod_cli;
	
	-- Damos valor a la variable plazas
	SELECT SUM(num_plazas) INTO plazas
	FROM reservas
	WHERE codigo_c=cod_cli;
	
	-- Y por último al costetotal:
	SELECT SUM(precio*num_plazas) INTO preciototal
	FROM reservas, viajes
	WHERE reservas.codigo_v=viajes.codigo
	AND codigo_c=cod_cli;
	
	-- Lo insertamos en la tabla TEMP
	INSERT INTO temp VALUES (plazas,preciototal,cod_cli||', '||nombrec,SYSDATE);
END;
/



SELECT * FROM temp;