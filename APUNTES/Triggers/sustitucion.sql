create OR REPLACE view emplead as
select empno,ename,job,dname
from emp,dept
where emp.deptno=dept.deptno;


SQL> select * from emplead;

     EMPNO ENAME      JOB       DNAME
---------- ---------- --------- --------------
      7839 KING       PRESIDENT ACCOUNTING
      7782 CLARK      MANAGER   ACCOUNTING
      7934 MILLER     CLERK     ACCOUNTING
      7566 JONES      MANAGER   RESEARCH
      7902 FORD       ANALYST   RESEARCH
      7369 SMITH      CLERK     RESEARCH
      7788 SCOTT      ANALYST   RESEARCH
      7876 ADAMS      CLERK     RESEARCH
      7698 BLAKE      MANAGER   SALES
      7900 JAMES      CLERK     SALES
      7521 WARD       SALESMAN  SALES

     EMPNO ENAME      JOB       DNAME
---------- ---------- --------- --------------
      7844 TURNER     SALESMAN  SALES
      7654 MARTIN     SALESMAN  SALES

13 filas seleccionadas.

--oPERACIONES DE MANIPULACION SOBRE LA VISTA CON RESULTADO FALLIDO

SQL> insert into emplead values(7999,'PEPE','SALESMAN','SALES');
insert into emplead values(7999,'PEPE','SALESMAN','SALES')
*
ERROR en línea 1:
ORA-01776: cannot modify more than one base table through a join view

SQL> update emplead set dname='RESEARCH' where ename='KING';
update emplead set dname='RESEARCH' where ename='KING'
                   *
ERROR en línea 1:
ORA-01779: cannot modify a column which maps to a non key-preserved table

--CREACION DE UN TRIGGER DE SUSTITUCION PARA FACILITAR OPERACIONES DE ACTUALIZACION
-- A TRAVES DE LA VISTA EMPLEAD

CREATE OR REPLACE TRIGGER t_ges_emplead
INSTEAD OF DELETE OR INSERT OR UPDATE  ON emplead
FOR EACH ROW
DECLARE
	v_dept dept.deptno%TYPE;
BEGIN
	IF DELETING THEN
		DELETE FROM EMP WHERE empnO=:old.empno;
	ELSIF INSERTING THEN
		SELECT deptno INTO v_dept FROM DEPT
		WHERE dept.dname=:new.dname;
		INSERT INTO emp(empno,ename,job,deptno) 
			VALUES(:new.empno,:new.ename,:new.job,v_dept);
	ELSIF UPDATING('dname') THEN
	    	SELECT deptno INTO v_dept FROM dept
		WHERE dept.dname=:new.dname;
		UPDATE emp set deptno=v_dept
		WHERE empno=:old.empno;
	
	ELSIF UPDATING('job') THEN	
		UPDATE emp set job=:new.job
		WHERE empno=:old.empno;
	ELSE
		RAISE_APPLICATION_ERROR(-20500,'Error en al actualización');
	END IF;
END;
/


--actualizaciones con el trigger;
