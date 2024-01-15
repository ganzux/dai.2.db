DROP DATABASE cine;
CREATE DATABASE cine;
USE cine;

-- Géneros de las películas
CREATE TABLE generos(id INT AUTO_INCREMENT PRIMARY KEY,
descripcion VARCHAR(25));


-- Tabla de las películas --
CREATE TABLE pelis (id INT AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR(100),
director VARCHAR(25),
calificacion VARCHAR(15),
descripcion VARCHAR(1024),
genero INT,
CONSTRAINT FOREIGN KEY genero REFERENCES generos(id));


-- Tabla que contiene los cines, con todos sus datos
CREATE TABLE cines (id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) UNIQUE NOT NULL,
direccion VARCHAR(100),
telefono VARCHAR(10),
fax VARCHAR(10),
metro VARCHAR(25),
autobuses VARCHAR(25),
web VARCHAR(50));


-- Tabla que contiene las diversas formas de pago
CREATE formas_de_pago (id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50) UNIQUE NOT NULL);


-- Tabla con las formas de pago que acepta cada cine
CREATE TABLE cines_formas_de_pago(id INT AUTO_INCREMENT PRIMARY KEY,
id_cine INT REFERENCES cines(id),
id_forma INT REFERENCES formas_de_pago(id),
CONSTRAINT UNIQUE (id_cine,id_forma));


-- Tabla con las salas de cada cine
CREATE TABLE salas (id INT AUTO_INCREMENT PRIMARY KEY,
id_cine INT FOREIGN KEY REFERENCES cines (id),
sesion VARCHAR(10)


CREATE TABLE proyeccion



CREATE TABLE reservas



CREATE TABLE historico



CREATE TABLE administradores



------------------- DATOS DE PRUEBA -------------------
-- Géneros
INSERT INTO generos (descripcion) VALUES('Ciencia Ficción');	-- 1
INSERT INTO generos (descripcion) VALUES('Terror');				-- 2
INSERT INTO generos (descripcion) VALUES('Drama');				-- 3
INSERT INTO generos (descripcion) VALUES('Musical');			-- 4
INSERT INTO generos (descripcion) VALUES('Dibujos Animados');	-- 5
INSERT INTO generos (descripcion) VALUES('Adultos');			-- 6
-- Películas
INSERT INTO pelis (titulo,director,calificacion,descripcion,genero) VALUES ('Peli 1','Autor 1','18 años','',1);
INSERT INTO pelis (titulo,director,calificacion,descripcion,genero) VALUES ('Peli 2','Autor 2','16 años','',2);
INSERT INTO pelis (titulo,director,calificacion,descripcion,genero) VALUES ('Peli 3','Autor 3','14 años','',3);
INSERT INTO pelis (titulo,director,calificacion,descripcion,genero) VALUES ('Peli 4','Autor 4','12 años','',4);
INSERT INTO pelis (titulo,director,calificacion,descripcion,genero) VALUES ('Peli 5','Autor 5','10 años','',5);
INSERT INTO pelis (titulo,director,calificacion,descripcion,genero) VALUES ('Peli 6','Autor 6','8 años','',6);
-- Cines
INSERT INTO cines (nombre,direccion,telefono,fax,metro,autobuses,web) VALUES('Cine de Barrio','Calle kk','918559033','629737616','Metro Villalba','Lineas 724 y 725','www.alvarito.net');
INSERT INTO cines (nombre,direccion,telefono,fax,metro,autobuses,web) VALUES('Cine de Pueblo','Calle pis','913554720','629737616','Metro Collado Villalba','Linea 672','http://www.alvarito.net');
-- Formas de pago
INSERT INTO formas_de_pago (nombre) VALUES ('Efectivo');
INSERT INTO formas_de_pago (nombre) VALUES ('Visa');
INSERT INTO formas_de_pago (nombre) VALUES ('Mastercard');
INSERT INTO formas_de_pago (nombre) VALUES ('Paypal');
INSERT INTO formas_de_pago (nombre) VALUES ('MobiPay');
INSERT INTO formas_de_pago (nombre) VALUES ('Otros');
-- Cines - Formas de pago
INSERT INTO cines_formas_de_pago (id_cine,id_forma) VALUES (1,1);
INSERT INTO cines_formas_de_pago (id_cine,id_forma) VALUES (1,2);
INSERT INTO cines_formas_de_pago (id_cine,id_forma) VALUES (1,3);
INSERT INTO cines_formas_de_pago (id_cine,id_forma) VALUES (2,1);
INSERT INTO cines_formas_de_pago (id_cine,id_forma) VALUES (2,4);
INSERT INTO cines_formas_de_pago (id_cine,id_forma) VALUES (2,5);
INSERT INTO cines_formas_de_pago (id_cine,id_forma) VALUES (2,6);
-- Cines - Salas

