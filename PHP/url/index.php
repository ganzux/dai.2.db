<?
/*
INSTRUCCIONES
 
 1.Creación de la Tabla
El nombre que le pongas a la tabla ha de ser el mismo que el de la variable $dbtabla
  
CREATE TABLE redirecciones (id INT AUTO_INCREMENT PRIMARY KEY,
url VARCHAR(255) UNIQUE NOT NULL,
creacion DATE NOT NULL,
ultacceso DATE NOT NULL);
*/
?>
<html>
	<head>
		<title>Redirección de Web</title>
	    <link href="estilo.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<p>&nbsp;</p>
		<p class="calmonths">PRUEBAS DE REDIRECCIÓN </p>
<?php
////////////////////////////////////////////////////
//////       BASE, CONFIGURACIÓN E INICIO       ///////
////////////////////////////////////////////////////

// Datos para la base de Datos

$dbhost  = 'localhost';					// Normalmente localhost
$dbname  = 'lo_que_sea';				// Nombre de la BBDD a utilizar
$dbuser  = 'root';						// Usuario de la BBDD
$dbpass  = '';							// password de la BBDD
$dbtabla = 'redirecciones';				// El mismo que con el que creaste la Tabla
$ruta    = 'http://www.h2m.es/url/?u=';	// Ruta COMPLETA donde subirás el programa

// Conexión a la Base de Datos
$conn = mysql_connect($dbhost, $dbuser, $dbpass) or die ('Error conectando al servidor MySQL');
mysql_select_db($dbname);

////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////

// Si existe la Variable de la dirección
if ((isset($_GET['u']) OR isset($_POST['u'])) AND ($_GET['u']!="" OR $_POST['u']!=""))
{
	// Si existe el botón de crear nuevo enlace
	if ((isset($_GET['n']) OR isset($_POST['n'])) AND ($_GET['n']!="" OR $_POST['n']!=""))
	{
		// Buscamos en la base de datos la dirección
		$sentencia="SELECT url,id FROM ".$dbtabla." WHERE url = '".$u."'";
		$resultado = mysql_query($sentencia);
		$filas     = mysql_num_rows($resultado);
		
		// Si $filas > 0 es que ya existe esa direccion
		if ($filas > 0)
		{
			// Cargamos la fila
			$row = mysql_fetch_row($resultado);

			// Hacemos un UPDATE en la fila
			$update = "UPDATE ".$dbtabla." SET ultacceso=curdate() WHERE id = ".$row[1];
			$lanza  = mysql_query($update);

			// Y la imprimimos la dirección
			echo "Dirección para su ruta: <p>".$row[0]." <--> ".$ruta.$row[1];
		}
		
		// Si hay 0 filas, insertamos la nueva dirección
		else
		{
			// Hacemos el INSERT INTO de la dirección
			$sentencia="INSERT INTO ".$dbtabla." (url,creacion,ultacceso) VALUES ('".$u."',curdate(),curdate())";
			$resultado = mysql_query($sentencia);
			
			// Miramos a ver qué fila hicimos
			$sentencia="SELECT url,id FROM ".$dbtabla." WHERE url = '".$u."'";
			$resultado = mysql_query($sentencia);
			$row = mysql_fetch_row($resultado);
			
			// Y lo escribimos por pantalla
			echo "Redirección creada: <p>".$row[0]." <--> ".$ruta.$row[1];
		}
	}
	
	// No existe el botón nuevo, o sea, Redirección
	else
	{
		// Miramos a ver si existe la variable pasada
		$sentencia = "SELECT url,id FROM ".$dbtabla." WHERE id = '".$u."'";
		$resultado = mysql_query($sentencia);
		$filas     = mysql_num_rows($resultado);
		
		if ($filas != 0)
			{
			// Cargamos la fila
			$row = mysql_fetch_row($resultado);
			
			// Hacemos un UPDATE en la fila
			$update = "UPDATE ".$dbtabla." SET ultacceso=curdate() WHERE id = ".$row[1];
			$lanza  = mysql_query($update);
			
			// Redirigimos
			echo "Location: ".$row[0]."";
			header("Location: ".$row[0]."");
			// Y salimos
			exit;
			}
		else
			echo "No existe esa dirección";
	}
}

// No Existe la Variable, Página principal
else
{?>
		<form method="POST">
			<p>
			  <input type="text"   name="u" size="50" value="http://">
			  <input type="submit" name="n" value="Nuevo Enlace">
			  <input type="reset"  value="Borrar">
		  </p>
			<p class="htmltop">&iquest;Para qu&eacute; sirve &eacute;ste Servicio? </p>
			<p class="htmltop">Sencillo, puedes convertir cualquier direcci&oacute;n de Internet en otra m&aacute;s corta, creando con ello un &quot;Acceso Directo&quot; m&aacute;s facil de recordar.</p>
		</form>

		<p>&nbsp;</p>

		<table width="70%" border="0" align="center">
          <tr>
            <td width="40%" class="ipb-top-left-link">http://www.supercalifragilisticoespialidoso.name /modulos/cgi/bin/BiXiTo/alvarITO/lo_que_sea/otro _directorio_mas/y_seguimos/ultimo/index.php?opci on=1241235&amp;dfg=4576yvmn&amp;rty=sdfjudgkhlbjk</td>
            <td width="20%" class="ipb-top-left-link">--></td>
            <td width="40%" class="ipb-top-left-link"><?php echo $ruta; ?>1</td>
          </tr>
        </table>
<?php
}

// Cerramos la conexión
mysql_close($conn);
?>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
	</body>
</html>