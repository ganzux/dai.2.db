CREATE OR REPLACE TRIGGER deudor
AFTER INSERT ON reservas
FOR EACH ROW
BEGIN
	UPDATE clientesv
	SET saldo_deudor = saldo_deudor + (:new.num_plazas * (SELECT precio FROM viajes WHERE codigo = :new.codigo_v))
	WHERE clientesv.codigo = :new.codigo_c;
END;
/
show errors

SELECT * FROM clientesv;

INSERT INTO reservas (CODIGO_V,CODIGO_C,FECHA_RES,NUM_PLAZAS)
VALUES ('A234','12990',SYSDATE,2);

SELECT * FROM clientesv;