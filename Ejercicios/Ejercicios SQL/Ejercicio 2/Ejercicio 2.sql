--Ejercicio 1:
select count(*) as "Número de empleados"
from emp;

--Ejercicio 2:
select count(count(*))
from emp
group by deptno;

--Ejercicio 3:
select count(*)
from emp
where deptno = 10;

--Ejercicio 4:
select SUM(sal)
from emp
where deptno = 10;

--Ejercicio 5:
select SUM(sal),deptno
from emp
group by deptno;

--Ejercicio 6:
select deptno
from emp
group by deptno
having count(*) > 3;

--Ejercicio 7:
select count(distinct job)
from emp
where deptno = 30;

--Ejercicio 8:
select deptno ,avg(sal), count (*)
from emp
where job = 'MANAGER'
group by deptno;

--Ejercicio 9:
select deptno , round ( avg(sal)) as Salario
from emp
group by deptno
having avg (sal) < 2500
order by 2 desc;

--Ejercicio 10:
select deptno, job, count(*)
from emp
group by deptno, job;