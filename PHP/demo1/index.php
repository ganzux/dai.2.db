<?
$link = mysql_connect('localhost', 'root', '');
if (!$link) {
   die('Could not connect: ' . mysql_error());
}
echo 'Connected successfully';
$result = mysql_query('SELECT * from encuesta.datos_encuesta ');
if (!$result) {
   die('Invalid query: ' . mysql_error());
}
$row = mysql_fetch_row($result);

echo $row[0];
echo $row[1];
mysql_close($link);
?> 