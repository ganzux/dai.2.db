-- @ 'J:\Javier\Curso2006-07\PlSQLWeb\paquetebasicoemp.sql'
create or replace package basicoemp
as
PROCEDURE listar_departamentos;
PROCEDURE listar_empleados;
PROCEDURE listar_emp_dep (codigodep varchar2 default null) ;
PROCEDURE listar_datos_emp (codigoemp varchar2 default null);
END basicoemp;
/

create or replace package body basicoemp
as
-- subprogramas privados

--subprogramas publicos
PROCEDURE listar_departamentos AS

CURSOR dep_cursor IS
SELECT *
FROM scott.dept
ORDER BY dname;

BEGIN

owa_util.mime_header('text/html');

htp.prn('
<html>
<head>

<title>Listado de departamentos</title>
</head>
<body >

<h1>Listado de departamentos</h1>
<table width="40%" border="1">
<tr>
<th align="left">Código</th>
<th align="left">Nombre</th>
<th align="left">Ciudad</th>
</tr>
');

FOR dep_record IN dep_cursor LOOP
 htp.prn('
 <tr>
 <td> ');
 htp.prn( dep_record.deptno );
 htp.prn(' </td>
 <td> ');
 htp.prn( dep_record.dname );
 htp.prn(' </td>
 <td > ');
 htp.prn( dep_record.loc);
 htp.prn(' </td>
 </tr>
 ');
 END LOOP;
htp.prn('
</table>
</body>
</html>
');
END listar_departamentos;

 
PROCEDURE listar_empleados AS 

CURSOR emp_cursor IS
SELECT ename, job,sal
FROM scott.emp
ORDER BY ename;
total_salario number:=0;

 BEGIN NULL;
owa_util.mime_header('text/html'); htp.prn('
');
htp.prn('
');
htp.prn('
');
htp.prn('
');
htp.prn('
');
htp.prn('

<html>
<head>

<title>Listado de empleados</title>
<style type="text/css">
<!--
  body  {background: black; color: white; 
    font: 12pt Helvetica}
  h1    {color: red; font: 14pt Impact}
-->
</style>
</head>
<body >

<h1>Listado de empleados</h1>
<table width="40%" border="1">
<tr>
<th align="left">Nombre</th>
<th align="left">Puesto</th>
<th align="left">Salario</th>
</tr>
');
 FOR emp_record IN emp_cursor LOOP 
 total_salario:= total_salario+emp_record.sal;
htp.prn('
<tr>
<td> ');
htp.prn( emp_record.ename );
htp.prn(' </td>
<td> ');
htp.prn( emp_record.job );
htp.prn(' </td>
<td align=right> ');
htp.prn( emp_record.sal );
htp.prn(' </td>
</tr>
');
 END LOOP; 
htp.prn('
<tr><td></td>
<td><b>Salario total:</b></td>
<td align=right><b>');
htp.prn( total_salario );
htp.prn('</b><td>

</table>
</body>
</html>
');
END listar_empleados;
 
 
PROCEDURE listar_emp_dep (codigodep varchar2 default null) AS

CURSOR emp_dep_cursor(coddep dept.deptno%type) IS
SELECT ename,job,sal
FROM scott.emp
where deptno=coddep
ORDER BY ename;
numemp integer;
codigodepok integer;
BEGIN

owa_util.mime_header('text/html');

htp.prn('
<html>
<head>

<title>Listado de empleados por departamento</title>
</head>
<body >
<h1>Listado de empleados por departamento</h1>
<hr>
<form action=basicoemp.listar_emp_dep method="post" >
<b>Introduce el código del departamento</b>
<input type="text" name="codigodep" size="5" maxlength="10" value="">
 <input type="submit" value="Buscar">
</form>
<hr>');
codigodepok:=to_number(codigodep);
if (codigodep is not null) then
select count(*) into numemp from emp where deptno=codigodepok;
if (numemp>0) then
htp.prn('<h2>Empleados del departamento ');
htp.prn(codigodepok);
htp.prn('</h2>
<table width="40%" border="1">
<tr>
<th align="left">Nombre</th>
<th align="left">Puesto</th>
<th align="left">Salario</th>
</tr>
');

FOR emp_record IN emp_dep_cursor(codigodepok) LOOP
 htp.prn('
 <tr>
 <td> ');
 htp.prn( emp_record.ename );
 htp.prn(' </td>
 <td> ');
 htp.prn( emp_record.job );
 htp.prn(' </td>
 <td > ');
 htp.prn( emp_record.sal);
 htp.prn(' </td>
 </tr>
 ');
 END LOOP;
htp.prn('
</table>');
else
htp.prn('<b>El departamento ');
htp.prn(codigodepok);
htp.prn(' no tiene empleados </b>');
end if;
end if;
htp.prn('
</body>
</html>
');
EXCEPTION
   WHEN INVALID_NUMBER OR VALUE_ERROR THEN
 htp.prn('<b>Código de departamento debe ser un número entero </b>');

END listar_emp_dep;
 
PROCEDURE listar_datos_emp (codigoemp varchar2 default null) AS

cursor emp_cursor  IS
select empno,ename from emp
order by ename;

numemp integer;
codigoempok integer;
datos_emp emp%rowtype;
BEGIN

owa_util.mime_header('text/html');

htp.prn('
<html>
<head>

<title>Listado de datos del empleado</title>
<style type="text/css">
<!--
  body  {background: black; color: white;
    font: 12pt Helvetica}
  h1    {color: red; font: 14pt Impact}
-->
</style>
</head>
<body >
<h1>Listado de datos del empleado</h1>
<hr>
<form action=basicoemp.listar_datos_emp method="post" >
<b>Selecciona el nombre del empleado</b>
 <select name="codigoemp">
 <option value=0></option>');
for emp_rec in emp_cursor loop
  if (codigoemp=emp_rec.empno) then
   htp.prn('<option selected="selected" value=');
 else
   htp.prn('<option value=');
  end if;
 htp.prn(emp_rec.empno);
 htp.prn('>');
 htp.prn(emp_rec.ename);
 htp.prn('</option>');
end loop;
htp.prn('<INPUT TYPE="submit" VALUE="Buscar">
</form>
<hr>');
codigoempok:=to_number(codigoemp);
if (codigoemp is not null and codigoempok!=0) then
 htp.prn('<h2>Datos del empleado ');
 htp.prn(codigoempok);
 htp.prn('</h2>
 <table width="40%" border="0">
 ');
 select *  into datos_emp from emp
  where empno=codigoempok;
 htp.prn('
 <tr>
 <td><b>Num:
 </b>');
 htp.prn( datos_emp.empno);
 htp.prn(' </td>
 </tr> ');
 htp.prn('
 <tr>
 <td><b>Nombre:
 </b>');
 htp.prn( datos_emp.ename);
 htp.prn(' </td>
 </tr> ');
 htp.prn('
 <tr>
 <td><b>Puesto:
 </b>');
 htp.prn( datos_emp.job);
 htp.prn(' </td>
 </tr> ');
 htp.prn('
 <tr>
 <td><b>Num. Jefe:
 </b>');
 htp.prn( datos_emp.mgr);
 htp.prn(' </td>
 </tr> ');
 htp.prn('
 <tr>
 <td><b>Antiguedad:
 </b>');
 htp.prn( datos_emp.hiredate);
 htp.prn(' </td>
 </tr> ');
 htp.prn('
 <tr>
 <td><b>Salario:
 </b>');
 htp.prn( datos_emp.sal);
 htp.prn(' </td>
 </tr> ');
 htp.prn('
 <tr>
 <td><b>Comisión:
 </b>');
 htp.prn( datos_emp.comm);
 htp.prn(' </td>
 </tr> ');
 htp.prn('
 <tr>
 <td><b>Num. Dep.:
 </b>');
 htp.prn( datos_emp.deptno);
 htp.prn(' </td>
 </tr> ');
 htp.prn('
 </table>');

end if;
htp.prn('
</body>
</html>
');
EXCEPTION
   WHEN INVALID_NUMBER OR VALUE_ERROR THEN
 htp.prn('<b>El código de empleado debe ser un número entero </b>');

END listar_datos_emp;
END basicoemp;
/