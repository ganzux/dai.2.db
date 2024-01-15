-- @ 'C:\Documents and Settings\AlVaRiTo\Escritorio\foro\foro_script.sql'
SET DEFINE OFF
SET LINESIZE 100

------------------------------------------------------------------ SEQUENCES
-- Borramos las SEQUENCES
DROP SEQUENCE seq_foro_usu;
DROP SEQUENCE seq_foro_men;
DROP SEQUENCE seq_foro_tem;
DROP SEQUENCE seq_foro_ico;
-- Creamos las SEQUENCES
CREATE SEQUENCE seq_foro_usu INCREMENT BY 1;
CREATE SEQUENCE seq_foro_men INCREMENT BY 1;
CREATE SEQUENCE seq_foro_tem INCREMENT BY 1;
CREATE SEQUENCE seq_foro_ico INCREMENT BY 1;
------------------------------------------------------------------ /SEQUENCES

------------------------------------------------------------------ TABLAS
-- Borramos las dos tablas
DROP TABLE foro_mensajes;
DROP TABLE foro_temas;
DROP TABLE foro_usuarios;
DROP TABLE foro_iconos;

-- Tabla de Usuarios
CREATE TABLE foro_usuarios(id NUMBER(6) PRIMARY KEY,
nombre VARCHAR2(60),
nick VARCHAR2(25) UNIQUE NOT NULL,
password VARCHAR2(35) UNIQUE NOT NULL,
email VARCHAR2(30) UNIQUE NOT NULL);

-- Tabla de Temas
CREATE TABLE foro_temas(id NUMBER(6) PRIMARY KEY,
id_usuario NUMBER(6) REFERENCES foro_usuarios,
nombre_tema VARCHAR2(50));

-- Tabla de mensajes
CREATE TABLE foro_mensajes(id NUMBER(6) PRIMARY KEY,
fecha DATE,
asunto VARCHAR2(60),
contenido VARCHAR2(4000),
id_usuario NUMBER(6) REFERENCES foro_usuarios,
id_tema NUMBER(6) REFERENCES foro_temas);

-- Tabla de iconos
CREATE TABLE foro_iconos(id NUMBER(6) PRIMARY KEY,
archivo CLOB UNIQUE NOT NULL,
acceso VARCHAR2(25) UNIQUE NOT NULL,
comentario VARCHAR2(500));
------------------------------------------------------------------ / TABLAS

------------------------------------------------------------------ VISTAS
CREATE OR REPLACE VIEW vista_temas AS
SELECT foro_temas.id, foro_temas.nombre_tema,foro_usuarios.nick
FROM foro_temas, foro_usuarios
WHERE foro_usuarios.id = foro_temas.id_usuario;

CREATE OR REPLACE VIEW vista_usuarios AS
SELECT id, nombre, nick, email
FROM foro_usuarios;

CREATE OR REPLACE VIEW vista_usuarios_mensajes AS
SELECT id, nombre, nick, email
FROM foro_usuarios;

CREATE OR REPLACE VIEW vista_iconos AS
SELECT acceso, archivo, comentario
FROM foro_iconos;
------------------------------------------------------------------ /VISTAS


------------------------------------------------------------------ Datos Iniciales
-- Usuario principal
INSERT INTO foro_usuarios VALUES (seq_foro_usu.NEXTVAL,'Álvaro','iTo','No pass','mi mail');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Ocio - Tiempo Libre');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Ocio - ¿Quedamos?');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Compra Venta - Ropa');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Compra Venta - Calzado');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Deportes - Balonmano');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Deportes - Fútbol');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Deportes - Runnig');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Informática - Hardware');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Informática - Hardware - Procesadores');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Informática - Software - Juegos');
INSERT INTO foro_temas    VALUES (seq_foro_tem.NEXTVAL,1,'Informática - Software - Programación');
------------------------------------------------------------------ /Datos Iniciales


-- Grabamos
COMMIT;