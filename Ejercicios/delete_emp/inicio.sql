SET DEFINE OFF
-- Borramos la tabla de copia
DROP TABLE copia_empleados;
-- La creamos con los elemento de la tabla emp, pero SIN restricciones
CREATE TABLE copia_empleados
	AS SELECT * FROM emp;