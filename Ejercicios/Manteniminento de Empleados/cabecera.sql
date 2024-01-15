-- @ 'C:\Documents and Settings\alumno2dai\Escritorio\Manteniminento de Empleados\cabecera.sql'
-- @ 'E:\DAI - II\Oracle\Ejercicios PL-SQL Web Toolkit\Manteniminento de Empleados\cabecera.sql'


--  @ 'C:\Documents and Settings\AlVaRiTo\Escritorio\Manteniminento de Empleados\cabecera.sql'

CREATE OR REPLACE PACKAGE mant_emp AS

PROCEDURE principal (ordena NUMBER DEFAULT 2, operacion VARCHAR2 default 'muestra', 
					nombre VARCHAR2 default null, trabajo VARCHAR2 default null,
					jefe VARCHAR2 default null, contr DATE default null, 
					money NUMBER default null, comision NUMBER default null, depart NUMBER default null,
					id NUMBER default null);

END mant_emp;
/