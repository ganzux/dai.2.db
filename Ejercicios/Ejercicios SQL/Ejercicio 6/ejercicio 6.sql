-- Borramos las tablas ya existentes (si existiesen)
DROP TABLE lineas_factura;
DROP TABLE facturas;
DROP TABLE compradores;
DROP TABLE articulos;

---------------- EJERCICIO 1 ----------------
---------------- Ejercicio A
CREATE TABLE compradores
(	cif_comprador VARCHAR2(11) CONSTRAINT pk_compradores_cif PRIMARY KEY,
	mombre_social VARCHAR2(30) CONSTRAINT uq_compradores_nombre_social UNIQUE,
	domicilio_social VARCHAR2(30),
	localidad VARCHAR2(30),
	c_postal VARCHAR2(5),
	telefono VARCHAR2(9) NOT NULL);
---------------- Ejercicio B
CREATE TABLE articulos
(	referencia_articulo VARCHAR2(12) CONSTRAINT pk_articulos PRIMARY KEY,
	descr_articulo VARCHAR2(30),
	precio_unidad NUMBER(6,2),
	iva NUMBER(2),
	existencias_act NUMBER(5) DEFAULT 0,
	CONSTRAINT check_iva CHECK (iva BETWEEN 5 AND 25)
);
---------------- Ejercicio C
CREATE TABLE facturas
(	factura_no NUMBER(6) CONSTRAINT pk_factura PRIMARY KEY,
	fecha_factura DATE DEFAULT '1/1/05',
	cif_clientes VARCHAR2(11)
);
---------------- Ejercicio D
CREATE TABLE lineas_factura
(	factura_no NUMBER(6),
	referencia_articulo VARCHAR2(6),
	unidades NUMBER(6),
	CONSTRAINT pk_lineas_factura PRIMARY KEY (factura_no,referencia_articulo),
	CONSTRAINT fk_lineas_factura FOREIGN KEY (factura_no) REFERENCES facturas ON DELETE CASCADE,
	CONSTRAINT fk_lineas_articulos FOREIGN KEY (referencia_articulo) REFERENCES articulos
);

---------------- EJERCICIO 2 ----------------
ALTER TABLE facturas
	ADD (cod_oficina NUMBER(4));
	
---------------- EJERCICIO 3 ----------------
ALTER TABLE facturas
	ADD (cif_cliente VARCHAR2(11) CONSTRAINT fk_factura_compradores REFERENCES compradores);

---------------- EJERCICIO 4 ----------------
ALTER TABLE compradores
	RENAME COLUMN c_postal TO codigo_postal;

---------------- EJERCICIO 5 ----------------
ALTER TABLE facturas
	MODIFY (cod_oficina CONSTRAINT chek_cod_oficina CHECK (cod_oficina BETWEEN 1 AND 1000));

---------------------  FIN  ----------------------
COMMIT;