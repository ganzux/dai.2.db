<?PHP
// Cogemos los datos y los metemos en una estructura válida
$dbhost = 'localhost';
$dbname = 'cine';
$dbpref = '';
$dbuser = 'root';
$dbpass = '';

$cadena = '<?php';
$cadena = $cadena."\n".'//Datos del Host';
$cadena = $cadena."\n".'$dbhost = "'.$dbhost.'";';
$cadena = $cadena."\n".'//Datos del nombre de la base de datos';
$cadena = $cadena."\n".'$dbname = "'.$dbname.'";';
$cadena = $cadena."\n".'//Datos del Prefijo';
$cadena = $cadena."\n".'$dbpref = "'.$dbpref.'";';
$cadena = $cadena."\n".'//Datos del Usuario';
$cadena = $cadena."\n".'$dbuser = "'.$dbuser.'";';
$cadena = $cadena."\n".'//Datos del password';
$cadena = $cadena."\n".'$dbpass = "'.$dbpass.'";';
$cadena = $cadena."\n\n\n\n".'//Creado en febrero/Marzo de 2007 por Álvaro Alcedo Moreno, Eduardo Quero Salorio y Alberto Jiménez Soria'."\n\n".'?>';
//abre un archivo y escribe en él
$archivo = fopen("library/config.php" , "w+");

// Si se ha abierto con éxito
if ($archivo) {
fputs ($archivo, $cadena);
	echo "Archivo de Configuración creado correctamente";
}
else
	echo "No se pudo crear el archivo de configuración. Consulte el manual para más información";

fclose ($archivo);

?>