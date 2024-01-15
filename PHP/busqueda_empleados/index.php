<?php
include 'cabecera.php';
include 'library/config.php';
include 'library/opendb.php';
$campo = $_GET['buscar_por'];
$busco = $_GET['loquebusco'];
?>
<body></body>
<H1>Búsqueda de empleados</H1>
<hr>
	<form action="index.php" method="get" >
	<b>Selecciona el campo de búsqueda</b>
		<select name="buscar_por">
			<option value=ename>Nombre</option>
			<option value=job <?php
			if ($campo=='job')
			{
			?>selected<?php } ?>>Job</option>
		</select>
	<b>Introduce el texto de busqueda</b>
		<input type="text" name="loquebusco" size="20" maxlength="30" value="<?php echo $busco?>">
	<input type="submit" value="Buscar">
	</form>
	<hr>
	<?php if ($busco!='') {?>
		<h2>Empleados encontrados</h2>
		<?php 
		$result = mysql_query('SELECT * FROM empleados.emp, empleados.dept WHERE empleados.emp.deptno = empleados.dept.deptno AND empleados.emp.'.$campo.' LIKE "%'.$busco.'%"');
		
		if (!$result) {
   			die('Invalid query: ' . mysql_error());
				}
				
		echo "<table width=50% border=2 align=center>" .
				"<tr><th align=left width=25%>Numero</th>".
				"<th align=left width=50%>Nombre</th>".
				"<th align=left width=25%>Yob</th>".
			"</tr>";
			
	$filas = mysql_num_rows($result);
		
	for ($i=0;$i<$filas;$i++){
		
	$row = mysql_fetch_row($result);
	echo '<tr><TD>'.$row[0].'</td>';
	echo '<TD>'.$row[1].'</td>';
	echo '<TD>'.$row[2].'</td></tr>';
	}
		echo "</tr></table>";
		
		}
	else { ?>
		<h2>Ha de introducir un criterio de búsqueda</h2>
	<?php }?>
</body>
<?php include 'library/closedb.php'?>
</html>