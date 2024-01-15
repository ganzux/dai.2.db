OPTIONS (ERRORS=5, SILENT=(FEEDBACK))
LOAD DATA
INFILE 'a:\TituloAutorNacionalidad.txt'
INTO TABLE tit_aut_nac
FIELDS TERMINATED BY '#'
OPTIONALLY ENCLOSED BY '"'
(titulo, autor, nacionalidad)