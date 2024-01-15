--      @'C:\Documents and Settings\AlVaRiTo\Escritorio\foro domingo casa\Código Fuente - Code\foro_script.sql'
SET DEFINE OFF
SET LINESIZE 6000

------------------------------------------------------------------ SEQUENCES
-- Borramos las SEQUENCES
DROP SEQUENCE seq_foro_usu;
DROP SEQUENCE seq_foro_men;
DROP SEQUENCE seq_foro_tem;
DROP SEQUENCE seq_foro_arc;
-- Creamos las SEQUENCES
CREATE SEQUENCE seq_foro_usu INCREMENT BY 1;
CREATE SEQUENCE seq_foro_men INCREMENT BY 1;
CREATE SEQUENCE seq_foro_tem INCREMENT BY 1;
CREATE SEQUENCE seq_foro_arc INCREMENT BY 1;
------------------------------------------------------------------ /SEQUENCES


------------------------------------------------------------------ TABLAS
-- Borramos las dos tablas
DROP TABLE documents;
DROP TABLE foro_mensajes;
DROP TABLE foro_temas;
DROP TABLE foro_usuarios;

-- Tabla de Archivos
CREATE TABLE documents (
name			VARCHAR2(256) PRIMARY KEY,
mime_type		VARCHAR2(128),
doc_size		NUMBER,
dad_charset		VARCHAR2(128),
last_updated	DATE,
content_type	VARCHAR2(128),
blob_content	BLOB);

-- Tabla de Usuarios
CREATE TABLE foro_usuarios(id NUMBER(6) PRIMARY KEY,
nombre			VARCHAR2(60),
nick			VARCHAR2(25) UNIQUE NOT NULL,
password		VARCHAR2(35) UNIQUE NOT NULL,
email			VARCHAR2(30) UNIQUE NOT NULL,
tipo_usuario	NUMBER(2) DEFAULT NULL,
fecha_registro  DATE DEFAULT SYSDATE);

-- Tabla de Temas
CREATE TABLE foro_temas(id NUMBER(6) PRIMARY KEY,
id_usuario	NUMBER(6) REFERENCES foro_usuarios,
nombre_tema	VARCHAR2(50));

-- Tabla de mensajes
CREATE TABLE foro_mensajes(id NUMBER(6) PRIMARY KEY,
fecha		DATE,
asunto		VARCHAR2(60),
contenido	VARCHAR2(4000),
id_usuario	NUMBER(6) REFERENCES foro_usuarios,
id_tema		NUMBER(6) REFERENCES foro_temas,
archivo		VARCHAR2(256) DEFAULT NULL REFERENCES documents);
------------------------------------------------------------------ / TABLAS


------------------------------------------------------------------ VISTAS
CREATE OR REPLACE VIEW vista_temas AS
SELECT foro_temas.id, foro_temas.nombre_tema,foro_usuarios.nick, MAX(foro_mensajes.fecha) AS fecha
FROM foro_usuarios, foro_temas LEFT JOIN foro_mensajes
ON foro_temas.id = foro_mensajes.id_tema
WHERE foro_usuarios.id = foro_temas.id_usuario
GROUP BY (foro_temas.id, foro_temas.nombre_tema,foro_usuarios.nick)
ORDER BY foro_temas.id DESC;
select * FROM VISTA_TEMAS;

CREATE OR REPLACE VIEW vista_usuarios AS
SELECT id, nombre, nick, email
FROM foro_usuarios;

CREATE OR REPLACE VIEW vista_usuarios_mensajes AS
SELECT foro_usuarios.id AS ide, COUNT(*) AS num_mensajes
FROM foro_usuarios, foro_mensajes
WHERE foro_usuarios.id = foro_mensajes.id_usuario
GROUP BY foro_usuarios.id
ORDER BY foro_usuarios.id;

CREATE OR REPLACE VIEW vista_usuarios_entera AS
SELECT foro_usuarios.id, vista_usuarios_mensajes.num_mensajes, foro_usuarios.email, foro_usuarios.nombre, foro_usuarios.nick, foro_usuarios.fecha_registro
FROM vista_usuarios_mensajes RIGHT JOIN foro_usuarios
ON vista_usuarios_mensajes.ide = foro_usuarios.id
ORDER BY foro_usuarios.id;

CREATE OR REPLACE VIEW vista_de_busqueda AS
SELECT foro_mensajes.id, foro_temas.nombre_tema, foro_usuarios.nick, foro_temas.id AS id_tema, foro_usuarios.id AS id_usuario, foro_mensajes.fecha, foro_mensajes.contenido
FROM foro_mensajes, foro_usuarios, foro_temas
WHERE foro_mensajes.id_usuario = foro_usuarios.id 
AND foro_mensajes.id_tema = foro_temas.id
ORDER BY foro_mensajes.id DESC;
------------------------------------------------------------------ /VISTAS


------------------------------------------------------------------ Datos Iniciales
-- Usuario principal
-- Nombre: admin      Password: admin
INSERT INTO foro_usuarios VALUES (seq_foro_usu.NEXTVAL,'Administrador','admin','f6fdffe48c908deb0f4c3bd36c032e72','admin',3,SYSDATE);
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