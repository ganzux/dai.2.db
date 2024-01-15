CREATE OR REPLACE PACKAGE BODY delete_emp AS

-- Un tipo INDEX BY
--TYPE coll_empno_t IS TABLE OF VARCHAR2(5)
 --INDEX BY BINARY_INTEGER;
-- sin_respuesta lo inicializamos para que yano tenga NULL y pueda ir sin valor
--sin_respuesta coll_empno_t;

PROCEDURE principal IS

CURSOR C1 IS SELECT * FROM copia_empleados;
acumulador NUMBER(8):=0;

BEGIN
HTP.P('<HTML><HEAD><TITLE>Borrado de Empleados</TITLE></HEAD><BODY>
<H2>Listado de empleados</h><br>
<TABLE width="75%"  border="3" cellspacing="2">
<TR>
<form name="formulario" method="GET" action="delete_emp.borrar_empleados">
<TD><b>Nombre</b></TD><TD><b>Puesto</b></TD><TD><b>Salario</b></TD><TD><b>¿Borrar?</b></TD>
</TR>');
FOR REG IN C1  LOOP
HTP.P('<TR>');
HTP.P('<TD>'||REG.ename||'</TD><TD>'||REG.job||'</TD><TD>'||REG.sal||'</TD><TD><INPUT TYPE=checkbox name=coll_resp value='||REG.empno||'></TD>');
HTP.P('</TR>');
END LOOP;
HTP.P('</TABLE><INPUT TYPE=submit value="Borrar seleccionados"></FORM></BODY></HTML>');
END principal;


PROCEDURE borrar_empleados (coll_resp delete_emp.coll_empno_t DEFAULT delete_emp.sin_respuesta) IS
BEGIN
HTP.P('<HTML><HEAD><TITLE>Borrado de empleados</TITLE></HEAD><BODY>');

FOR contador IN 1..coll_resp.count LOOP
  DELETE FROM copia_empleados WHERE empno = coll_resp(contador);
  htp.p('Eliminado el empleado con código '||coll_resp(contador)||'<br>');
END LOOP;
commit;
HTP.P('El borrado de '||coll_resp.count||' empleados ha sido satisfactorio.<br>
Pulse el enlace para volver al formulario --> <a href="delete_emp.principal">Volver</a>
</BODY></HTML>');


-- Bloque de excepciones
EXCEPTION

WHEN OTHERS THEN
 HTP.P('¡¡¡ ERROR AL BORRAR EMPLEADOS !!!');
  ROLLBACK;
END borrar_empleados;

END delete_emp;
/
show errors;