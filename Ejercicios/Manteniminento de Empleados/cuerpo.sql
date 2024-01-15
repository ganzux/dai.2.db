-- @ 'C:\Documents and Settings\alumno2dai\Escritorio\Manteniminento de Empleados\cuerpo.sql'
-- @ 'F:\DAI - II\Oracle\Ejercicios PL-SQL Web Toolkit\Manteniminento de Empleados\cuerpo.sql'
-- http://informatica.lazarocardenas.org:7777/dadalvaro/mant_emp.principal

--  @ 'C:\Documents and Settings\AlVaRiTo\Escritorio\Manteniminento de Empleados\cuerpo.sql'



SET DEFINE OFF
--CREATE SEQUENCE numerodeempleado START WITH 8000;
CREATE OR REPLACE PACKAGE BODY mant_emp AS

-- Procedimiento que ejecuta el UPDATE
PROCEDURE modificar (numero NUMBER,ename VARCHAR2,job VARCHAR2,mgr NUMBER,hiredate DATE,sal NUMBER,comm NUMBER,deptno NUMBER) IS

sentencia VARCHAR2(150):='UPDATE emp SET ENAME = '''||ename||
						''', JOB = '''||job||
						''', MGR = '||mgr||
						', HIREDATE = '''||hiredate||
						''', SAL = '||sal||
						', COMM = '||comm||	
						', DEPTNO = '||deptno||' WHERE empno = '||numero;
BEGIN

	EXECUTE IMMEDIATE sentencia;
	
END modificar;


-- Procedimiento para dar de alta empleados
PROCEDURE alta (nombre VARCHAR2 default 'Sin Nombre', trabajo VARCHAR2, jefe VARCHAR2, contr DATE DEFAULT SYSDATE, money NUMBER, comision NUMBER DEFAULT 0, depart NUMBER) IS
BEGIN

INSERT INTO emp (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO)
VALUES (numerodeempleado.NEXTVAL,nombre,trabajo,jefe,contr,money,comision,depart);

END alta;


-- Procedimiento para dar de baja empleados
PROCEDURE baja (numero NUMBER) IS
BEGIN
	EXECUTE IMMEDIATE 'DELETE FROM emp WHERE empno = '||numero;
END baja;


-- Procedimiento que lista empleados en una Web
PROCEDURE listado (ordena NUMBER DEFAULT 2, operacion VARCHAR2 default 'muestra', id NUMBER default null) IS
-- Cargamos en un cursor todos los datos de empleados
TYPE cur_t IS REF CURSOR;

cur cur_t;

elcodigo emp.empno%TYPE;
elnombre emp.ename%TYPE;
otronombre emp.ename%TYPE;
elpuesto emp.job%TYPE;
eljefe emp.mgr%TYPE;
elfechalta emp.hiredate%TYPE;
elsalario emp.sal%TYPE;
elcomision emp.comm%TYPE;
eldept emp.deptno%TYPE;
departamento dept.dname%TYPE;
contador cont.c%TYPE:=0;

sentencia VARCHAR2(150) := 'SELECT empno,ename,job,mgr,hiredate,sal,comm,deptno FROM emp ORDER BY ';

--  Cursor para el dept
CURSOR D IS
	SELECT DISTINCT * FROM dept;
--  Cursor para el empleo
CURSOR P IS
	SELECT DISTINCT job FROM emp;
-- Cursor para el jefe
CURSOR J IS
	SELECT DISTINCT * FROM emp ORDER BY sal DESC;

BEGIN
-- Concatenamos la sentencia
sentencia := sentencia || TO_CHAR(ordena);

-- Metemos el contador en mi contador y le sumamos uno
SELECT * INTO contador FROM cont;
UPDATE cont SET c=c+1;

-- Lo primero que haremos será crear todo lo común de la Web
htp.p('<HTML>
<HEAD><TITLE>Mantenimiento de empleados</TITLE>
 <style type="text/css">
<!--
  body  {color: black;
    font: 10pt Helvetica}
  h1    {color: red; font: 14pt Impact}
-->
</style>

</HEAD>

<BODY bgcolor="#C0C0C0" link="black" vlink="black" alink="black">
<CENTER><TABLE border="0" align="center" cellspacing="3" cellpadding="3" width="760" bgcolor="#006699">
<TR>
 <TD><img src=http://img73.imageshack.us/img73/378/enfafdadoob7.jpg></TD>

 <TH colspan="2" width="100%">
  <FONT size="6" color="orange" face="arial, helvetica"><u>Mantenimiento Empleados</u></FONT>
<br>'||contador||' visitas desde el 7 / XII / 2006
</TH>
</TR></TABLE><p>

<TABLE BORDER="0" cellspacing="1" cellpadding="1"
					align="center" width="760">
			 		<TR>
						<th background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif">
						<A href= mant_emp.principal?ordena=2 alt="Ordenar por Nombre"><FONT color="orange" face="arial, helvetica">Nombre
						</FONT></A></th>
						
						<th background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif">
						<A href= mant_emp.principal?ordena=3 alt="Ordenar por Puesto"><FONT color="orange" face="arial, helvetica">Puesto
						</FONT></A></th>
						
						<th background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif">
						<A href= mant_emp.principal?ordena=4 alt="Ordenar por Jefe"><FONT color="orange" face="arial, helvetica">Jefe
						</FONT></A></th>
						
						<th background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif">
						<A href= mant_emp.principal?ordena=5 alt="Ordenar por Fecha"><FONT color="orange" face="arial, helvetica">Fecha alta
						</FONT></A></th>
							
						<th background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif">
						<A href= mant_emp.principal?ordena=6 alt="Ordenar por Salario"><FONT color="orange" face="arial, helvetica">Salario
						</FONT></A></th>
							
						<th background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif"><FONT color="orange" face="arial, helvetica">Comisión
						</FONT></th>
						
						<th background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif"><FONT color="orange" face="arial, helvetica">Dept.
						</FONT></th>
							
						<th></th>

					</TR>');
					
-- Ahora cargaremos en un BUCLE DE CURSOR FOR cada empleado y visualizaremos sus datos
OPEN cur FOR sentencia;
	LOOP
	FETCH cur INTO elcodigo,elnombre, elpuesto,eljefe,elfechalta,elsalario,elcomision,eldept;
	EXIT WHEN cur%NOTFOUND;

	otronombre:='';
	
	-- Vale, esto es MUY cutre, pero no sé como hacer una especie de
	-- IF elcodigo NOT IN SELECT DISTICT empno from emp Where MGR IS NULL THEN...
	IF elcodigo <> 7839 THEN
	SELECT ename INTO otronombre FROM emp WHERE eljefe = empno;
	END IF;
	
	SELECT dname INTO departamento FROM dept where deptno = eldept;
	
	IF (operacion <> 'editar' OR id <> elcodigo) THEN
	htp.p('<TR>
	<td align="left">'  ||elnombre||'   </td>
	<td align="left">'  ||elpuesto||'     </td>
	<td align="center">'||otronombre||'</td>
	<td align="right">' ||elfechalta||'</td>
	<td align="right">' ||elsalario||'		</td>
	<td align="right">' ||elcomision||'	</td>
	<td align="right">' ||departamento||'	</td>
	<td align="center">
	
	<TABLE border=1 CELLSPACING=0 CELLPADDING=3><tbody>
		<TR>
			<TD background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif">
				<a href="mant_emp.principal?ordena='||ordena||'&operacion=editar&id='||elcodigo||'">
					<FONT size ="-1" face="arial, helvetica" color="red"><b>EDITAR</b></FONT>
				</a>
			</TD>

			<TD background="http://img53.imageshack.us/img53/3359/cellpic3wt3.gif">
				<a href="mant_emp.principal?ordena='||ordena||'&operacion=borrar&id='||elcodigo||'">
					<FONT size ="-1" face="arial, helvetica" color="red"><b>BORRAR</b></FONT>
				</a>
			</TD>
		</TR>
	</TABLE></td></TR>');

	ELSIF (operacion = 'editar' AND id = elcodigo) THEN
		
		
	
	htp.p('<TR>
    <form name="edicion" method="post" action="mant_emp.principal?operacion=modificar&id='||id||'">
   				<TD align=center><input type="text" name="nombre" size="20" value='||elnombre||' maxlength="50"></TD>');
				
				-- Nos metemos en el cursor del puesto
				htp.p('<TD align=center><SELECT name=trabajo>');
				FOR P_REC IN P LOOP
					htp.p('<OPTION value= '||P_REC.job||'');
						-- Lo seleccionamos si así estaba
						IF elpuesto = P_REC.job THEN
							htp.p('SELECTED='||elpuesto||'');
						END IF;		
					htp.p('>'||P_REC.job||'</OPTION>');
				END LOOP;
				htp.p('</SELECT></TD>');
				
				-- Cursor del jefe
				htp.p('<TD align=center><SELECT name=jefe>');
				FOR J_REC IN J LOOP
					htp.p('<OPTION value= '||J_REC.empno||'');
						-- Lo seleccionamos si así estaba
						IF otronombre = J_REC.ename THEN
							htp.p('SELECTED='||J_REC.ename||'');
						END IF;		
					htp.p('>'||J_REC.ename||'</OPTION>');
				END LOOP;
				htp.p('</SELECT></TD>');
				
				
				htp.p('<TD align=center><input type="text" name="contr" size="10" value='||elfechalta||' maxlength="15"></TD>
				<TD align=center><input type="text" name="money" size="6" value='||elsalario||' maxlength="10"></TD>
				<TD align=center><input type="text" name="comision" size="6" value='||elcomision||' maxlength="10"></TD>
				<TD align=center><SELECT name=depart>');
				-- Nos metemos en el cursor del departamento
				FOR D_REC IN D LOOP
					htp.p('<OPTION value= '||D_REC.deptno||'');
						-- Lo seleccionamos si así estaba
						IF eldept = D_REC.DEPTNO THEN
							htp.p('SELECTED='||eldept||'');
						END IF;		
					htp.p('>'||D_REC.dname||'</OPTION>');
				END LOOP;
				
				htp.p('</SELECT></TD>
				<TD colspan="2"><INPUT TYPE="SUBMIT"  VALUE="Modificar empleado"></TD>
	</FORM></TR>');
	END IF;
	
	END LOOP;
CLOSE cur;

END listado;

-- Procedimiento que pone, en el pie de página,  el insert del empleado
PROCEDURE pie IS

--  Cursor para el dept
CURSOR D IS
	SELECT DISTINCT * FROM dept;
--  Cursor para el empleo
CURSOR P IS
	SELECT DISTINCT job FROM emp;
-- Cursor para el jefe
CURSOR J IS
	SELECT DISTINCT * FROM emp ORDER BY sal DESC;


BEGIN
htp.p('<TR>
    <form name="formu" method="get" action="mant_emp.principal?operacion=alta">
    	<input type="hidden" name="operacion" value="alta">
   				<TD align=center><input type="text" name="nombre" size="20" maxlength="50"></TD>');

				-- Nos metemos en el cursor del Job
				htp.p('<TD align=center><SELECT name=trabajo>');
				FOR P_REC IN P LOOP
					htp.p('<OPTION value= '||P_REC.job||'>'||P_REC.job||'</OPTION>');
				END LOOP;
				htp.p('</SELECT></TD>');
				
				-- Cursor del jefe
				htp.p('<TD align=center><SELECT name=jefe>');
				FOR J_REC IN J LOOP
					htp.p('<OPTION value= '||J_REC.empno||'>'||J_REC.ename||'</OPTION>');
				END LOOP;
				htp.p('</SELECT></TD>');				
				
				htp.p('<TD align=center><input type="text" name="contr" size="10" maxlength="15"></TD>
				<TD align=center><input type="text" name="money" size="6" maxlength="10"></TD>
				<TD align=center><input type="text" name="comision" size="6" maxlength="10"></TD>
				<TD align=center><SELECT name=depart>');
				
				-- Nos metemos en el cursor del departamento
				FOR D_REC IN D LOOP
					htp.p('<OPTION value= '||D_REC.deptno||'>'||D_REC.dname||'</OPTION>');
				END LOOP;
				
				htp.p('</SELECT></TD>
				<TD colspan="2"><INPUT TYPE="SUBMIT"  VALUE="Alta empleado"></TD>
</FORM></TR></table>');

htp.p('<hr width="75%">
<p align="center"><strong>CopyLeft 2006 Álvaro Alcedo Moreno</strong></p>
<hr width="75%">
<table width="25%"  border="0" align="center" cellspacing="2">
  <tr>
    <td bordercolor="#009999"><strong><font color="#666666">Otras prácticas:</font></strong></td>
  </tr>
  <tr>
    <td>
<a href="../dadscott/mant_emp.principal"><font color="#909090"><b>1. Javier</b></font></a><br>
<a href="../dadalberto/mant_emp.principal"><font color="#999999">2. Alberto</font></a><br>
<a href="../dadantonio/mant_emp.principal"><font color="#999999">3. Antonio</font></a><br>
<a href="../daddaniel/mant_emp.principal"><font color="#999999">4. Daniel</font></a><br>
<a href="../dadeduardo/mant_emp.principal"><font color="#999999">5. Edu</font></a><br>
<a href="../dadsergio/mant_emp.principal"><font color="#999999">6. Sergio</font></a></td>
  </tr>
</table></body></html>');

END pie;


PROCEDURE principal (ordena NUMBER DEFAULT 2, operacion VARCHAR2 default 'muestra', nombre VARCHAR2 default null,
					trabajo VARCHAR2 default null, jefe VARCHAR2 default null, contr DATE default null,
					money NUMBER default null, comision NUMBER default null, depart NUMBER default null,
					id NUMBER default null) IS
BEGIN 




IF operacion = 'alta' THEN
	alta (nombre,trabajo,jefe,contr,money,comision,depart);
END IF;

IF operacion = 'borrar' THEN
	baja (id);
END IF;

IF operacion = 'modificar' THEN
	modificar(id,nombre,trabajo,jefe,contr,money,comision,depart);
END IF;


listado(ordena,operacion,id);
pie;

-- Bloque de excepciones
EXCEPTION

WHEN OTHERS THEN
	HTP.P('ERROR');
	

END principal;

END;
/
show errors

-- @ 'F:\mis cosas\ESTUDIOS\DAI - II\Oracle\Ejercicios PL-SQL Web Toolkit\Manteniminento de Empleados\cuerpo.sql'