CREATE OR REPLACE PACKAGE foro AS

PROCEDURE nuevo_tema;
PROCEDURE alta (nombre VARCHAR2, login VARCHAR2, pass VARCHAR2, mail VARCHAR2);
PROCEDURE login (chorro VARCHAR2 DEFAULT NULL);
PROCEDURE salir;
PROCEDURE registro;
PROCEDURE principal;
PROCEDURE muestra_temas;
PROCEDURE perfil;
PROCEDURE muestra_tema (id_tema_pasada NUMBER DEFAULT NULL);
PROCEDURE crear_nuevo_tema (asunto VARCHAR2 DEFAULT NULL, usuario VARCHAR2 DEFAULT NULL);
PROCEDURE nuevo_mensaje(id_tema_pasada NUMBER DEFAULT NULL);
PROCEDURE publicar (asunto VARCHAR2 DEFAULT NULL,texto VARCHAR2 DEFAULT NULL, tema NUMBER DEFAULT NULL);
PROCEDURE muestra_perfil (id_usua VARCHAR2 DEFAULT NULL);

END foro;
/
show errors;

--@ 'C:\Documents and Settings\AlVaRiTo\Escritorio\foro\foro_cuerpo.sql'