<?php

include "cabeceraypie.php";
if ($_SESSION["rango"] == 1){
	
	cabecera('','');
	tabla("Creación de nueva Película");
	
	// Si el botón Crear ha sido pulsado
	if(isset($_POST['upload'])) 
	{
		
		// Campos de la imagen
        $fileName = $_FILES['userfile']['name']; 
        $tmpName  = $_FILES['userfile']['tmp_name']; 
        $fileSize = $_FILES['userfile']['size']; 
        $fileType = $_FILES['userfile']['type']; 
        
        // El resto de campos
        if(isset($_POST['activa']))
        	$activa=1;
        else
        	$activa=0;

        if(isset($_POST['nombre']))
        	$nombre=$_POST['nombre'];
        if(isset($_POST['genero']))
        	$genero=$_POST['genero'];
        if(isset($_POST['descripcion']))
        	$descripcion=$_POST['descripcion'];
        if(isset($_POST['duracion']))
        	$duracion=$_POST['duracion'];
        if ($duracion == '')
        	$duracion = 0;
	
		// Si el nombre del archivo NO está vacío
		if(!empty($fileName))
		{

        	$fp = fopen($tmpName, 'r'); 
        	$content = fread($fp, $fileSize); 
        	$content = addslashes($content); 
        	fclose($fp); 
         
        	if(!get_magic_quotes_gpc()) 
        	{
            $fileName = addslashes($fileName); 
        	}
        $peliculas='peliculas';
		$query = "INSERT INTO $dbname.$dbpref$peliculas (titulo,imagen,size,tipo,content,descripcion,genero,duracion,activa) VALUES ('$nombre','$fileName',$fileSize,'$fileType','$content','$descripcion','$genero',$duracion,$activa)";
		}
		
		else
		{
		$peliculas='peliculas';
		$query = "INSERT INTO $dbname.$dbpref$peliculas (titulo,descripcion,genero,duracion,activa) VALUES ('$nombre','$descripcion','$genero',$duracion,$activa)";
		}

        mysql_query($query) or die('Error, query failed');                     
        
        if(!empty($fileName))
		{
        echo "La película $nombre con el fichero adjunto $fileName ha sido guardada satisfactoriamente"; 
		}
		
		else
		{
		echo $query;
		 echo "La película $nombre ha sido guardada satisfactoriamente"; 
		}
	
	
	}// Existe el GET de upload



}// Fin del rango de usuario administrador
?>

