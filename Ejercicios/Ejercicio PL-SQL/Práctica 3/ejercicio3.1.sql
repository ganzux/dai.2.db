-- Borrado y creación de las dos tablas
DROP TABLE ACCIONES;
CREATE TABLE ACCIONES (ID_CUENTA NUMBER,  TIPO_OP CHAR(1),
		       NUEVO_SALDO NUMBER, INCIDENTES VARCHAR2(40));
	INSERT INTO ACCIONES VALUES (3,'U',599,NULL);
	INSERT INTO ACCIONES VALUES (6,'I',20099,NULL);
	INSERT INTO ACCIONES VALUES (5,'D',NULL,NULL);
	INSERT INTO ACCIONES VALUES (7,'U',1599,NULL);
	INSERT INTO ACCIONES VALUES (1,'I',399,NULL);
	INSERT INTO ACCIONES VALUES (9,'D',NULL,NULL);
	INSERT INTO ACCIONES VALUES (10,'X',NULL,NULL);

DROP TABLE SALDO;
CREATE TABLE SALDO (ID_CUENTA NUMBER, SALDO_CUENTA NUMBER,
		     CONSTRAINT SALDOS_PK2 PRIMARY KEY (ID_CUENTA)); 
	INSERT INTO SALDO VALUES (1,1000);
	INSERT INTO SALDO VALUES (2,2000);
	INSERT INTO SALDO VALUES (3,1500);
	INSERT INTO SALDO VALUES (4,6500);
	INSERT INTO SALDO VALUES (5,0);

-- SCRIPT
DECLARE
	CURSOR c_acciones IS
		SELECT * FROM acciones FOR UPDATE;
	
	c_acciones_reg c_acciones%ROWTYPE;

BEGIN
	-- Abrimos el cursor
	OPEN c_acciones;
	-- Pasamos la primera fila a la variable de registro
	FETCH c_acciones INTO c_acciones_reg;
	-- Corremos el bucle mientras existan datos a volcar:
	WHILE c_acciones%FOUND LOOP
		-- UPDATE o INSERT
		IF c_acciones_reg.tipo_op='U' OR c_acciones_reg.tipo_op='I' THEN

			UPDATE acciones
			SET incidentes = 'UPDATE realizado'
			WHERE CURRENT OF c_acciones;
			
			UPDATE saldo
			SET saldo_cuenta = c_acciones_reg.nuevo_saldo
			WHERE c_acciones_reg.id_cuenta = saldo.id_cuenta;

			-- Si dio error la DML anterior
			IF SQL%NOTFOUND THEN
				INSERT INTO saldo
				VALUES (c_acciones_reg.id_cuenta,c_acciones_reg.nuevo_saldo);

				UPDATE acciones
				SET incidentes = 'INSERT realizado'
				WHERE CURRENT OF c_acciones;
			END IF;

		-- DELETE
		ELSIF c_acciones_reg.tipo_op='D' THEN
			DELETE FROM saldo
			WHERE c_acciones_reg.id_cuenta = saldo.id_cuenta;
			
			-- Si dio error la DML anterior
			IF SQL%NOTFOUND THEN
				UPDATE acciones
				SET incidentes = 'ERROR en DELETE. No existe la cuenta'
				WHERE CURRENT OF c_acciones;
			END IF;
			
			UPDATE acciones
			SET incidentes = 'DELETE realizado con éxito'
			WHERE CURRENT OF c_acciones;
			
		-- EL RESTO
		ELSE
			UPDATE acciones SET incidentes='Tipo de Operación NO válida'
			WHERE CURRENT OF c_acciones;
			
		END IF;
		-- Hacemos el FETCH
		FETCH c_acciones INTO c_acciones_reg;
	-- Fin del bucle que recorre todo
	END LOOP;
	CLOSE c_acciones;
	COMMIT;
END;
/