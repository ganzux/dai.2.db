CREATE OR REPLACE  PROCEDURE listar_tit_aut (buscar_por VARCHAR2 DEFAULT 'autor', loquebusco VARCHAR2 DEFAULT null) IS

-- Metemos la sentencia en un VARCHAR2, justo antes de indicar qu� campo queremos comparar
sentencia VARCHAR2(1000) := 'SELECT scott.titulos.titulo,scott.autores.autor, scott.nacionalidades.nacionalidad
FROM scott.autores, scott.titulos, scott.nacionalidades
WHERE scott.autores.id_nac = scott.nacionalidades.id
AND scott.autores.id = scott.titulos.id_aut ';

TYPE CUR_T IS REF CURSOR;
CUR  CUR_T;

eltitulo scott.titulos.titulo%TYPE;
elautor scott.autores.autor%TYPE;
lanacionalidad scott.nacionalidades.nacionalidad%TYPE;

cont NUMBER(3) := 0;

texto VARCHAR2(20);

-- Inicializamos el HTML:
BEGIN

HTP.P('<html>
	<head>
		<title>Busqueda de libros</title>
	</head>

	<body>
		<h1>Buscar libros por titulo o autor</h1>

	<hr>

	<form action=listar_tit_aut method="get" >
	<b>Selecciona el campo de b�squeda</b>
		<select name="buscar_por">
			<option value=autor>Autor</option>
			<option value=titulo');
			
			-- Si la opcion a buscar es por Titulo, que lo deje seleccionado
			IF buscar_por LIKE 'titulo' THEN
				htp.p('selected="selected"');
			END IF;
			
			htp.p('>T�tulo</option>
		</select>

	<b>Introduce el texto de busqueda</b>
		<input type="text" name="loquebusco" size="20" maxlength="30" value="'||loquebusco||'">

	<input type="submit" value="Buscar">
	</form>

	<hr>');

-- Si tenemos un texto a buscar
IF loquebusco IS NOT NULL THEN

	-- Terminamos la sentencia sql
	sentencia := sentencia || 'AND UPPER('||buscar_por||') LIKE UPPER(''%'||loquebusco||'%'')';

	-- Genero la tabla
	HTP.P('<h2>Libros Localizados:</h2>
		<table width="75%" border="2" align="center">
			<tr>
				<th align="left" width=50%>T�tulo</th>
				<th align="left" width=30%>Autor</th>
				<th align="left" width=20%>Nacionalidad</th>
			</tr>');


	OPEN CUR FOR sentencia;
		LOOP
			FETCH CUR INTO eltitulo,elautor,lanacionalidad;
			EXIT WHEN CUR%NOTFOUND;
			HTP.P('<TR>');
			HTP.P('<TD>'||eltitulo||'</TD><TD>'||elautor||'</TD><TD>'||lanacionalidad||'</TD>');
			HTP.P('</TR>');
			cont := cont + 1;
		END LOOP;
	CLOSE CUR;

	
HTP.P('</table>

Localizados <b>'||cont||' libros</b> que se ajustan a la busqueda pedida');
END IF;

htp.p('</body></html>');


EXCEPTION
	WHEN OTHERS THEN
		htp.p(sentencia);
		
END listar_tit_aut;
/
show errors;
-- @ 'C:\Documents and Settings\alumno2dai\Escritorio\EXAMEN\CUERPO.sql'