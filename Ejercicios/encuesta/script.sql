SET DEFINE OFF
SET LINESIZE 100

DROP TABLE datos_encuesta;

CREATE TABLE datos_encuesta(
id NUMBER(2),
nombre VARCHAR2(25),
votos NUMBER(5));

INSERT INTO datos_encuesta VALUES (1,'Pelicula 1',0);
INSERT INTO datos_encuesta VALUES (2,'Pelicula 2',1);
INSERT INTO datos_encuesta VALUES (3,'Pelicula 3',2);
INSERT INTO datos_encuesta VALUES (4,'Pelicula 4',3);
INSERT INTO datos_encuesta VALUES (5,'Pelicula 5',4);
INSERT INTO datos_encuesta VALUES (6,'Pelicula 6',5);
INSERT INTO datos_encuesta VALUES (7,'Pelicula 7',6);
INSERT INTO datos_encuesta VALUES (8,'Pelicula 8',7);
INSERT INTO datos_encuesta VALUES (9,'Pelicula 9',8);

SELECT * FROM datos_encuesta;

COMMIT;