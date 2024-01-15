<?php
include "cabeceraypie.php";
	cabecera('','');
	tabla("Edición de calendario");
// Si existen TODOS los GET, hace la página, si no, NO
if (!isset($_GET['pelicula']) OR !isset($_GET['horas']) OR !isset($_GET['minutos']) OR !isset($_GET['idcine']) OR !isset($_GET['idsala']) OR !isset($_GET['sesion']))
	echo "<center><H3>Faltan parámetros. <A HREF='calendario.php'>Volver</A></H3></center>";
else{
	// Cogemos los vectores de peliculas, horas y minutos
	$sesiones  = $_GET["sesion"];
	$peliculas = $_GET["pelicula"];
	$horas     = $_GET['horas'];
	$minutos   = $_GET['minutos'];
	$id_cine   = $_GET['idcine'];
	$id_sala   = $_GET['idsala'];
	
	// Datos de la sala
	$sentencia = 'SELECT * from '.$dbname.'.'.$dbpref.'salas WHERE id = '.$id_sala;
	$lanzada   = mysql_query ($sentencia);
	$datossala = mysql_fetch_row ($lanzada);
	// Datos del cine
	$sentencia = 'SELECT * FROM '.$dbname.'.'.$dbpref.'cines WHERE id = '.$id_cine;
	$lanzada   = mysql_query ($sentencia);
	$datoscine = mysql_fetch_row ($lanzada);
	
	echo "<center><H2>Estamos editando '".$datossala[1]."' del '".$datoscine[2]."'</H2></center>";
	echo "<center><H3>Datos de las películas</H3></center>";
	?>
	<table width="75%"  border="0" align="center" cellspacing="5">
  	<tr>
    <th width="60%">Película</th>
    <th width="30%">Hora</th>
    <th width="10%">Estado</th>
  	</tr>
	<?
	// Recorremos todo el vector de películas
	for($i = 0; $i < sizeof($peliculas); $i++)
		{
		// Si existen los datos de esa proyeccion (cambios o nuevos)
		if ($peliculas[$i] != "" AND $horas[$i] != "" AND $minutos[$i] != "" AND $sesiones[$i] != "")
		{
		// Suponemos en principio que no hay cambios en nada
		$cambio = "no";
		
		// Cojo los datos de la película que me han pasado para mostrarlos
		$sentencia = 'SELECT * from '.$dbname.'.'.$dbpref.'peliculas WHERE id = '.$peliculas[$i];
		$lanzada   = mysql_query ($sentencia);
		if (mysql_num_rows($lanzada) != 0)
			$datospeli = mysql_fetch_row ($lanzada);
		
		$sentencia = 'SELECT * FROM '.$dbname.'.'.$dbpref.'proyecciones WHERE id = '.$sesiones[$i];
		$lanzada   = mysql_query ($sentencia);
		if (mysql_num_rows($lanzada) != 0)
			$datossesion = mysql_fetch_row ($lanzada);
		
		// Si la id de la pelicula (datospeli[0]) es distinta de la id_pelicula de
		// proyecciones (datossesion[2]), entonces es que ha habido un cambio
		// en la película, teniendo que mirar también el horario
		if (($datospeli[0] != $datossesion[2]) OR ($horas[$i].":".$minutos[$i]) != $datossesion[3])
			$cambio="si";

				
		echo "<TR>";
		echo "<TD align='center'>$datospeli[1]</TD>";
		echo "<TD align='center'>$horas[$i] : $minutos[$i]</TD>";
		echo "<TD align='center'>";
		if ($cambio == "si")
			echo "Modificado";
		else
			echo "Sin cambios";
		echo "</TD>";
		echo "</TR>";
		
		}// Fin de que se le pasen valores en ese vector
		
		
		// Si no existe sesion, pero existen el resto de opciones, peli nueva
		if ($peliculas[$i] != "" AND $horas[$i] != "" AND $minutos[$i] != "" AND $sesiones[$i] == "")
		{
		echo "<TR>";
		echo "<TD align='center'>$datospeli[1]</TD>";
		echo "<TD align='center'>$horas[$i] : $minutos[$i]</TD>";
		echo "<TD align='center'>Nueva</TD>";
		echo "</TR>";
		}
		
		// Si existe la sesion pero no existe la pelicula, es que se borra
		if ($sesiones[$i] != "" AND $peliculas[$i] == "")
		{
		// recojo los datos de la antigua proyeccion
		$sentencia  = 'SELECT * FROM '.$dbname.'.'.$dbpref.'proyecciones WHERE id = '.$sesiones[$i];
		$lanzada    = mysql_query ($sentencia);
		$datosesion = mysql_fetch_row ($lanzada);
		
		// Hacemos el INSERT INTO en la tabla historico y borramos la proyeccion		
		$sentencia  = 'INSERT INTO '.$dbname.'.'.$dbpref.'historico_proyecciones (id_sala,id_pelicula,hora_inicio,fecha) VALUES ('.$datosesion[1].','.$datosesion[2].',"'.$datosesion[3].'","'.$datosesion[4].'")';
		$lanzada    = mysql_query ($sentencia);
		
		// Borramos el registro de la tabla proyecciones
		$sentencia  = 'DELETE FROM '.$dbname.'.'.$dbpref.'proyecciones WHERE id = '.$sesiones[$i];
		$lanzada    = mysql_query ($sentencia);
				
		echo "<TR>";
		echo "<TD align='center'>Película</TD>";
		echo "<TD align='center'>$horas[$i] : $minutos[$i]</TD>";
		echo "<TD align='center'>Eliminado</TD>";
		echo "</TR>";
		}
			
		}// Fin del recorrimiento del vector de películas
?>
	</table>
<?php
}// Else, existen todos los parámetros
pie();
?>
