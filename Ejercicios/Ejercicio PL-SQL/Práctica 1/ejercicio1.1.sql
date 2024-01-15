-- Se crean las tablas
DROP TABLE inventario;
CREATE TABLE inventario(
prod_id NUMBER(5) PRIMARY KEY,
producto VARCHAR2(15),
cantidad NUMBER(5)
);
DROP TABLE movimientos;
CREATE TABLE movimientos(
venta VARCHAR2(45),
dia_venta DATE);

-- Le pasamos los valores
INSERT INTO inventario VALUES(1234,'raqueta tenis',2);
INSERT INTO inventario VALUES(8159,'juego golf',4);
INSERT INTO inventario VALUES(2741,'balon futbol',2);


-- Bloque PL/SQL que quita una raqueta de tenis, quedando reflejado en la tabla movimientos
DECLARE
	numero_stock NUMBER(5);
BEGIN
	SELECT cantidad INTO numero_stock FROM inventario
	WHERE producto ='raqueta tenis';
IF numero_stock >0 THEN
	UPDATE inventario SET cantidad=cantidad-1
	WHERE producto = 'raqueta tenis';
	INSERT INTO movimientos VALUES ('vendida raqueta tenis',SYSDATE);
ELSE
	INSERT INTO movimientos VALUES('no hay raqueta',SYSDATE);
END IF;
COMMIT;
END;
/

-- El siguiente bloque le quita lo que tú pases
DECLARE
	numero_stock NUMBER(5);
	miproducto VARCHAR2(15):='&miproducto';
BEGIN
	SELECT cantidad INTO numero_stock FROM inventario
	WHERE producto = miproducto;
IF numero_stock >0 THEN
	UPDATE inventario SET cantidad=cantidad-1
	WHERE producto = miproducto;
	INSERT INTO movimientos VALUES ('vendida '|| miproducto,SYSDATE);
ELSE
	INSERT INTO movimientos VALUES ('no hay '|| miproducto,SYSDATE);
END IF;
COMMIT;
END;
/
