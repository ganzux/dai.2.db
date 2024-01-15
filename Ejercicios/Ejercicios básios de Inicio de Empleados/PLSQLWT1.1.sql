CREATE OR REPLACE  PROCEDURE listar_departamentos  IS
CURSOR C1 IS SELECT * FROM dept;
BEGIN
HTP.P('<HTML><HEAD><TITLE>Listado de Departamentos</TITLE></HEAD><BODY>');
HTP.P('<H2>Listado de departamentos</h><br>');
HTP.P('<TABLE BORDER=2>');
HTP.P('<TR>');
HTP.P('<TD><b>Código</b></TD><TD><b>Nombre</b></TD><TD><b>Ciudad</b></TD>');
HTP.P('</TR>');
FOR REG IN C1  LOOP 
HTP.P('<TR>');
HTP.P('<TD>'||REG.deptno||'</TD><TD>'||REG.dname||'</TD><TD>'||REG.loc||'</TD>');
HTP.P('</TR>');
END LOOP;
HTP.P('</TABLE></BODY></HTML>');
END listar_departamentos;
/


-- LLAMADA: http://2dai12/dadalvaro/listar_departamentos
-- http://informatica.lazarocardenas.org:7777/dadalvaro/listar_departamentos