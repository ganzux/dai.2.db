CREATE OR REPLACE PACKAGE delete_emp AS

-- Un tipo INDEX BY
TYPE coll_empno_t IS TABLE OF VARCHAR2(5)
 INDEX BY BINARY_INTEGER;
-- sin_respuesta lo inicializamos para que yano tenga NULL y pueda ir sin valor
sin_respuesta coll_empno_t;

-- Cabecera Principal
PROCEDURE principal;

-- Cabecera del Borrado
PROCEDURE borrar_empleados (coll_resp delete_emp.coll_empno_t DEFAULT delete_emp.sin_respuesta);

END delete_emp;

/
show errors;