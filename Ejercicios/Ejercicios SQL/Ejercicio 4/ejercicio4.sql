-- Ejercicio 1

SELECT id_prov
FROM proveedor
WHERE saldo_deudor < (SELECT saldo_deudor
					  FROM proveedor
					  WHERE id_prov LIKE 'S3');


--2
select ename
	from emp
	where sal=( select min(sal)
			from emp
			where deptno=( select deptno
					   from dept
					   where loc='CHICAGO'));

--3.
select descripcion from articulo
where id_art in 
		(select id_art
               from stock
			group by id_art
                   having count(*)=1); 
--5.
select direccion
from almacen x
where exists
	(select *
	from stock
	where id_alm=x.id_alm
	and id_art='P2');

--6.
select ename 
from emp x
where sal>
	(select sal
	 from emp
	where empno=x.mgr);

--7.
Select id_art,descripcion
From articulo x
Where exists
(select count(*) 
 from stock
 where id_art=x.id_art
group by id_art
having count(*) >(select count(*)/2 from almacen));

--8.
select nombre
from articulo,proveedor
where proveedor=id_prov 
and id_art not in(
	select id_art
	from stock);

select nombre
from articulo x,proveedor
where proveedor=id_prov 
and not exists(
	select id_art
	from stock
where id_art=x.id_art); 
