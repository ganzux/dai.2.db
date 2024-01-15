--Ejercicio 1:


		

--Ejercicio 2:

UPDATE clientes cli SET debe = 
	(SELECT productos.precio_actual*pedidos.unidades 
	FROM productos, pedidos
	WHERE productos.producto_no = pedidos.producto_no
	AND cli.cliente_no = pedidos.cliente_no);

select nombre,debe from clientes;

--Ejercicio 3:



--Ejercicio 4:



--Ejercicio 5:



