CREATE OR REPLACE PACKAGE encuesta AS

-- Cabecera Principal
PROCEDURE principal (voteID NUMBER DEFAULT NULL,Boton VARCHAR2 DEFAULT NULL);

-- Cabecera del Borrado
PROCEDURE resultado;

END encuesta;

/
show errors;