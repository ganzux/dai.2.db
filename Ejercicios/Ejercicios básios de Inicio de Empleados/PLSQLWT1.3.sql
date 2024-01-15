CREATE OR REPLACE  PROCEDURE listar_emp_dep(codigodep VARCHAR2 DEFAULT null) IS

CURSOR C1 (depar NUMBER) IS
SELECT ename, job, sal, deptno FROM emp
WHERE deptno = depar;

no_existe_departamento EXCEPTION;
var NUMBER;
codigook NUMBER;

BEGIN
-- Inicio del Código HTML
HTP.P('<html>
<head>
<title>Listado de empleados por departamento</title>
</head>
<body>
<h1>Listado de empleados por departamento</h1>

<hr>
<form action=listar_emp_dep method="post" >
<b>Introduce el código del departamento</b>
<input type="text" name="codigodep" size="5" maxlength="10" value="">
 <input type="submit" value="Buscar">
</form>
<hr>');

-- Si la variable no es nula, que me busque el departameno
IF codigodep IS NOT null THEN

codigook := TO_NUMBER(codigodep);

SELECT COUNT(*) INTO var FROM emp WHERE deptno = codigook;

IF var=0 THEN
	RAISE no_existe_departamento;
END IF;

HTP.P('<h2>Empleados del departamento '||codigodep||'</h2>
<table width="40%" border="2">
<tr>
<th align="left">Nombre</th>
<th align="left">Puesto</th>
<th align="left">Salario</th>
</tr>');

	FOR C1_REC IN C1(codigook) LOOP 
	HTP.P('<TR>');
	HTP.P('<TD>'||C1_REC.ename||'</TD><TD>'||C1_REC.job||'</TD><TD>'||C1_REC.sal||'</TD>');
	HTP.P('</TR>');
	END LOOP;

HTP.P('</table>');

END IF;
-- Al final siempre cerramos el Código HTML
HTP.P('</body></html>');

-- Bloque de excepciones
EXCEPTION

WHEN INVALID_NUMBER OR VALUE_ERROR THEN
	HTP.P('<b>ERROR: El departamento es numérico');
	
WHEN no_existe_departamento THEN
	HTP.P('<b>ERROR: Ese departamento NO existe');


END listar_emp_dep;
/


-- LLAMADA: http://2dai21/dadalvaro/listar_emp_dep
-- http://informatica.lazarocardenas.org:7777/dadalvaro/listar_emp_dep