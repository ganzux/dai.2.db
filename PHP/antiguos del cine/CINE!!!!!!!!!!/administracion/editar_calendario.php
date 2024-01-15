<?php


   function dateAdd($dias)
   {
      $mes = date("m");
      $anio = date("Y");
      $dia = date("d");
      $ultimo_dia = date( "d", mktime(0, 0, 0, $mes + 1, 0, $anio) ) ;
      $dias_adelanto = $dias;
      $siguiente = $dia + $dias_adelanto;
      if ($ultimo_dia < $siguiente)
      {
         $dia_final = $siguiente - $ultimo_dia;
         $mes++;
         if ($mes == '13')
         {
            $anio++;
            $mes = '01';
         }
         $fecha_final = $anio."-".$mes."-".$dia_final;
      }
      else
      {
         $fecha_final = $anio.'-'.$mes.'-'.$siguiente;         
      }
      return $fecha_final;
   }


include "cabeceraypie.php";
	cabecera('','');
	tabla("Edición de calendario");

// Si tiene permisos de administrador de cine (propietario)
	
if ($_SESSION["rango"] == 2){
// ALTA NUEVA
$ids = $_GET['idsala'];
$pel = $_GET["pelicula_nuevo"];
$hor = $_GET["horas_nuevo"];
$min = $_GET["minutos_nuevo"];
$ano = $_GET["ano_nuevo"];
$mes = $_GET["mes_nuevo"];
$dia = $_GET["dia_nuevo"];


if ($pel!="" AND $hor!="" AND $min!="" AND $ano!="" AND $mes!="" AND $dia!="" AND $ids!="")
	{
	echo "Alta nueva";
	
	//defino fecha 1
	$ano1 = $_GET['ano_nuevo'];
	$mes1 = $_GET['mes_nuevo'];
	$dia1 = $_GET['dia_nuevo'];
	
	//defino fecha 2
	$ano2 = date('Y');
	$mes2 = date('m');
	$dia2 = date('d');
	
	//calculo timestam de las dos fechas
	$timestamp1 = mktime(0,0,0,$mes1,$dia1,$ano1);
	$timestamp2 = mktime(4,12,0,$mes2,$dia2,$ano2);
	
	//resto a una fecha la otra
	$segundos_diferencia = $timestamp1 - $timestamp2;
	//echo $segundos_diferencia;
	
	//convierto segundos en días
	$dias_diferencia = $segundos_diferencia / (60 * 60 * 24);
	
	//obtengo el valor absoulto de los días (quito el posible signo negativo)
	$dias_diferencia = abs($dias_diferencia);
	
	//quito los decimales a los días de diferencia
	$dias_diferencia = floor($dias_diferencia);
	
	echo $dias_diferencia;

	for ($i=0;$i<=$dias_diferencia;$i++)
		{
		$fecha = dateAdd("$i");
		$nueva = "INSERT INTO proyecciones (id_sala,id_pelicula,hora_inicio,fecha_proyeccion) VALUES ($ids,$pel,'$hor:$min','$fecha')";
		echo $nueva;	
		$lanzada   = mysql_query ($nueva);
		}
	}


// Si existen los GET, hace la página, si no, NO
if (!isset($_GET['pelicula']) OR
	!isset($_GET['horas']) OR
	!isset($_GET['minutos']) OR
	!isset($_GET['idcine']) OR
	!isset($_GET['idsala']) OR
	!isset($_GET['sesion']) OR
	!isset($_GET['ano']) OR
	!isset($_GET['mes']) OR
	!isset($_GET['dia']) OR
	!isset($_GET['opcion']))
	echo "<center><H3>Faltan parámetros. <A HREF='calendario.php'>Volver</A></H3></center>";

// Tenemos todos los parámetros y es propietario
else{
	// Cogemos los vectores de peliculas, horas y minutos
	$sesiones  = $_GET["sesion"];
	$peliculas = $_GET["pelicula"];
	$horas     = $_GET['horas'];
	$minutos   = $_GET['minutos'];
	$id_cine   = $_GET['idcine'];
	$id_sala   = $_GET['idsala'];
	$ano	   = $_GET['ano'];
	$mes	   = $_GET['mes'];
	$dia	   = $_GET['dia'];

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
		// Si existen los datos de esa proyeccion, puede haber cambio
		if ($peliculas[$i] != "" AND $horas[$i] != "" AND $minutos[$i] != "" AND $sesiones[$i] != "")
		{
		// Suponemos en principio que no hay cambios en nada
		$cambio = "no";

		// Cojo los datos de la película que me han pasado para mostrarlos
		$sentencia = 'SELECT * from '.$dbname.'.'.$dbpref.'peliculas WHERE id = '.$peliculas[$i];
		$lanzada   = mysql_query ($sentencia);
		if (mysql_num_rows($lanzada) != 0)
			$datospeli = mysql_fetch_row ($lanzada);

		// Cojo los datosde la sesion/proyeccion
		$sentencia = 'SELECT * FROM '.$dbname.'.'.$dbpref.'proyecciones WHERE id = '.$sesiones[$i];
		$lanzada   = mysql_query ($sentencia);
		if (mysql_num_rows($lanzada) != 0)
			$datossesion = mysql_fetch_row ($lanzada);

		// Si la id de la pelicula (datospeli[0]) es distinta de la id_pelicula de
		// proyecciones (datossesion[2]), entonces es que ha habido un cambio
		// en la película, teniendo que mirar también el horario
		if (($datospeli[0] != $datossesion[2]) OR ($horas[$i].":".$minutos[$i]) != $datossesion[3])
			{
			$cambio="si";
			// HACEMOS EL INSERT DEL HISTORICO
			$sentencia1 = "INSERT INTO historico_proyecciones SELECT * FROM proyecciones WHERE id = $datossesion[0]";
			$lanzada   = mysql_query ($sentencia1);

			// Y EL UPDATE EN LA TALBA PROYECCIONES
			$sentencia2 = "UPDATE proyecciones SET id_pelicula=$datospeli[0], hora_inicio= '$horas[$i]:$minutos[$i]',fecha=curdate() WHERE id = $datossesion[0]";
			$lanzada   = mysql_query ($sentencia2);
			}



		echo "<TR>";
		echo "<TD align='center'>$datospeli[1]</TD>";
		echo "<TD align='center'>$horas[$i] : $minutos[$i]</TD>";
		echo "<TD align='center'>";
		if ($cambio == "si")
			echo "$sentencia1--$sentencia2";
		else
			echo "Sin cambios";
		echo "</TD>";
		echo "</TR>";

		}// Fin de que se le pasen valores en ese vector


		// Si no existe sesion, pero existen el resto de opciones, peli nueva
		if ($peliculas[$i] != "" AND $horas[$i] != "" AND $minutos[$i] != "" AND $sesiones[$i] == "")
		{

		// Cojo los datos de la película que me han pasado para mostrarlos
		$sentencia = 'SELECT * from '.$dbname.'.'.$dbpref.'peliculas WHERE id = '.$peliculas[$i];
		$lanzada   = mysql_query ($sentencia);
		if (mysql_num_rows($lanzada) != 0)
			$datospeli = mysql_fetch_row ($lanzada);	
		
		for ($i=0;$i<=7;$i++)
			{
			$nueva = "INSERT INTO proyecciones (id_sala,id_pelicula,hora_inicio,fecha_inicio,fecha_fin,fecha_proyeccion) VALUES ($datossala[0],$datospeli[0],'$horas[$i]:$minutos[$i]',curdate(),curdate()+7,curdate()+$i)";	
			$lanzada   = mysql_query ($nueva);
			}

		echo "<TR>";
		echo "<TD align='center'>$datospeli[1]</TD>";
		echo "<TD align='center'>$horas[$i] : $minutos[$i]</TD>";
		if ($lanzada == 1)
			echo "<TD align='center'>Nueva Película</TD>";
		else
			echo "<TD align='center'>Error En Nueva</TD>";
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

}// Rango de propietario

else
	echo "Careces de permisos";

pie();
?>