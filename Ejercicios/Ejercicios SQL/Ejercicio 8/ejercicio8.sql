DROP TABLE llamadas;
DROP TABLE horario;
DROP TABLE abonados;

-- Exportamos las tablas a ORACLE

-- En horario y llamadas creamos una columna NUMBER (7,2)
ALTER TABLE horario
	ADD (pasos NUMBER(7,2));
ALTER TABLE llamadas
	ADD (pasos NUMBER(7,2));

-- Pasamos HORARIO.PREC_PASO y LLAMADAS.NUMER_PASOS a números a la nueva columna
UPDATE horario
	SET pasos = TO_NUMBER (prec_paso);
UPDATE llamadas
	SET pasos = TO_NUMBER (numer_pasos);
commit;

-- Borramos la columna de texto
ALTER TABLE horario
	DROP COLUMN prec_paso;
ALTER TABLE llamadas
	DROP COLUMN numer_pasos;

-- Renombramos la nueva columna como la vieja
ALTER TABLE horario
	RENAME COLUMN pasos TO prec_paso;
ALTER TABLE llamadas
	RENAME COLUMN pasos TO numer_pasos;

------------------------------------------------------------------------------------------------------------------------------

-- Punto 1:    Relaciones de Integridad

-- Tabla LLAMADAS: NUMER_TELEF es FK hacia NUMER_TELEFONO de la tabla ABONADOS
-- Tabla LLAMADAS: IDENT_HORAR es FK hacia IDENT_HORAR de la tabla HORARIO
-- Tabla LLAMADAS: IDENT_LLAMADA ES PK
DROP CONSTRAINT pk_llamadas;
ALTER TABLE llamadas
	ADD CONSTRAINT pkllamadas PRIMARY KEY (ident_llamada);
ALTER TABLE llamadas
	ADD CONSTRAINT fkhaciaabonados FOREIGN KEY (numer_telef) REFERENCES abonados;
ALTER TABLE llamadas
	ADD CONSTRAINT fkhaciahorario FOREIGN KEY (ident_horar) REFERENCES horario;
-- Tabla ABONADOS: NUMER_TELEF es PK
ALTER TABLE abonados
	ADD CONSTRAINT pkabonados PRIMARY KEY (numer_telef);
-- Tabla HORARIO: IDENT_HORAR es PK
ALTER TABLE horario
	ADD CONSTRAINT pkhorario PRIMARY KEY (ident_horar);


-- Punto 2:    Vista
CREATE OR REPLACE VIEW vista2 (Tipo, "Número de llamadas", "importe total")
	AS SELECT horario.tipo, count(*), SUM(numer_pasos*prec_paso)
	FROM horario, llamadas
	WHERE horario.ident_horar = llamadas.ident_horar
	GROUP BY horario.tipo;
	
SELECT * FROM vista2;


-- Punto 3:    Consulta
SELECT nombr_abonado, tipo, COUNT(*) "Tipo"
FROM abonados, llamadas, horario
WHERE abonados.numer_telef = llamadas.numer_telef
AND horario.ident_horar = llamadas.ident_horar
GROUP BY nombr_abonado, tipo;


-- Punto 4:   Actualización
UPDATE horario
SET prec_paso = prec_paso + 0.1*prec_paso
WHERE tipo ='1' OR tipo = '2';