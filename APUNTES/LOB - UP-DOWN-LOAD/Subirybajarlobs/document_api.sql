CREATE OR REPLACE PACKAGE document_api AS

PROCEDURE upload (file  IN  VARCHAR2);
PROCEDURE download;
PROCEDURE download (file  IN  VARCHAR2);

END;
/
SHOW ERRORS


CREATE OR REPLACE PACKAGE BODY document_api AS

-- ----------------------------------------------------------------------------
PROCEDURE upload (file  IN  VARCHAR2) AS
-- ----------------------------------------------------------------------------
  l_real_name  VARCHAR2(1000);
BEGIN

  HTP.htmlopen;
  HTP.headopen;
  HTP.title('File Uploaded');
  HTP.headclose;
  HTP.bodyopen;
  HTP.header(1, 'Upload Status');

  l_real_name := SUBSTR(file, INSTR(file, '/') + 1);

  BEGIN
    -- Delete any existing document to allow update.
    DELETE FROM documents
    WHERE  name = l_real_name;

    -- Update the prefixed name with the real file name.
    UPDATE documents
    SET    name = l_real_name
    WHERE  name = file;

    HTP.print('Uploaded ' || l_real_name || ' successfully.');
  EXCEPTION
    WHEN OTHERS THEN
      HTP.print('Upload of ' || l_real_name || ' failed.');
      HTP.print(SQLERRM);
  END;
  HTP.br;

  -- Create some links to demonstrate URL downloads.
  HTP.br;
  HTP.print('URL Downloads:');
  HTP.br;
  FOR cur_rec IN (SELECT name FROM documents) LOOP
    HTP.anchor('docs/' || cur_rec.name, 'docs/' || cur_rec.name);
    HTP.br;
  END LOOP;

  -- Create some links to demonstrate direct downloads.
  HTP.br;
  HTP.print('Direct Downloads:');
  HTP.br;
  FOR cur_rec IN (SELECT name FROM documents) LOOP
    HTP.anchor('document_api.download?file=' || cur_rec.name, 'document_api.download?file=' || cur_rec.name);
    HTP.br;
  END LOOP;

  HTP.bodyclose;
  HTP.htmlclose;
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
