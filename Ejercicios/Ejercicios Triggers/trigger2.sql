SET SERVEROUTPUT ON
CREATE TABLE guia_sal(
JOB VARCHAR2(10),
MINSAL NUMBER(7),
MAXSAL NUMBER(7));
INSERT INTO guia_sal VALUES ('ANALYST',2000,3700);
INSERT INTO guia_sal VALUES ('CLERK',1500,3500);
INSERT INTO guia_sal VALUES ('SALESMAN',1000,2000);
INSERT INTO guia_sal VALUES ('MANAGER',2000,5000);
INSERT INTO guia_sal VALUES ('PRESIDENT',3000,5000);

CREATE OR REPLACE TRIGGER rev_salario
BEFORE INSERT OR UPDATE ON emp
FOR EACH ROW

DECLARE
saldmax guia_sal.maxsal%TYPE := 0;
saldmin guia_sal.minsal%TYPE := 0;

BEGIN
SELECT maxsal INTO saldmax FROM guia_sal WHERE guia_sal.job = :new.job;
SELECT minsal INTO saldmin FROM guia_sal WHERE guia_sal.job = :new.job;

	IF :new.sal > saldmax OR :new.sal < saldmin THEN
		raise_application_error (-20261,'¡Salario '||:new.sal||' está fuera del rango de '||:new.job||' para el empleado '||:new.ename);
	END IF;
END;
/
show errors


----------- PRUEBAS:
-- INSERT:
-- Salario correcto
INSERT INTO emp VALUES (1,'Nombre 1','CLERK',8012,SYSDATE,2000,0,10);
-- Salario incorrecto:
INSERT INTO emp VALUES (6,'Nombre 6','CLERK',8012,SYSDATE,20000,0,10);
INSERT INTO emp VALUES (6,'Nombre 6','CLERK',8012,SYSDATE,2,0,10);
select * from emp where empno < 100;

-- UPDATE
INSERT INTO emp VALUES (10,'Prueba','SALESMAN',8012,SYSDATE,1500,0,10);
-- Correcto
UPDATE emp SET sal = 1500 WHERE job = 'SALESMAN' AND empno = 10;
-- Incorrecto
UPDATE emp SET sal = 15000 WHERE job = 'SALESMAN' AND empno = 10;
UPDATE emp SET sal = 15 WHERE job = 'SALESMAN' AND empno = 10;
select * from emp where empno < 100;