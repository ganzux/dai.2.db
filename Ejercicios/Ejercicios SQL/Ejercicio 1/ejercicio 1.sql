desc emp;

desc dept;

--1

SELECT dname,loc
FROM dept
ORDER BY 2;


--2

SELECT ename AS Nombre,sal+NVL(comm,0) AS Sueldo
FROM emp
where sal > 2000;


--3

SELECT ename
FROM emp
WHERE HIREDATE < '01/05/81'
AND comm > 0;


--4
--a

SELECT ename || ' ' || job as "Nombre y puesto"
FROM emp;

--b
select translate(ename,'AEIOU','aeiou')||' '||translate(lower(job),'aeiou','AEIOU') "Nombre y Puesto"
	from emp;


--5

SELECT ename,job,hiredate,sal
FROM emp
WHERE job != 'ANALYST'
AND
	(sal > 1500
	OR
	hiredate > '30/06/81');
	
--6
select ename,TO_CHAR(hiredate,'dd" de "month" de "yyyy')
	from emp;

--7
select ename,ROUND(MONTHS_BETWEEN(sysdate,hiredate)) "Meses contratado"
	from emp;

--8
select ename,SUBSTR(job,0,3)||'.' as "Puesto"
	from emp;

--9
select initcap(Lower(RPAD(dname,36,'*'))) "Departamentos"
	from dept;
	
--10
select ename, RPAD(EXTRACT (YEAR FROM (SYSDATE - hiredate) YEAR TO MONTH)
|| ' años '
|| EXTRACT (MONTH FROM (SYSDATE - hiredate) YEAR TO MONTH)
|| ' meses ',20) "Intervalo"
from emp;
