SET SERVEROUTPUT ON
SET LINESIZE 120

CREATE OR REPLACE PROCEDURE nueva_reserva(
codigo_viaje    IN reservas.codigo_v%TYPE,
codigo_cliente  IN reservas.codigo_c%TYPE,
plazas_reservar IN reservas.num_plazas%TYPE default 1)
IS
-- Excepciones
ex_cliente_no_existe EXCEPTION;
ex_viaje_no_existe EXCEPTION;
ex_viaje_finalizado EXCEPTION;
ex_no_quedan_plazas EXCEPTION;
ex_moroso EXCEPTION;
-- Variables temporales
var NUMBER(10);
fecha DATE;

BEGIN
-- Meto en la variable temporal el n�mero de clientes
SELECT COUNT(*) INTO var FROM clientesv WHERE codigo=codigo_cliente;
-- Si el Cliente no existe, que me lance la excepci�n
IF var <> 1 THEN
	RAISE ex_cliente_no_existe;
END IF;

-- Meto en la variable temporal el n�mero de viajes que coinciden con el pasado
SELECT COUNT(*) INTO var FROM viajes WHERE codigo=codigo_viaje;
-- Si el Viaje  no existe, que me lance la excepci�n
IF var <> 1 THEN
	RAISE ex_viaje_no_existe;
END IF;

-- Meto en la variable temporal la fecha del viaje, que ya s� que existe
SELECT fecha_ini INTO fecha FROM viajes WHERE codigo=codigo_viaje;
-- Si la fecha de inicio del viaje es menor que hoy
IF fecha<SYSDATE THEN
	RAISE ex_viaje_finalizado;
END IF;

--Meto el n�mero de plazas que quedan en ese viaje en la variable temporal
SELECT plazas-SUM(num_plazas) INTO var
	FROM reservas, viajes
	WHERE reservas.codigo_v = viajes.codigo
	AND codigo_viaje = codigo
	GROUP BY plazas,codigo;
-- Si el n�mero de plazas libres es menor que las que intentamos reservar, lanza excepcion
IF var < plazas_reservar THEN
	RAISE ex_no_quedan_plazas;
END IF;

-- Meto en la variable temporal el dinero que debe el cliente
SELECT saldo_deudor INTO var FROM clientesv WHERE codigo=codigo_cliente;
-- Si el cliente debe m�s de 500 000, lanza la excepci�n
IF var > 500000 THEN
	RAISE ex_moroso;
END IF;

/*  Si hemos llegado a �ste punto, no se ha lanzado ninguna excepci�n,
luego podemos hacer las acciones  */

-- INSERT INTO de la tabla reservas:
INSERT INTO reservas (CODIGO_V, CODIGO_C, FECHA_RES , NUM_PLAZAS)
VALUES (codigo_viaje,codigo_cliente,SYSDATE,plazas_reservar);

COMMIT;

-- Bloque de excepciones
EXCEPTION
WHEN ex_cliente_no_existe THEN
	DBMS_OUTPUT.PUT_LINE('Error: Ese cliente no existe');
	ROLLBACK;
	
WHEN ex_viaje_no_existe THEN
	DBMS_OUTPUT.PUT_LINE('Error: Ese viaje no existe');
	ROLLBACK;
	
WHEN ex_viaje_finalizado THEN
	DBMS_OUTPUT.PUT_LINE('Error: El viaje ya empez�');
	ROLLBACK;
	
WHEN ex_no_quedan_plazas THEN
	DBMS_OUTPUT.PUT_LINE('Error: No hay plazas suficientes para ese vuelo');
	ROLLBACK;
	
WHEN ex_moroso THEN
	DBMS_OUTPUT.PUT_LINE('Error: El cliente debe m�s de 500 000 �');
	ROLLBACK;
	
WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('Error: Se ha producido una Excepci�n'||SQLCODE||SQLERRM);
	ROLLBACK;
	
END nueva_reserva;
/





-- Hemos insertado una linea en Viajes con un viaje que ya ha empezado para ver si todo va OK
INSERT INTO viajes VALUES ('AAAA','10/10/05','10/10/07','MADRID',10000,100);


-- PRUEBA FINAL
EXECUTE nueva_reserva('A234','22000',3);

