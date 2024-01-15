------------------      Ejercicio 1      ------------------
-- Creamos la tabla provisional
DROP TABLE tit_aut_nac;
CREATE TABLE tit_aut_nac(
titulo VARCHAR2(150),
autor VARCHAR2(150),
nacionalidad VARCHAR2(150)
);
-- Creamos el fichero CONTROL.CTL
-- Llamada a control.ctl desde consola de comandos (prompt):
-- sqlldr userid=alvaro@orcl/alcedo control=A:\control.ctl log=A:\registro.log
-- Comprobamos: select * from tit_aut_nac;
----------------      Fin Ejercicio 1      ----------------



------------------      Ejercicio 2      ------------------
DROP TABLE nacionalidades;
CREATE TABLE nacionalidades(
id NUMBER,
nacionalidad VARCHAR2(150)
);

DROP TABLE autores;
CREATE TABLE autores(
id NUMBER,
autor VARCHAR2(150),
id_nac NUMBER
);

DROP TABLE titulos;
CREATE TABLE titulos(
id NUMBER,
titulo VARCHAR2(150),
id_aut NUMBER
);
----------------      Fin Ejercicio 2      ----------------



------------------      Ejercicio 3      ------------------

-- Primeramente creamos tres SEQUENCES
DROP SEQUENCE nac_sequence;
CREATE SEQUENCE nac_sequence;

DROP SEQUENCE aut_sequence;
CREATE SEQUENCE aut_sequence;

DROP SEQUENCE tit_sequence;
CREATE SEQUENCE tit_sequence;
----------------      Fin Ejercicio 3      ----------------



------------------      Ejercicio 4      ------------------
-- Acto seguido cargamos de datos cada una de las tablas

-- Tabla nacionalidades:
INSERT INTO nacionalidades(nacionalidad)
SELECT DISTINCT (nacionalidad) FROM tit_aut_nac;
UPDATE nacionalidades
SET id=nac_sequence.nextval;

-- Tabla  autores:
INSERT INTO autores(autor)
SELECT DISTINCT (autor) FROM tit_aut_nac;
-- En autores,rellenamos la tercera columna:
UPDATE autores a
SET a.id_nac = (SELECT DISTINCT n.id
				FROM nacionalidades n, tit_aut_nac nat, autores a2
				WHERE n.nacionalidad = nat.nacionalidad
				AND nat.autor = a2.autor
				AND a2.autor = a.autor);
UPDATE autores
SET id=aut_sequence.nextval;

-- Tabla titulos:
INSERT INTO titulos(titulo)
SELECT (titulo) FROM tit_aut_nac;
UPDATE titulos t
SET id_aut = (SELECT DISTINCT a.id
			  FROM autores a, titulos t2, tit_aut_nac nat
			  WHERE a.autor = nat.autor
			  AND nat.titulo = t2.titulo
			  AND t2.titulo = t.titulo);
UPDATE titulos
SET id=tit_sequence.nextval;
----------------      Fin Ejercicio 4      ----------------



------------------      Ejercicio 5      ------------------

-- Tabla Nacionalidades: id es PK y nacionalidad es UNIQUE
ALTER TABLE nacionalidades
ADD CONSTRAINT pk_nacionalidades PRIMARY KEY (id);
ALTER TABLE nacionalidades
ADD CONSTRAINT unica_nacionalidad UNIQUE (nacionalidad);

-- Tabla Autores: id es PK, id_nac es FK hacia nacionalidades y autor es único
ALTER TABLE autores
ADD CONSTRAINT pk_autores PRIMARY KEY (id);
ALTER TABLE autores
ADD CONSTRAINT fk_autores FOREIGN KEY (id_nac) REFERENCES nacionalidades;
ALTER TABLE autores
ADD CONSTRAINT unico_autor UNIQUE (autor);

-- Tabla Títulos: id es PK e id_aut es FK hacia Autores
ALTER TABLE titulos
ADD CONSTRAINT pk_titulos PRIMARY KEY (id);
ALTER TABLE titulos
ADD CONSTRAINT fk_titulos FOREIGN KEY (id_aut) REFERENCES autores;

--- Dado que hemos puesto restricciones de integridad, a la hora de borrar las tablas tendremos que hacerlo
--- en orden (primero borraremos títulos, luego autores y por último nacionalidades), o si no incluiremos la
--- cláusula [CASCADE CONSTRAINTS] para no tener que preocuparnos de las mismas.
----------------      Fin Ejercicio 5      ----------------



------------------      Ejercicio 6      ------------------

-- Primera SELECT
SELECT COUNT(*) "Número de Títulos", nacionalidad
FROM autores, titulos, nacionalidades
WHERE autores.id = titulos.id_aut
AND id_nac = nacionalidades.id
group by nacionalidad;

-- Segunda SELECT
SELECT TOP 1 autor, COUNT(*)
FROM autores, titulos
WHERE autores.id = titulos.id_aut
GROUP BY autor
ORDER BY COUNT(*) DESC;
----------------      Fin Ejercicio 6      ----------------