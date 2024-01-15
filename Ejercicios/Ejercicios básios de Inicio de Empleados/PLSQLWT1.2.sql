CREATE OR REPLACE  PROCEDURE listar_empleados  IS

CURSOR C1 IS SELECT * FROM emp;
acumulador NUMBER(8):=0;

BEGIN
HTP.P('<HTML><HEAD><TITLE>Listado de Departamentos</TITLE></HEAD><BODY bgcolor = #000000 text="white">');
HTP.P('<H2>Listado de departamentos</h><br>');
HTP.P('<TABLE width="75%"  border="3" cellspacing="2">');
HTP.P('<TR>');
HTP.P('<TD><b>Nombre</b></TD><TD><b>Puesto</b></TD><TD><b>Salario</b></TD>');
HTP.P('</TR>');
FOR REG IN C1  LOOP 
HTP.P('<TR>');
HTP.P('<TD>'||REG.ename||'</TD><TD>'||REG.job||'</TD><TD>'||REG.sal||'</TD>');
acumulador:=acumulador+REG.sal;
HTP.P('</TR>');
END LOOP;
HTP.P('<TD>'||' '||'</TD><TD>'||'<b>Salario Total:</b> '||'</TD><TD>'||acumulador||'</TD>');
HTP.P('</TABLE></BODY></HTML>');
END listar_empleados;
/


-- LLAMADA: http://2dai12/dadalvaro/listar_empleados
-- http://informatica.lazarocardenas.org:7777/dadalvaro/listar_empleados