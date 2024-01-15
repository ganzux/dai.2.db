CREATE OR REPLACE  PROCEDURE listar_datos_emp(codemp NUMBER DEFAULT 0) IS

CURSOR C1 IS SELECT * FROM emp;
temporal C1%ROWTYPE;

BEGIN
htp.p('<html><head><title>Listado de datos del empleado</title>
<style type="text/css">
<!--
  body  {background: black; color: white;
    font: 12pt Helvetica}
  h1    {color: red; font: 14pt Impact}
-->
</style>
</head>
<body><h1>Listado de datos del empleado</h1>
<hr>
<form action=listar_datos_emp method="post" >
<b>Selecciona el nombre del empleado</b>
 <select name="codemp">
 <option value=0></option>');
 -- Recorremos todos los empleados 
	FOR C1_REG IN C1 LOOP
		htp.p('<option ');
		IF C1_REG.empno = codemp THEN
			htp.p('selected="selected"');
		END IF;
		htp.p(' value='||C1_REG.empno||'>'||C1_REG.ename||'</option>');
	END LOOP;
	
 
 htp.p('<INPUT TYPE="submit" VALUE="Buscar">
</form>
<hr>
</body>
</html>
');

	IF codemp <> 0 THEN
	
	SELECT * INTO temporal FROM emp WHERE empno = codemp;
	
	htp.p('<h2>Datos del empleado '||temporal.empno||'</h2>
 <table width="40%" border="0">
 
 <tr>
 <td><b>Num:
 </b>'||temporal.empno||'</td>
 </tr> 
 <tr>
 <td><b>Nombre:
 </b>'||temporal.ename||'</td>

 </tr> 
 <tr>
 <td><b>Puesto:
 </b>'||temporal.job||'</td>
 </tr> 
 <tr>
 <td><b>Num. Jefe:
 </b>'||temporal.mgr||'</td>
 </tr> 
 <tr>

 <td><b>Antiguedad:
 </b>'||temporal.hiredate||'</td>
 </tr> 
 <tr>
 <td><b>Salario:
 </b>'||temporal.sal||'</td>
 </tr> 
 <tr>
 <td><b>Comisión:
 </b>'||temporal.comm||'</td>

 </tr> 
 <tr>
 <td><b>Num. Dep.:
 </b>'||temporal.deptno||'</td>
 </tr> 
 </table>');
	
	END IF;

END;
/





--http://2dai21/dadscott/listar_datos_emp

-- http://informatica.lazarocardenas.org:7777/dadalvaro/listar_datos_emp