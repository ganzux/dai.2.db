--          @ 'C:\Documents and Settings\AlVaRiTo\Escritorio\\foro miércoles_casa\subebaja.sql'


CREATE OR REPLACE PACKAGE document_api AS

PROCEDURE upload (file  IN  VARCHAR2, tema VARCHAR2 DEFAULT NULL);
PROCEDURE download;
PROCEDURE download (file  IN  VARCHAR2);

END;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY document_api AS

-- ----------------------------------------------------------------------------
PROCEDURE upload (file  IN  VARCHAR2,tema VARCHAR2 DEFAULT NULL) AS
-- ----------------------------------------------------------------------------
  l_real_name  VARCHAR2(1000);
BEGIN

  HTP.htmlopen;
  HTP.headopen;
  HTP.title('Subida de Ficheros');
  HTP.headclose;
  HTP.p('<BODY onload="actualizaPadre()">');
  HTP.P('<!-- Añadimos la hoja de estilos correspondiente -->
<LINK href="../alumnos/Alvaro/css/hoja.css" rel="stylesheet" type="text/css">');
  HTP.header(1, 'Estado de la subida');

  l_real_name := SUBSTR(file, INSTR(file, '/') + 1);

  BEGIN
    -- Delete any existing document to allow update.
    DELETE FROM documents
    WHERE  name = l_real_name;

    -- Update the prefixed name with the real file name.
    UPDATE documents
    SET    name = l_real_name
    WHERE  name = file;
	HTP.P('<form name="nuevo_mensaje"><input name="archivo" type="hidden" value="'||l_real_name||'"></form>');
    HTP.print('<H4>Fichero ' || l_real_name || ' subido correctamente.</H4>');
	HTP.print('<H3>¡ <u>No cierre esta Ventana</u> !</H3><H5>(Se cerrará automáticamente)</h5>');
  
  HTP.P('<script language="JavaScript">
  function actualizaPadre()
  {
    window.opener.document.nuevo_mensaje.archivo.value="'||l_real_name||'"
    window.opener.document.nuevo_mensaje.archivoculto.value="'||l_real_name||'"
    window.close()
  }
</script> ');
  
  EXCEPTION
    WHEN OTHERS THEN
      HTP.print('Fichero ' || l_real_name || ' fallido.');
      HTP.print(SQLERRM);
  END;
  HTP.br;
  HTP.P('<!-- Barra Horizontal separadora -->
<hr align="center" width="75%">
<!-- Pie de Página de todas las webs -->
<CENTER><div class="copyright">Powered by PL/SQL © 2007 iTo Group</div></CENTER>
<!-- Fin de la Web, cerrando el Body y el Html -->
</BODY></HTML>');
END;
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
PROCEDURE download IS
-- ----------------------------------------------------------------------------
  l_filename  VARCHAR2(255);
BEGIN
  l_filename := SUBSTR(OWA_UTIL.get_cgi_env('PATH_INFO'), 2);
  WPG_DOCLOAD.download_file(l_filename);
EXCEPTION
  WHEN OTHERS THEN
    HTP.htmlopen;
    HTP.headopen;
    HTP.title('File Downloaded');
    HTP.headclose;
    HTP.bodyopen;
    HTP.header(1, 'Download Status');
    HTP.print('Download of ' || l_filename || ' failed.');
    HTP.print(SQLERRM);
    HTP.bodyclose;
    HTP.htmlclose;
END;
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
PROCEDURE download (file  IN  VARCHAR2) AS
-- ----------------------------------------------------------------------------
  l_blob_content  documents.blob_content%TYPE;
  l_mime_type     documents.mime_type%TYPE;
BEGIN
  SELECT blob_content,
         mime_type
  INTO   l_blob_content,
         l_mime_type
  FROM   documents
  WHERE  name = file;

  OWA_UTIL.mime_header(l_mime_type, FALSE);
  HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_blob_content));
  OWA_UTIL.http_header_close;

  WPG_DOCLOAD.download_file(l_blob_content);
EXCEPTION
  WHEN OTHERS THEN
    HTP.htmlopen;
    HTP.headopen;
    HTP.title('File Downloaded');
    HTP.headclose;
    HTP.bodyopen;
    HTP.header(1, 'Download Status');
    HTP.print(SQLERRM);
    HTP.bodyclose;
    HTP.htmlclose;
END;
-- ----------------------------------------------------------------------------

END;
/
SHOW ERRORS