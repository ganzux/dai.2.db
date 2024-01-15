---------------- 1 ----------------
DROP TABLE viajes2;

CREATE TABLE viajes2
	AS SELECT viajes.codigo, viajes.plazas, plazas-SUM(num_plazas) AS libres
	FROM reservas, viajes
	WHERE reservas.codigo_v = viajes.codigo
	GROUP BY plazas,codigo;
	
SELECT * FROM viajes2;
	
	
---------------- 2 ----------------
ALTER TABLE viajes2
	ADD CONSTRAINT pk_viajes2 PRIMARY KEY (codigo)
	ADD CONSTRAINT fk_viajes2 FOREIGN KEY (codigo) REFERENCES viajes
	ADD CONSTRAINT ck_viajes2 CHECK (plazas>19)
	ADD CONSTRAINT ck2_viajes2 CHECK (libres<=plazas);


---------------- 3 ----------------
CREATE OR REPLACE VIEW ingresos
	AS SELECT  clientesv.codigo, clientesv.nombre, count(*) "total reservas", SUM( viajes.precio ) "total pelas"
	from clientesv INNER JOIN reservas
	ON clientesv.codigo = reservas.codigo_c
	JOIN viajes
	ON viajes.codigo = reservas.codigo_v
	group by clientesv.nombre,clientesv.codigo;

select * from ingresos;

---------------- 4 ----------------
--- Creamos la secuencia:
DROP SEQUENCE mi_primera_vez_XD;
CREATE SEQUENCE mi_primera_vez_XD
	START WITH 40000;
--- Creamos una columna
ALTER TABLE clientesv
	ADD (viejo_cod CHAR(5));
---  y metemos los códigos allí
UPDATE clientesv cv1
	SET viejo_cod = codigo;
--- Deshabilitamos las restricciones:
ALTER TABLE reservas
DISABLE CONSTRAINT FK1_RES
DISABLE CONSTRAINT FK2_RES
DISABLE CONSTRAINT PK_RES;
--- Pasamos a la columna CODIGO los datos de la SEQUENCE
UPDATE clientesv
	SET codigo = mi_primera_vez_XD.nextval;
	
select * from clientesv order by viejo_cod;

SELECT
		clientesv.codigo
		FROM clientesv,reservas r
		WHERE clientesv.viejo_cod = r.codigo_c;


--- Cambiamos el codigo_c de la tabla RESERVAS por el nuevo
UPDATE reservas r
	SET codigo_c = (SELECT
		clientesv.codigo
		FROM clientesv
		WHERE clientesv.viejo_cod = r.codigo_c);
		
select * from reservas;




ALTER TABLE reservas
ENABLE CONSTRAINT FK1_RES
ENABLE CONSTRAINT FK2_RES
ENABLE CONSTRAINT PK_RES;