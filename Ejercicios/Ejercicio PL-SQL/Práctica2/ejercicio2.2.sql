--Creación de la tabla art_inc
DROP TABLE art_inc;
CREATE TABLE art_inc(
id_art CHAR(2),
inc NUMBER(3));
INSERT INTO art_inc VALUES ('P1',20);
INSERT INTO art_inc VALUES ('P3',15);
INSERT INTO art_inc VALUES ('P5',5);

-- Creo un cursor de la tabla de incrementos
DECLARE
CURSOR c1 IS
	SELECT * FROM art_inc;
	
-- Inicio
BEGIN
	FOR c1_rec IN c1 LOOP
		UPDATE stock
		SET cant = cant+(c1_rec.inc*cant/100)
		WHERE c1_rec.id_art = stock.id_art;
	EXIT WHEN c1%NOTFOUND;
	END LOOP;
END;
/



select * from stock;