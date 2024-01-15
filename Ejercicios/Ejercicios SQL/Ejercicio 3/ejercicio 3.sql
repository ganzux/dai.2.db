-- Ejercicio 1:

select nombre,saldo_deudor
from articulo, proveedor
where proveedor=id_prov 
and id_art='R3';


-- Ejercicio 2:

select almacen.id_alm, direccion
from almacen, stock
where almacen.id_alm = stock.id_alm
and stock.id_art = 'P5';


-- Ejercicio 3:

select stock.id_art
from almacen, stock
where almacen.id_alm = stock.id_alm
and almacen.direccion like '%34%';


-- Ejercicio 4:

select articulo.descripcion
from articulo, stock
where stock.id_art = articulo.id_art
and stock.id_alm = 'A1';


-- Ejercicio 5:

select sum((articulo.precio_vent-articulo.precio_comp)*stock.cant)
from articulo, stock
where articulo.id_art = stock.id_art
and stock.id_art = 'P3';


-- Ejercicio 6:

select descripcion, SUM(cant),articulo.id_art
from articulo , stock
where articulo.id_art = stock.id_art
and ord_pte IS NOT NULL
GROUP BY articulo.id_art, descripcion;


-- Ejercicio 7:

select descripcion , direccion , cant
from articulo , stock , almacen
where articulo.id_art = stock.id_art
and almacen.id_alm = stock.id_alm
order by 1;

select descripcion , direccion , cant
from articulo a INNER JOIN stock s
ON a.id_art = s.id_art
INNER JOIN almacen al
ON al.id_alm = s.id_alm
order by 1;


-- Ejercicio 8:

select proveedor.nombre
from proveedor LEFT JOIN articulo
ON articulo.proveedor = proveedor.id_prov
where articulo.proveedor IS NULL;

select proveedor.nombre
from proveedor FULL OUTER JOIN articulo
ON articulo.proveedor = proveedor.id_prov
where articulo.proveedor IS NULL;