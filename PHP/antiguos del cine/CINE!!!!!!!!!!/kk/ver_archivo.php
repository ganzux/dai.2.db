<? 
	
	if(isset($_GET['id'])) 
	{ 
    
		include 'library/config.php'; 
	    include 'library/opendb.php'; 
    	$id      = $_GET['id']; 
    	$query  = "SELECT imagen,size,tipo,content FROM peliculas WHERE id = '$id'"; 

    	$result = mysql_query($query) or die('Error, query failed'); 
		
    	list($name, $type, $size, $content) = mysql_fetch_array($result); 

    	header("Content-Disposition: attachment; filename=$name"); 
    	header("Content-length: $size"); 
    	header("Content-type: $type"); 
    	echo $content; 

    	include 'library/closedb.php';     
    	exit; 
	} 

?> 

