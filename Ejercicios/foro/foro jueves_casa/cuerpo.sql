/*
FALTA:
- Ver el contenido del texto y restringir caracteres
- Crear un password aleatorio
- Mirar los JavaScript para que sean mails correctos
*/

--           @'C:\Documents and Settings\AlVaRiTo\Escritorio\foro jueves_casa\cuerpo.sql'

CREATE OR REPLACE PACKAGE foro AS

-- Un tipo INDEX BY
TYPE coll_id_t IS TABLE OF VARCHAR2(5)
 INDEX BY BINARY_INTEGER;
-- sin_respuesta lo inicializamos para que yano tenga NULL y pueda ir sin valor
sin_respuesta coll_id_t;

PROCEDURE nuevo_tema;
PROCEDURE alta (nombre VARCHAR2, login VARCHAR2, pass VARCHAR2, mail VARCHAR2);
PROCEDURE login (chorro VARCHAR2 DEFAULT NULL, autologin VARCHAR2 DEFAULT NULL);
PROCEDURE salir;
PROCEDURE registro;
PROCEDURE principal;
PROCEDURE muestra_temas;
PROCEDURE perfil;
PROCEDURE muestra_tema (id_tema_pasada NUMBER DEFAULT NULL);
PROCEDURE crear_nuevo_tema (asunto VARCHAR2 DEFAULT NULL, usuario VARCHAR2 DEFAULT NULL);
PROCEDURE nuevo_mensaje(id_tema_pasada NUMBER DEFAULT NULL);
PROCEDURE publicar (asunto VARCHAR2 DEFAULT NULL,texto VARCHAR2 DEFAULT NULL, archivo VARCHAR2 DEFAULT NULL, tema NUMBER DEFAULT NULL);
PROCEDURE muestra_perfil (id_usua VARCHAR2 DEFAULT NULL);
PROCEDURE ver_mensajes (id_pasada VARCHAR2 DEFAULT NULL);
PROCEDURE faq;
PROCEDURE buscar;
PROCEDURE editar(nom VARCHAR2 DEFAULT NULL, pas VARCHAR2 DEFAULT NULL, mai VARCHAR2 DEFAULT NULL);
PROCEDURE adjunta;
PROCEDURE lista_usuarios;
PROCEDURE recuerda;
PROCEDURE enviar(username VARCHAR2 DEFAULT NULL, mail VARCHAR2 DEFAULT NULL, operacion VARCHAR2 DEFAULT NULL, asunto VARCHAR2 DEFAULT NULL, texto VARCHAR2 DEFAULT NULL);
PROCEDURE enviar_mail (direccion VARCHAR2 DEFAULT NULL);
PROCEDURE envio_mail (sender IN VARCHAR2,recipient IN VARCHAR2,subject IN VARCHAR2,message IN VARCHAR2);
PROCEDURE borrar_mensajes (coll_resp foro.coll_id_t DEFAULT foro.sin_respuesta);
PROCEDURE resultados_busqueda (clave VARCHAR2 DEFAULT NULL, autor VARCHAR2 DEFAULT NULL);
PROCEDURE dar_poderes (usuario VARCHAR2 DEFAULT NULL);


END foro;
/
show errors;




CREATE OR REPLACE PACKAGE BODY foro AS


-- Procedimiento que recupera la cookie del sistema; si existe el Usuario, deolverá su nombre,
-- en caso contrario, devolverá NULL
FUNCTION busca_usuario RETURN VARCHAR2 IS
	-- Una cookie auxiliar
	galleta OWA_COOKIE.cookie;
	-- Para guardar el Nombre de usuario
	nombre VARCHAR2(35):=NULL;
	-- Una variable Auxiliar numérica
	numero NUMBER(5):=0;
BEGIN

	-- Lo primero es meter en la Cookie auxiliar la cookie real del foro:
	galleta := OWA_COOKIE.get('foro');

	-- Si Existe La Cookie
	IF (galleta.num_vals > 0) THEN
		-- Miras a ver si existe la contraseña
		SELECT COUNT(*) INTO numero FROM foro_usuarios WHERE UPPER(foro_usuarios.password) = UPPER(galleta.vals(1));
		-- Si existe la contraseña
		IF numero != 0 THEN
			-- Me recuperas el nombre
			SELECT foro_usuarios.nick INTO nombre FROM foro_usuarios WHERE UPPER(foro_usuarios.password) = UPPER(galleta.vals(1));
		END IF; -- Existe el usuario
	END IF;  -- Existe la Cookie

  RETURN nombre;
end busca_usuario;




-- Procedimiento que genera un pie de Página
PROCEDURE pie IS
BEGIN

	HTP.P('<!-- Barra Horizontal separadora -->
<hr align="center" width="75%">
<!-- Pie de Página de todas las webs -->
<CENTER><div class="copyright">Powered by PL/SQL © 2007 iTo Group</div></CENTER>
<!-- Fin de la Web, cerrando el Body y el Html -->
</BODY></HTML>');

END pie;




-- Cabecera de las páginas
PROCEDURE cabecera (titulo VARCHAR2 DEFAULT NULL,formulario VARCHAR2 DEFAULT NULL) IS
nomb VARCHAR2(35);
BEGIN
nomb := busca_usuario;
-- Cabecera de todas las webs
htp.p('<!-- Inicio de la página Web -->
<HTML>

	<!-- Cabecera -->
	<HEAD>

		<!-- Título, concatenado con un subtítulo -->
		<TITLE>Foro de Mensajes -- '||titulo||'</TITLE>

		<!-- Añadimos la hoja de estilos correspondiente -->
		<LINK href="../alumnos/Alvaro/css/hoja.css" rel="stylesheet" type="text/css">

	</HEAD>

	<!-- Al cargar la web, llevamos el foco a formulario.asunto -->');
	-- Si la variable formulario es nula, que ponga la de siempre
	IF formulario IS NULL THEN
		HTP.P('<BODY onload="document.formulario.asunto.focus()">');
	-- Sin embargo, si la variable NO es nula, que concatene
	ELSE
		HTP.P('<BODY onload="document.'||formulario||'.focus()">');
	END IF;
-- Tabla de Inicio de Sesión
HTP.P('	<!-- Cabecera de la WeB -->

	<!-- Imagen en cabecera -->
	<div align="center"><img src="../alumnos/Alvaro/jpg/webito.gif" width="150" height="75"></div>

	<!-- Tabla de opciones de Usuario -->
	<table width="75%"  border="0" align="center" cellspacing="5">
	<tr>
		<!-- F.A.Q. -->
		<td><div align="center" class="mainmenu"><A HREF="foro.faq"><img src="../alumnos/Alvaro/jpg/faq.gif" border=0>F.A.Q.</A></div></td>
		<!-- Des / Conectarse -->
		<td><div align="center" class="mainmenu">');
    IF nomb IS NOT NULL THEN
      HTP.P('<A HREF="foro.salir"><img src="../alumnos/Alvaro/jpg/desc.gif" border=0> Desconectarse ['||nomb||']</A></div>');
    ELSE
      HTP.P('<A HREF="foro.login"><img src="../alumnos/Alvaro/jpg/registrese.gif" border=0> Inicio de Sesión</A></div>');
    END IF;

    HTP.P('</div></td>

		<!-- Perfil de Usuario -->
		<td><div align="center" class="mainmenu"><A HREF="foro.perfil"><img src="../alumnos/Alvaro/jpg/perfil.gif" border=0> Perfil</A></td>
		<!-- Lista de temas -->
		<td><div align="center" class="mainmenu"><A HREF="foro.muestra_temas"><img src="../alumnos/Alvaro/jpg/temas.gif" border=0> Lista de Temas</A></div></td>
		<!-- Nuevo Tema -->
		<td><div align="center" class="mainmenu"><A HREF="foro.nuevo_tema"><img src="../alumnos/Alvaro/jpg/nuevotema.gif" border=0> Nuevo Tema</A></div></td>
		<!-- Lista de usuarios -->
		<td><div align="center" class="mainmenu"><A HREF="foro.lista_usuarios"><img src="../alumnos/Alvaro/jpg/lista.gif" border=0>Lista de Usuarios</A></div></td></td>
		<!-- Buscar -->
		<td><div align="center" class="mainmenu"><A HREF="foro.buscar"><img src="../alumnos/Alvaro/jpg/buscar.gif" border=0>Buscar</A></div></td>
  </tr>
	<!-- Fin de la tabla de usuario -->
	</table>

	<!-- Marquesina de Anuncios -->
	<table width="80%" cellpadding="3" cellspacing="1" border="0" class="forumline" align="center">
  	<tr>
		<!-- Podríamos hacerlo en otro Procedimiento, pero de momento sólo lo utilizo aquí -->
		<td class="catHead" height="28"><div class="finews"><marquee behavior="scroll" direction="left" onMouseOver="this.stop()" onMouseOut="this.start()"><b>[30-01-2007]</b> Sigo mejorando mi foro de <b><font color=green> PL / SQL </font></b> . * - * - * - *  Invita a tu mejor amigo para que participe en los foros.</marquee></div></td>
	</tr>
	</table>
	<!-- Barra horiontal -->
	<hr align="center" width="75%">');
END cabecera;




PROCEDURE adjunta IS
BEGIN
HTP.P('<HTML><HEAD><TITLE>Subir arcgivo</TITLE></HEAD>
<BODY>
<!-- Añadimos la hoja de estilos correspondiente -->
<LINK href="../alumnos/Alvaro/css/hoja.css" rel="stylesheet" type="text/css">
<H3>Seleccione el archivo</H3>
<FORM action="document_api.upload" method=post
encType=multipart/form-data>Fichero a Subir <INPUT type=file name=file><BR><p><INPUT type=submit value=Adjuntar> </FORM>
<H4>Para subir el archivo, utilice el botón <u>Examinar</u> y posteriormente <u>Adjuntar</u>.</H4>
<H4>No cierre esta ventana, se cerrará sola al subir el archivo. Gracias.</H4>

</BODY></HTML>');
pie;
END;




PROCEDURE muestra_tema (id_tema_pasada NUMBER DEFAULT NULL) IS
usu VARCHAR2(35);
tip NUMBER(2);
nom VARCHAR2(35);
tem VARCHAR2(55);
num NUMBER(5);
arc VARCHAR2(256);
BEGIN

	-- Vamos a buscar el usuario y ver su Rango ( el rango 3 puede borrar mensajes )
	usu := busca_usuario;
	IF usu IS NOT NULL THEN
		SELECT tipo_usuario INTO tip FROM foro_usuarios WHERE usu = nick;
	END IF;

  -- Si existe el tema
  IF id_tema_pasada IS NOT NULL THEN
	SELECT nombre_tema INTO tem FROM foro_temas WHERE foro_temas.id = id_tema_pasada;
    cabecera('Vista del Tema');

    HTP.P('<p><H2><center>Tema: " '||tem||' "</center></H2></p>
	<!-- Tabla con todos los mensajes del tema -->
	<table width="90%"  border="0" cellspacing="5" align="center">
    <tr>
		<th class="thCornerL" width="15%" nowrap="nowrap">Asunto</TH>
		<th class="thTop" nowrap="nowrap" width="45%">Mensaje</TH>
		<th class="thTop" nowrap="nowrap" width="5%">Adj.</TH>
		<th class="thTop" nowrap="nowrap" width="15%">Autor</TH>
		<th class="thCornerR" nowrap="nowrap" width="15%">Fecha</TH>');
		
		-- Si es un moderador, activamos el "PODER" de borrar
		IF tip = 3 THEN
			HTP.P('<form name="formulario" method="GET" action="foro.borrar_mensajes">');
			HTP.P('<th><input type="submit" value="Borrar"></TH>');
		END IF;
		
		
    HTP.P('</tr>');
    FOR REG IN (SELECT * FROM foro_mensajes WHERE id_tema = id_tema_pasada ORDER BY id DESC)
    LOOP
      -- Metemos en el nom el nick del usuario
      SELECT nick INTO nom FROM foro_usuarios WHERE id = REG.id_usuario;
      HTP.P('<TR bgcolor="CCCCCC">');
      HTP.P('<TD><center>'||REG.asunto||'</TD>');
      HTP.P('<TD><center>'||REG.contenido||'</TD>');
	  HTP.P('<TD><center>');
	  -- Si existe algún archivo adjunto, que muestre el Link
	  IF REG.archivo IS NOT NULL THEN
		HTP.P('<div align="center"><A HREF="docs/'||REG.archivo||'"><img src="../alumnos/Alvaro/jpg/download.gif" alt="Bajar Archivo '||REG.archivo||'" border=0></A></div>');
	  ELSE
		HTP.P('');
	  END IF;
	  HTP.P('</TD>');
      HTP.P('<TD><center><A HREF="foro.muestra_perfil?id_usua='||nom||'">'||nom||'</A></TD>');
      HTP.P('<TD><center>'||REG.fecha||'</TD>');
	  
	  -- Si es un moderador, activamos el "PODER" de borrar
	  IF tip = 3 THEN
		HTP.P('<td><INPUT TYPE=checkbox name=coll_resp value='||REG.id||'></Td>');
	  END IF;
	  
      HTP.P('</TR>');
    END LOOP;
    HTP.P('</FORM></TABLE><hr align="center" width="75%">
	<table width="75%"  border="0" align="center" cellspacing="0">
	  <tr bgcolor="lightblue">
	    <td width="30%"><div align="right">');

		-- Si existe un tema anterior, mostramos el link a anterior
		SELECT COUNT(*) INTO num FROM foro_temas WHERE TO_NUMBER(id_tema_pasada) = id+1;
		IF num = 1 THEN
			num := TO_NUMBER(id_tema_pasada)-1;
			HTP.P('<A HREF="foro.muestra_tema?id_tema_pasada='||num||'"><-- Anterior</A>');
		END IF;

		HTP.P('</div></td>
	    <td width="5%"></td>
	    <td width="30%"><div align="center">');

	  -- Si el usuario está logueado, que muestre para publicar un nuevo mensaje
      IF busca_usuario IS NOT NULL THEN
            HTP.P('<A HREF="foro.nuevo_mensaje?id_tema_pasada='||id_tema_pasada||'">Nuevo Mensaje</A>');
      END IF;
      HTP.P('</div></td>
	    <td width="5%"></td>
	    <td width="30%">');

		-- Si existe un tema siguiente, mostramos el link a siguiente
		SELECT COUNT(*) INTO num FROM foro_temas WHERE TO_NUMBER(id_tema_pasada) = id-1;
		IF num = 1 THEN
			num := TO_NUMBER(id_tema_pasada)+1;
			HTP.P('<A HREF="foro.muestra_tema?id_tema_pasada='||num||'">Siguiente --></A>');
		END IF;

		HTP.P('</td>
	  </tr>
	</table>');
    pie;
  ELSE
    cabecera('Error');
    HTP.P('<h2>Error, no se ha especificado el tema</h2>');
    pie;
  END IF;
END muestra_tema;




PROCEDURE nuevo_mensaje(id_tema_pasada NUMBER DEFAULT NULL) IS
BEGIN
  -- Si existe el tema a responder
  IF id_tema_pasada IS NOT NULL THEN
    cabecera('Nuevo Mensaje','nuevo_mensaje.asunto');
    HTP.P('<center><H2>Escribir Nuevo Mensaje</H2></center>
	<center><form name="nuevo_mensaje" method="GET" action="foro.publicar" onSubmit="return CompruebaMensaje()" encType=multipart/form-data>
    <p>Asunto <input name="asunto" type="text" size="50" maxlength="50"></p>
    <p>Mensaje <textarea name="texto" cols="90" rows="6"></textarea></p>
    <p><a href="javascript:Adjunta(''foro.adjunta'')">Adjuntar Archivo</a>
          <input name="archivoculto" size="35" disabled>
          <input name="archivo" type="hidden">
    <p><input name="tema" type="hidden" value="'||id_tema_pasada||'">
    <p><input type="submit" value="Enviar Mensaje">
    <input type="reset" value="Borrar"></p>
    </form></center>

	<script language="JavaScript" type="text/javascript">

	function Adjunta (URL)
	{
		archivo = window.open(URL,"ventanarchivo","width=300,height=300,scrollbars=NO,resizable=NO,toolbar=NO,location=0,statusbar=0,status=0,menubar=0,left = 200,top = 200")
	}

    function CompruebaMensaje()
    {
	if (document.nuevo_mensaje.texto.value == "")
		{
		alert("No ha escrito ningún mensaje")
		document.nuevo_mensaje.texto.focus()
		return false
		}

	else
		{
		return true
		}
    }
</script>');

    pie;
  END IF;
END nuevo_mensaje;




PROCEDURE publicar (asunto VARCHAR2 DEFAULT NULL,texto VARCHAR2 DEFAULT NULL, archivo VARCHAR2 DEFAULT NULL, tema NUMBER DEFAULT NULL) IS
id_usuario_captada NUMBER(5);
nom VARCHAR2(35);
BEGIN

  -- Si tiene todos los campos requeridos (texto y tema)
  IF texto IS NOT NULL AND tema IS NOT NULL THEN

	cabecera('Publicar Mensaje');
    -- Cogemos el nombre del usuario de la cookie
    nom := busca_usuario;
    -- Buscamos la id de ese usuario
    SELECT id INTO id_usuario_captada FROM foro_usuarios WHERE nick = nom;
    -- Publicamos el mensaje: Si el asunto es nulo, lo ponemos
	IF asunto IS NULL THEN
		INSERT INTO foro_mensajes VALUES (seq_foro_men.NEXTVAL,SYSDATE,'(Sin Asunto)',texto,id_usuario_captada,tema,archivo);
	-- Si no es nulo, lo publicamos con el asunto
	ELSE
		INSERT INTO foro_mensajes VALUES (seq_foro_men.NEXTVAL,SYSDATE,asunto,texto,id_usuario_captada,tema,archivo);
	END IF;


    -- El HTML
    HTP.P('<center><H3>Mensaje publicado con éxito</H3></center>
	<center>Pulse <A HREF="foro.muestra_tema?id_tema_pasada='||tema||'">AQUÍ</A> para volver al mensaje.</center>');

  -- Algún campo es nulo
  ELSE
    cabecera('Error');


    IF texto IS NULL THEN
      HTP.P('<center><H3>El texto es requerido para poder publicar</H3></center>');
    END IF;

    IF tema IS NULL THEN
      HTP.P('<center><H3>El tema es requerido para poder publicar</H3></center>');
    END IF;
    HTP.P('<center><H3>Pulse <A HREF="foro.muestra_temas">AQUÍ</A> para volver</H3></center>');
  END IF;

    pie;
EXCEPTION WHEN OTHERS THEN HTP.P('<center>¡ ERROR !</center>');
END publicar;




-- Procedimiento que permite al usuario desconectarse del sistema
PROCEDURE salir IS
	-- Una cookie auxiliar
	galleta OWA_COOKIE.cookie;
BEGIN
	-- Lo primero es meter en la Cookie auxiliar la cookie real del foro:
	galleta := OWA_COOKIE.get('foro');

  -- Si existe algo en la Cookie, que la borre
  IF (galleta.num_vals > 0) THEN
    -- Ahora la borramos
    OWA_UTIL.mime_header('text/html', FALSE);
    OWA_COOKIE.remove ('foro',galleta.vals(1));
    OWA_UTIL.http_header_close;
    cabecera('Desconexión inminente');
    HTP.P('<H2><center>Te has desconectado con éxito</center></H2>
	<br>
	<A HREF="foro.principal"><center>VOLVER AL INICIO</center></A>');
  pie;
  -- Sin embargo, si no existe nada, error
  ELSE
    cabecera('Error');
    HTP.P('<H3>No está conectado al sistema</H3>
	<b>Pulse <A HREF="foro.login">AQUÍ</A> para Iniciar Su sesión</b>');
    pie;
  END IF;
END salir;




PROCEDURE muestra_temas IS
num_mens NUMBER(6);
BEGIN
	cabecera('Lista de Temas');
	HTP.P('<H2><center>Lista de Temas</center></H2><table width="90%"  border="0" cellspacing="3" align="center">
	<tr>
    <th class="thCornerL" width="50%" nowrap="nowrap">Título del Tema</th>
    <th class="thTop" nowrap="nowrap" width="20%">Autor</th>
    <th class="thTop" nowrap="nowrap">Mensajes</th>
    <th class="thCornerR" nowrap="nowrap" width="15%">Último Mensaje</th>
  </tr>');
	FOR REG IN (SELECT * FROM vista_temas ORDER BY id DESC)
    LOOP
		-- Metemos el número de mensajes del tema en una variable
		SELECT COUNT(*) INTO num_mens FROM foro_mensajes
		WHERE foro_mensajes.id_tema = REG.id;

		HTP.P('<TR bgcolor="#CCCCCC">');
		HTP.P('<TD><center><A class="topictitle" HREF="foro.muestra_tema?id_tema_pasada='||REG.id||'">'||REG.nombre_tema||'</A></TD>');
		HTP.P('<TD><center><A HREF="foro.muestra_perfil?id_usua='||REG.nick||'">'||REG.nick||'</A></TD>');
		HTP.P('<TD><center>'||num_mens||'</TD>');
		HTP.P('<TD><center>'||reg.fecha||'</TD>');
		HTP.P('</TR>');
    END LOOP;
	HTP.P('</TABLE>');
	pie;
END muestra_temas;




PROCEDURE alta (nombre VARCHAR2, login VARCHAR2, pass VARCHAR2, mail VARCHAR2) IS
-- Variable numérica
contador_logi NUMBER(5):=0;
contador_mail NUMBER(5):=0;
BEGIN
-- Miramos si existe ese login
SELECT COUNT(*) INTO contador_logi FROM foro_usuarios WHERE foro_usuarios.nick = ''||login||'';
-- Miramos si existe el mail
SELECT COUNT(*) INTO contador_mail FROM foro_usuarios WHERE foro_usuarios.email = ''||mail||'';

-- Si no existe lo damos de alta
IF contador_logi = 0 AND contador_mail = 0 THEN
	INSERT INTO foro_usuarios VALUES (seq_foro_usu.NEXTVAL,nombre,login,pass,mail,0,SYSDATE);
	COMMIT;
  cabecera('Usuario Creado');
	HTP.P('<H3>Su usuario ha sido dado de alta</H3>
	<b>Pulse <A HREF="foro.login">AQUÍ</A> para Iniciar Su sesión</b>');
  pie;
-- Sin embargo, si existe, Error
ELSE
  cabecera('Error');
	IF contador_logi != 0 THEN
		HTP.P('<p>Error, ese <b>LOGIN</b> Ya existe.');
	END IF;
	IF contador_mail != 0 THEN
		HTP.P('<p>Error, ese <b>MAIL</b> Ya Existe.');
	END IF;
  pie;
END IF;
EXCEPTION WHEN OTHERS THEN
  cabecera('Error Inesperado');
  HTP.P('Error el la aplicación');
  pie;
END alta;




PROCEDURE registro IS
BEGIN
cabecera('Registro de usuario','datos.nombre');
-- Subimos el Formulario
HTP.P('<script src="../alumnos/Alvaro/js/md5.js" type="text/javascript"></script>
<form name="datos">
  <center><table width="75%"  border="0" align="center" cellspacing="5" bordercolor="#FFFFFF">
    <tr>
      <th width="45%"><b>Registro de Nuevo Usuario</b></th>
      <td width="5%"></td>
	  <td width="45%"></td>
    </tr>
    <tr>
      <td><div align="right"><b>Nombre</b></div></td>
      <td></td>
      <td><input type="text" name="nombre"></td>
    </tr>
    <tr>
      <td><div align="right"><b>Login *</b></div></td>
      <td></td>
	  <td><input type="text" name="login"></td>
    </tr>
    <tr>
      <td><div align="right"><b>Password *</b></div></td>
      <td></td>
	  <td><input type="password" name="pass">
	  </td>
    </tr>
    <tr>
      <td><div align="right"><b>Repita el Password *</b></div></th>
      <td></td>
	  <td><input type="password" name="pas2">
	  </td>
    </tr>

    <tr>
      <td><div align="right"><b>e-mail *</b></div></th>
      <td></td>
	  <td><input type="text" name="mail"></td>
    </tr>
</form>

<form name="enviar" method="POST" action="foro.alta" onsubmit="return CompruebaTodo()">
	    <tr>
          <td><input name=nombre type=hidden>
              <input name=login type=hidden>
              <input name=pass type=hidden>
              <input name=mail type=hidden></th>
          <td><center><input type="submit" value="Alta"></center></td>
		  <td></td>
    </tr>
  </table>
</form>

<script language="JavaScript" type="text/javascript">
    function RellenaValores()
    {
	document.enviar.nombre.value=document.datos.nombre.value
	document.enviar.login.value=document.datos.login.value
	document.enviar.mail.value=document.datos.mail.value
	document.enviar.pass.value=hex_md5(document.datos.login.value+document.datos.pass.value)
    }

    function CompruebaTodo()
    {
	// Rellenamos todas las cajas ocultas
	RellenaValores()

	if (document.datos.login.value == "")
		{
		alert("El campo Login es obligatorio")
		document.datos.login.focus()
		return false
		}

	else if (document.datos.pass.value == "")
		{
		alert("El campo PassWord es obligatorio")
		document.datos.pass.focus()
		return false
		}

	else if (document.datos.pas2.value == "")
		{
		alert ("El campo PassWord es obligatorio")
		document.datos.pas2.focus()
		return false
		}

	else if (document.datos.mail.value == "")
		{
		alert("El campo e-mail es obligatorio")
		document.datos.mail.focus()
		return false
		}

	else
		{
		return CompruebaPassword()
		}
    }

	function CompruebaPassword()
	{
	if (document.datos.pass.value == document.datos.pas2.value)
		{
		return true
		}
	else
		{
		alert ("Las contraseñas no coinciden")
		document.datos.pas2.focus()
		return false
		}
	}

</script>
');
pie;
END registro;




PROCEDURE nuevo_tema IS
nombre VARCHAR2(35);
BEGIN
	-- Metemos el nombre del Usuario en la varialbe
	nombre:=busca_usuario;

	cabecera('Nuevo Tema','formulario.asunto');

	IF nombre IS NOT NULL THEN
		HTP.P('<center><form name="formulario" method="GET" action="foro.crear_nuevo_tema" onSubmit="return CompruebaTema()">
<b>Título del Tema</n>    <input name="asunto" type="text" size="50" maxlength="50">
<input type="Submit" value="Crear Nuevo Tema">
<input type=hidden name="usuario" value="'||nombre||'">
</form></center>

	<script language="JavaScript" type="text/javascript">

    function CompruebaTema()
    {

	if (document.formulario.asunto.value == "")
		{
		alert("No ha escrito ningún tema")
		document.formulario.asunto.focus()
		return false
		}

	else
		{
		return true
		}
    }
</script>

');
	ELSE
		HTP.P('<h2><center>Tiene que estar Logueado para poder postear.</center></h2>');
	END IF;

  pie();
END nuevo_tema;




PROCEDURE crear_nuevo_tema (asunto VARCHAR2 DEFAULT NULL, usuario VARCHAR2 DEFAULT NULL) IS
id_usuario NUMBER(5);
BEGIN
  -- Si existen el Usuario Y el Asunto
  IF asunto IS NOT NULL AND usuario IS NOT NULL THEN
    SELECT foro_usuarios.id INTO id_usuario FROM foro_usuarios WHERE usuario = foro_usuarios.nick;
    INSERT INTO foro_temas VALUES (seq_foro_tem.NEXTVAL,id_usuario,asunto);
    cabecera('Tema Creado');
    HTP.P('<h2><center>El TEMA ha sido Creado</center></h2>
	<h4><center><A HREF="foro.muestra_temas">Pulse AQUÍ para ver todos los temas</a></center></h4>');
    pie;
  -- No existen alguno (o ninguno) de los parámetros
  ELSE
    cabecera('Error al crear el tema');
    HTP.P('<H2>Error al crear el tema</H2>
    <h3>Ha de especificar un Título</h3>
    <h4><a HREF="foro.nuevo_tema">Volver</a></h4>');
    pie;
  END IF;
END crear_nuevo_tema;




/* El siguiente Procedimiento efectúa el logueado del Usuario. Lo primero que
hará será verifricar si le estamos pasando una cadena (chorro), que será el
password encriptado; si la cadena no existe, mostrará un formulario estándar para poder
loguearse, llamando a la misma página, que será entonces cuando reciba la cadena.
En ese último caso mirará si existe la Cookie o no en el sistema. Si la Cookie
no existe, procederá a su creación, y si la Cookie Existe, avisará al Usuario
de que ya está logueado.			*/
PROCEDURE login (chorro VARCHAR2 DEFAULT NULL, autologin VARCHAR2 DEFAULT NULL) IS
	-- Una cookie auxiliar
	galleta OWA_COOKIE.cookie;
	-- Para guardar el password y un número
	nombre VARCHAR2(35):='';
	numero NUMBER(5):=0;
BEGIN

-- Lo primero es meter en la Cookie auxiliar la cookie real del foro:
galleta := OWA_COOKIE.get('foro');

-- Si Existe la Cookie:
IF galleta.num_vals!=0 THEN
  cabecera('Inicio de Sesión');
  HTP.P('<center><h2>Ya estás logueado en el Foro </h2></center>');
  HTP.P('<center><h4><a href="foro.salir">Desconectarse</a></h2></center>');
  pie;

  -- No Hay Cookie
  ELSE
  -- No hay Cookie, Si no hay Chorro
  IF chorro IS NULL THEN
    cabecera('Inicio de Sesión','datos.usua');
    HTP.P('<center><h2>Inicio de Sesión</h2></center>
    <script src="../alumnos/Alvaro/js/md5.js" type="text/javascript"></script>');
    HTP.P('<form name="datos"><center>
            <table border="0" cellpadding="2" cellspacing="2" width="50%">
             <tr>
              <td>Nombre de Usuario</td>
              <td><input type="text" name=usua></td>
             </tr>
             <tr>
            <td>Contraseña</td>
            <td><input type="password" name=pass></td>
           </tr>
          </table>
		  </form>');
    -- Ahora metemos el botón, que encriptará en nombre de usuario y el password
    -- y comprobará que existan o no
    HTP.P('<form name="botonenviar" method=GET onsubmit="return CompruebaTodo()">
      <input name=chorro type=hidden>
	  <span class="gen">Conectarme automáticamente en cada visita: <input name="autologin" type="checkbox"></span>
	  <center><input type="submit" value="Entrar">
	  <p><center><span class="gensmall"><A HREF="foro.recuerda" class="gensmall">He olvidado mi contraseña</A></span></center></p></center></form>

      <script language="JavaScript" type="text/javascript">
          function CalculaHash()
          {
          document.botonenviar.chorro.value=hex_md5(document.datos.usua.value+document.datos.pass.value)
		  }

          function CompruebaTodo()
          {
		  CalculaHash()
            if (document.datos.usua.value=="" )
              {
              alert("El campo Login es obligatorio")
			  document.datos.usua.focus()
              return false
              }
            else
              {
			  if (document.datos.pass.value=="" )
				{
				alert("El campo Password es obligatorio")
				document.datos.pass.focus()
				return false
				}
              return true
              }
          }
      </script>
    <H4><A HREF="foro.registro">¿Todavía no te has registrado?</A></H4>
      ');
      pie;

  -- No hay Cookie, No hay Chorro
  ELSE
    -- Busco si existe ese usuario,
    SELECT COUNT(*) INTO numero FROM foro_usuarios WHERE UPPER(foro_usuarios.password) = UPPER(chorro);
      -- Si existe la contraseña
      IF numero != 0 THEN
        -- Me recuperas el nombre
        SELECT foro_usuarios.nick INTO nombre FROM foro_usuarios WHERE UPPER(foro_usuarios.password) = UPPER(chorro);
        -- Y me creas la Cookie

		-- Si está el autologin activado, creas la cookie indefinidamente
		IF (autologin = 'on') THEN

	        OWA_UTIL.mime_header('text/html', FALSE);
	        OWA_COOKIE.send ('foro',TO_CHAR(chorro));
	        OWA_UTIL.http_header_close;

		-- Si está OFF, me la creastemporal
		ELSE

	        OWA_UTIL.mime_header('text/html', FALSE);
	        OWA_COOKIE.send ('foro',TO_CHAR(chorro),SYSDATE);
	        OWA_UTIL.http_header_close;

		END IF;
      -- Me pones la web
      cabecera('Inicio de Sesión');
      HTP.P('<h2><center>Bienvenido de Nuevo al Foro '||nombre||'</center></h2>');
      HTP.P('<h4><center><a href="foro.salir">Desconectarse</a></center></h4>');

      -- Usuario o contraseña no correctas
      ELSIF numero = 0 THEN
        cabecera('Usuario Incorrecto');
		
        HTP.P('<H3><center>Ha introducido un usuario o una contraseña no válidos</center></H3>
		<h4><center>Pulse <A HREF="foro.login">AQUÍ</A> para volver</center></h4>');
      END IF; -- Fin de que exista o no la contraseña
      pie;
  END IF; -- Existe o no el chorro
END IF;  -- Existe o no la Cookie

  EXCEPTION
    WHEN OTHERS THEN
      HTP.P('<p>Error de login: Se ha producido una Excepción '||SQLCODE||SQLERRM);
END login;




PROCEDURE perfil IS
num NUMBER(5);
nom VARCHAR2(35);
ide NUMBER(6);
nic VARCHAR2(25);
ema VARCHAR2(30);
BEGIN
nom := busca_usuario;

	--Si existe el Usuario, ponemos sus datos
	IF nom IS NOT NULL THEN

	-- Miras si exinten los datos
	SELECT COUNT(*) INTO num FROM foro_usuarios WHERE nom = foro_usuarios.nombre;

	-- Si existe el usuario ,me metes los datos de él
	--IF num != 0 THEN
		SELECT id INTO ide FROM foro_usuarios WHERE nom = foro_usuarios.nick;
		SELECT nombre INTO nic FROM foro_usuarios WHERE nom = foro_usuarios.nick;
		SELECT email INTO ema FROM foro_usuarios WHERE nom = foro_usuarios.nick;
	--END IF;

	cabecera('Perfil De Usuario','datos.nombre');
	HTP.P('<center><H2>Perfil de '||nom||'</h2></center>
  <script src="../alumnos/Alvaro/js/md5.js" type="text/javascript"></script>

<form name="datos">
  <center><table width="75%"  border="0" align="center" cellspacing="5" bordercolor="#FFFFFF">
    <tr>
      <th width="45%"><b>Perfil de '||nom||'</b></th>
      <td width="5%"></td>
	  <td width="45%"></td>
    </tr>
    <tr>
      <td><div align="right"><b>Id Usuario</b></div></td>
      <td></td>
      <td><input type="text" name="id" value="'||ide||'" disabled></td>
    </tr>
    <tr>
      <td><div align="right"><b>Nombre</b></div></td>
      <td></td>
      <td><input type="text" name="nombre" value="'||nic||'"></td>
    </tr>
    <tr>
      <td><div align="right"><b>Login</b></div></td>
      <td></td>
	  <td><input type="text" name="login" value="'||nom||'" disabled></td>
    </tr>
    <tr>
      <td><div align="right"><b>Password</b></div></td>
      <td></td>
	  <td><input type="password" name="pass">
	  </td>
    </tr>
    <tr>
      <td><div align="right"><b>Repita el Password</b></div></th>
      <td></td>
	  <td><input type="password" name="pas2">
	  </td>
    </tr>

    <tr>
      <td><div align="right"><b>e-mail</b></div></th>
      <td></td>
	  <td><input type="text" name="mail" value="'||ema||'"></td>
    </tr>
</form>

<form name="enviar" method="GET" action="foro.editar" onsubmit="return CompruebaPassword()">
	    <tr>
			<td><input name=nom type=hidden>
              <input name=pas type=hidden>
              <input name=mai type=hidden>
			</td>
			<td><center><input type="submit" value="Editar"></center></td>
			<td></td>
		</tr>
  </table>
</form>



<script language="JavaScript" type="text/javascript">
    function RellenaValores()
    {
	document.enviar.nom.value=document.datos.nombre.value
	document.enviar.mai.value=document.datos.mail.value
	document.enviar.pas.value=hex_md5(document.datos.login.value+document.datos.pass.value)
    }

	function CompruebaPassword()
	{

	if (document.datos.pass.value == document.datos.pas2.value)
		{
		RellenaValores()
		// Si el password está en blanco, enviamos un password encriptado blanco
		if (document.datos.pass.value=="")
			{
			document.enviar.pas.value=""
			}
		return true
		}
	else
		{
		alert ("Las contraseñas no coinciden")
		document.datos.pas2.focus()
		return false
		}
	}

</script>


  ');
  pie;

	-- Sin embargo, si el Usuario no existe, error
	ELSE
    cabecera('Error , Logueate');
		HTP.P('<center><H2>Error, ha de estar logueado para poder modificar o ver si perfil</H2></center>
	<h4><center>Pulse <A HREF="foro.principal">AQUÍ</A> para volver al menu principal</center></h4>');
  	pie;
	END IF;

END perfil;




-- Principal
PROCEDURE principal IS
BEGIN
cabecera();
HTP.P('<h1><center>FORO para 2º D.A.I. de Álvaro Alcedo Moreno</center></h1>');
pie;
END principal;




PROCEDURE muestra_perfil (id_usua VARCHAR2 DEFAULT NULL) IS
temp VARCHAR2(100);
cont NUMBER(6);
BEGIN
  -- Si existe la id, que muestre el perfil
  IF id_usua IS NOT NULL THEN

    SELECT COUNT(*) INTO cont from vista_usuarios WHERE id_usua = nick;

    -- Si existe el usuario, que lo muestre
    IF cont != 0 THEN
    cabecera('Perfil de Usuario de '||id_usua||'');
          HTP.P('<center><H2>Perfil de '||id_usua||'</H2></center>
		  <table width="50%"  border="0" align="center" cellspacing="3">
        <tr bgcolor="#CCCCCC">
          <th><div align="right" width="50%">Nombre real </div></th>
          <td width="50%">');
          SELECT nombre INTO temp FROM vista_usuarios WHERE id_usua = nick;
          HTP.P(temp||'</td>
        </tr>
        <tr bgcolor="#CCCCCC">
          <th><div align="right">Nick </div></th>
          <td>'||id_usua||'</td>
        </tr>
        <tr bgcolor="#CCCCCC">
          <th><div align="right">e-mail </div></th>
          <td>');
          SELECT email INTO temp FROM vista_usuarios WHERE id_usua = nick;
          HTP.P('<A HREF="foro.enviar_mail?direccion='||temp||'"><img src="../alumnos/Alvaro/jpg/email.gif" border="0"></A></td>
        </tr>
      </table>
       <center><h4><A HREF="foro.ver_mensajes?id_pasada='||id_usua||'">Ver todos los mensajes de '||id_usua||'</A></h4></center>');
    pie;

    -- Existe valor pero no encontramos el usuario
    ELSE
      cabecera('Error');
      HTP.P('<center><h3>Error, el usuario '||id_usua||' no existe.</h3></center>');
      pie;
    END IF; -- Existe el usuario

    -- No existe valor pasado
    ELSE
    cabecera('Error');
    HTP.P('<center><H3>Error, no indicó el usuario</h3></center>');
    pie;

  END IF; -- Existe el valor pasado
END muestra_perfil;




PROCEDURE ver_mensajes (id_pasada VARCHAR2 DEFAULT NULL) IS
nomb_usua VARCHAR2(35);
nomb_busca VARCHAR2(35);
id_tema_pasada NUMBER(6);
tip NUMBER(2);
BEGIN
nomb_usua := busca_usuario;

	IF nomb_usua IS NOT NULL THEN
	
	SELECT tipo_usuario INTO tip FROM foro_usuarios WHERE nomb_usua = nick;
	

		IF id_pasada IS NOT NULL THEN
			SELECT nick INTO nomb_busca FROM foro_usuarios WHERE nick = id_pasada;
			cabecera('Mensajes de '||nomb_busca);
			HTP.P('<H2><center>Lista de mensajes de '||nomb_busca||'</center></H2>');
			HTP.P('<center><table width="90%"  border="0" cellspacing="3">
			<tr>
				<th width="20%">Tema</th>
				<th width="20%">Asunto</th>
				<th width="45%">Mensaje</th>
		    <th width="5%">Adj.</th>
				<th width="10%">Fecha</th>');
			-- Si es un moderador, activamos el "PODER" de borrar
			IF tip = 3 THEN
				HTP.P('<form name="formulario" method="GET" action="foro.borrar_mensajes">');
				HTP.P('<td><input type="submit" value="Borrar"></Td>');
			END IF;
		HTP.P('
			</tr>');

	FOR REG IN (SELECT foro_temas.nombre_tema, foro_mensajes.asunto, foro_mensajes.contenido, foro_mensajes.fecha, foro_mensajes.archivo, foro_mensajes.id
				FROM foro_temas, foro_mensajes, foro_usuarios
				WHERE foro_temas.id = foro_mensajes.id_tema AND foro_mensajes.id_usuario = foro_usuarios.id AND foro_usuarios.nick = id_pasada
				ORDER BY foro_mensajes.id DESC)
    LOOP
		SELECT id INTO id_tema_pasada FROM foro_temas WHERE REG.nombre_tema = nombre_tema;
      HTP.P('
	<tr bgcolor="#CCCCCC">
		<td><A HREF="foro.muestra_tema?id_tema_pasada='||id_tema_pasada||'">'||REG.nombre_tema||'</A></td>
		<td>'||REG.asunto||'</td>
		<td>'||REG.contenido||'</td>');
    
    IF REG.archivo IS NOT NULL THEN
      HTP.P('<td><div align="center"><A HREF="docs/'||REG.archivo||'"><img src="../alumnos/Alvaro/jpg/download.gif" alt="Bajar Archivo '||REG.archivo||'" border=0></A></div></td>');
    ELSE
      HTP.P('<td></td>');
    END IF;
    
		HTP.P('<td>'||REG.fecha||'</td>');
			-- Si es un moderador, activamos el "PODER" de borrar
			IF tip = 3 THEN
				HTP.P('<td><INPUT TYPE=checkbox name=coll_resp value='||REG.id||'></Td>');
			END IF;
			HTP.P('
	</tr>');
    END LOOP;

	HTP.P('</table></center>');
			pie;

		ELSE
			cabecera('Error');
			HTP.P('<center><H2>Error, no ha especificado usuario</H2></center>
	<h4><center>Pulse <A HREF="foro.principal">AQUÍ</A> para volver al menu principal</center></h4>');
			pie;
		END IF;

	ELSE
		cabecera('Error');
		HTP.P('<center><H2>Error, ha de estar logueado para poder buscar</H2></center>
	<h4><center>Pulse <A HREF="foro.principal">AQUÍ</A> para volver al menu principal</center></h4>');
		pie;
	END IF;

END ver_mensajes;


PROCEDURE faq IS
BEGIN
	cabecera('Preguntas y respuestas frecuentes');
	HTP.P('<center><H2>F.A.Q. <--> Preguntas y respuestas frecuentes</H2></center>
	<table class="forumline" width="95%" cellspacing="1" cellpadding="3" border="0" align="center">
	<tr>
		<th class="thHead">F.A.Q.</th>
	</tr>
	<tr>
	</tr>
<tr>
		<td class="row1" align="left" valign="top"><span class="postbody"><b>¿En qué lenguaje está escrito el foro?</b></span><br />
    <span class="postbody">El foro está completamente escrito en PL/ SQL.</span></td>

  </tr>

  <tr>
		<td class="row1" align="left" valign="top"><span class="postbody"><b>¿Quién es el autor?</b></span><br />
    <span class="postbody">Álvaro Alcedo Moreno, escribiéndolo como uno de los proyectos finales para la asignatura de Oracle, en el módulo superior de Desarrollo de Aplicaciones Informáticas en el Instituto Lázaro Cárdenas de Collado Villalba, en Madrid (España)</span></td>

  </tr>

	</table>
	');
	pie;
END faq;


PROCEDURE editar(nom VARCHAR2 DEFAULT NULL, pas VARCHAR2 DEFAULT NULL, mai VARCHAR2 DEFAULT NULL) IS
nomb_usua VARCHAR2(35);
pass_usua VARCHAR2(35);
mail_usua VARCHAR2(50);
nick_usua VARCHAR2(35);
numero    NUMBER(6);
BEGIN
-- Recuperamos el nick del usuario
nick_usua := busca_usuario;


	--SELECT COUNT(*) INTO numero FROM foro_usuarios WHERE nomb_usua = foro_usuarios.nombre;

	--IF numero != 0 THEN
		SELECT nombre   INTO nomb_usua FROM foro_usuarios WHERE nick_usua = foro_usuarios.nick;
		SELECT password INTO pass_usua FROM foro_usuarios WHERE nick_usua = foro_usuarios.nick;
		SELECT email    INTO mail_usua FROM foro_usuarios WHERE nick_usua = foro_usuarios.nick;
	--END IF;


	cabecera('Edición de Uuario');
	HTP.P('<center><H2>Edición de Usuario</h2></center>');

	-- Editamos el nombre si no es nulo y no coincide con el anterior
	IF nom IS NOT NULL AND nom != nomb_usua THEN
		UPDATE foro_usuarios SET nombre = nom WHERE nick = nick_usua;
		COMMIT;
		HTP.P('<center><H4>El campo <b>nombre</b> ha sido modificado a "<b>'||nom||'"</b></h4></center>');
	END IF;

	SELECT COUNT(*) INTO numero FROM foro_usuarios WHERE mai = email;
	-- Editamos el mail si no es nulo y no coincide con el anterior Y no existe en la BBDD
	IF mai IS NOT NULL AND mai != mail_usua AND numero = 0 THEN
		UPDATE foro_usuarios SET email = mai WHERE nick = nick_usua;
		COMMIT;
		HTP.P('<center><H4>El campo <b>e-mail</b> ha sido modificado a "<b>'||mai||'</b>"</h4></center>');
	ELSIF numero != 0 THEN
		HTP.P('<center><H4>La dirección de e-mail "<b>'||mai||'</b>" ya existe.</h4></center>');
	END IF;

	-- Editamos el pasword si no es nulo y no coincide con el anterior
	IF pas IS NOT NULL AND pas != pass_usua THEN
		UPDATE foro_usuarios SET password = pas WHERE nick = nick_usua;
		COMMIT;
		HTP.P('<center><H4>El campo <b>Password</b> ha sido modificado</b></h4></center>');
		salir;
	END IF;

	IF mai IS NULL AND nom IS NULL and pas IS NULL THEN
		HTP.P('<center><H4>No hay datos a modificar</h4></center>');
	END IF;
	HTP.P('<h4><center>Pulse <A HREF="foro.perfil">AQUÍ</A> para volver a su perfil</center></h4>');
	pie;

END;



PROCEDURE buscar IS
usu VARCHAR2(35);
BEGIN
usu := busca_usuario;
cabecera('Buscar','form.clave');
IF usu IS NOT NULL THEN
HTP.P('<body><center><H2>Buscar</H2>
  <form name="form" method="get" action="foro.resultados_busqueda">
    <table width="50%"  border="0" cellspacing="10">
	
      <tr>
        <th scope="row"><div align="right">Buscar por cadena clave </div></th>
        <td><input type="text" name="clave" size="35" maxlength="35"></td>
      </tr>
	  
      <tr>
        <th scope="row"><div align="right">Buscar por autor </div></th>
        <td><input type="text" name="autor" size="20" maxlength="20"></td>
      </tr>
	  
	  <tr>
        <td scope="row"><div align="right">
          <input type="submit" value="Enviar">
        </div></th>
        <td><input type="reset" name="Submit" value="Borrar"></td>
      </tr>
    </table>
    </form>
  </center>
  
<script language="JavaScript" type="text/javascript">

	function Comprueba()
    {
	if (document.form.clave.value == "" && document.form.autor.value == "")
		{
		alert("Tiene que escribir un campo para poder buscar")
		
		if (document.form.clave.value == "")
			{
			document.form.clave.focus()
			}
		else
			{
			document.form.autor.focus()
			}
		return false
		}
	else
		{
		return true
		}
	}
</script>');
ELSE
HTP.P('<center><H2>Error, ha de estar logueado para poder buscar</H2></center>
	<h4><center>Pulse <A HREF="foro.principal">AQUÍ</A> para volver al menu principal</center></h4>');
END IF;
pie;
END buscar;


PROCEDURE lista_usuarios IS
nik VARCHAR2(35);
tip NUMBER(2);
tipo NUMBER(2);
BEGIN
-- Buscamos el usuario
nik := busca_usuario();
		
cabecera('Lista de Usuarios');
IF nik IS NOT NULL THEN
	-- Cargamos el tipo de usuario en una variable numérica
	SELECT tipo_usuario INTO tip FROM foro_usuarios WHERE nick = nik;
	
	HTP.P('<center><H2>Lista de Usuarios</H2></center>

	<table width="75%"  border="0" align="center" cellspacing="5">
	  <tr>
	    <th scope="col" width="5%">#</th>
	    <th scope="col" width="22%">Nombre</th>
	    <th scope="col" width="22%">Nick</th>
	    <th scope="col" width="10%">Mensajes</th>
	    <th scope="col" width="20%">Fecha registro </th>
		<th scope="col" width="21%">e-mail</th>');
	-- Si el usuario es un moderador, puede crear moderadores
	IF tip = 3 THEN
		HTP.P('<form action="foro.dar_poderes" method="get"><th scope="col"><input type="submit" value="Mod"></th>');
	END IF;
	  HTP.P('</tr>');
	  FOR REG IN (SELECT * FROM vista_usuarios_entera) LOOP
	  
	  -- Miramos de qué tipo es ese usuario, para añadirle una distinción
	  SELECT tipo_usuario INTO tipo FROM foro_usuarios WHERE nick = REG.nick;
	  
	  IF tipo = 3 THEN
		HTP.P('<tr bgcolor="lightblue">');
	  ELSE
		HTP.P('<tr bgcolor="#CCCCCC">');
	  END IF;

	  HTP.P('<td align="center">'||REG.id||'</td>
	    <td>'||REG.nombre||'</td>
	    <td><A HREF="foro.muestra_perfil?id_usua='||REG.nick||'">'||REG.nick||'</A></td>');
		
		IF REG.num_mensajes IS NOT NULL THEN
			HTP.P('<td align="center"><A HREF="foro.ver_mensajes?id_pasada='||REG.nick||'">'||REG.num_mensajes||'</A></td>');
		ELSE
			HTP.P('<td align="center">0</td>');
		END IF;
		
	    HTP.P('<td align="center">'||SYSDATE||'</td>');
		
		-- Campo mail opcional mostrarlo o no
	    IF REG.email IS NOT NULL THEN
	      HTP.P('<td><A HREF="foro.enviar_mail?direccion='||REG.email||'"><div align="center"><img src="../alumnos/Alvaro/jpg/email.gif" border="0"></div></A></td>');
	    ELSE
	      HTP.P('<td></td>');
	    END IF;
		
		-- Si el usuario es un moderador, puede crear moderadores
		IF tip = 3 THEN
			HTP.P('<td><input name="usuario" type="radio" value="'||REG.id||'"></td>');
		END IF;
		
	  HTP.p('</tr>');
	  END LOOP;
	HTP.P('</table><center><H4></h4>Nota: Los usuarios con fondo <font color="lightblue">AZUL</font> son moderadores.</center>');
	
	IF tip = 3 THEN
		HTP.P('</form>');
	END IF;	
	
	
	-- No está logueado
	ELSE
	HTP.P('<h2><center>Tiene que estar logueado para ver la lista de usuarios</center></h2>
	<h4><center>Pulse <A HREF="foro.principal">AQUÍ</A> para volver al menu principal</center></h4>');
	
	END IF;

pie;
END lista_usuarios;


PROCEDURE recuerda IS
BEGIN
	cabecera('Recordatorio de Clave','olvidado.username');
	HTP.P('<h2><center>Envíenme una nueva contraseña</center></h2>
<table width="60%" align="center" cellspacing="5">
  <tbody>

	<tr>
	  <td colspan="2"><span class="gensmall">Los campos marcados con * son obligatorios a menos que se especifique lo contrario.</span></td>
	</tr>
	
	<tr>
	  <td width="38%"><div align="right">Nombre de Usuario: *</div></td>

	  <td>
		<form name="olvidado" method="get" action="foro.enviar" onSubmit="return Comprueba()">
		<input style="width: 200px;" name="username" size="25" maxlength="40" value="" type="text">
	  </td>
	</tr>
	
	<tr>
	  <td><div align="right">Dirección de E-mail: *</div></td>
	  <td>
		<input class="post" style="width: 200px;" name="mail" size="25" maxlength="255" value="" type="text">

	  </td>
	</tr>
	
	<tr>
	  <td colspan="2" align="center" height="28">
			<input name="operacion" value="Recordar" type="submit">
			<input value="reset" name="Reestablecer" type="reset">
	    </form>
	  </td>
	</tr>

</tbody></table>

<script language="JavaScript" type="text/javascript">

	function Comprueba()
    {
	if (document.olvidado.username.value == "")
		{
		alert("No ha escrito el nombre del usuario")
		document.olvidado.username.focus()
		return false
		}

	else if (document.olvidado.mail.value == "")
		{
		alert("No ha escrito el e-mail del usuario")
		document.olvidado.mail.focus()
		return false
		}
	else
		{
		return true
		}
    }
</script>');
	pie;
END recuerda;



FUNCTION encripta(texto IN VARCHAR2)
RETURN varchar2
IS
BEGIN
   if texto is not null then   
      RETURN DBMS_OBFUSCATION_TOOLKIT.MD5(INPUT => UTL_RAW.CAST_TO_raw(texto));
   else
    return null;
   end if;
END encripta;



PROCEDURE enviar(username VARCHAR2 DEFAULT NULL, mail VARCHAR2 DEFAULT NULL, operacion VARCHAR2 DEFAULT NULL, asunto VARCHAR2 DEFAULT NULL, texto VARCHAR2 DEFAULT NULL) IS
pass NUMBER(10);
passmd5 varchar2(75);
num_usu NUMBER(6):=0;
temp VARCHAR2(50);

BEGIN

	cabecera('Envío de Correo electrónico');
	
		IF asunto IS NOT NULL OR texto IS NOT NULL THEN
	
		IF (operacion = 'Recordar') THEN
		
			HTP.P('<H2><center>Recordatorio de Contraseña</center></H2>');
		
			-- Miramos si existe el usuario y si coincide con el mail
			SELECT COUNT(*) INTO num_usu FROM foro_usuarios WHERE nick = username AND email = mail;

			IF num_usu != 0 THEN
				-- Generamos una contraseña aleatoria
				dbms_random.initialize(17809465);
				 SELECT ABS(dbms_random.normal) INTO pass FROM dual;

				-- Concatenamos esa contraseña con el nombre de usuario y le pasamos el MD5
				passmd5 := encripta(username||pass);
				
				-- Hacemos el UPDATE de la tabla
				UPDATE foro_usuarios
				SET password = passmd5
				WHERE nick = username;
				
				-- Mandamos al e-mail del usuario el mail con la clave
				envio_mail('alvaro@foro.2DAI',mail,'Recordatorio de Contraseña','Se ha generado una nueva contraseña para su usuario del foro. La nueva contraseña es:'||pass);
				
				HTP.P('<h4><center>Se ha enviado un correo electrónico con la nueva contraseña a la dirección de su perfil.</center></h4>');
				
			ELSE
				HTP.P('<h4><center>Error: El nombre de usuario o la contraseña no coinciden.</center></h4>
				<center><A HREF="foro.recuerda">Volver</a></center>');
			
			END IF;
			
		ELSIF (operacion = 'Enviar') THEN
			HTP.P('<H2><center>Envío de Correo Electrónico</center></H2>');
			
			-- Miramos si existe el usuario y si coincide con el mail
			SELECT COUNT(*) INTO num_usu FROM foro_usuarios WHERE email = mail;
			
			IF num_usu != 0 THEN
				SELECT email INTO temp FROM foro_usuarios WHERE nick = username;
				
				envio_mail(temp,mail,asunto,texto);
				HTP.P('<H4><center>E-mail enviado correctamente.</center></H4>');

			ELSE
				HTP.P('<H4><center>Error, el usuario no Existe. Póngase en contacto con el administrador del sistema</center></H4>');
			END IF;

		ELSE
			HTP.P('<H4><center>Error, no se especificó el modo de e-mail</center></H4>');
		END IF;
		
		-- No hay asunto o texto
		ELSE
			HTP.P('<H4><center>Error, no se especificó el texto o el asunto</center></H4>');
		END IF;
		
	pie;
	
EXCEPTION WHEN OTHERS THEN
HTP.P('<H4><center>Error al enviar el mensaje; compruebe que las direciones de correo son correctas</center></H4>');
pie;
END enviar;




PROCEDURE borrar_mensajes (coll_resp foro.coll_id_t DEFAULT foro.sin_respuesta) IS
BEGIN
cabecera('Borrado de mensajes');
HTP.P('<H2><center>Borrado de Mensajes</center></H2>
<table width="50%"  border="0" align="center" cellspacing="5">
  <tr>
    <th scope="col">Mensaje</th>
    <th scope="col">Estado</th>
  </tr>');
FOR contador IN 1..coll_resp.count LOOP
  DELETE FROM foro_mensajes WHERE id = coll_resp(contador);
  htp.p('  <tr>
    <td>Eliminado el mensaje con código '||coll_resp(contador)||'...</td>
    <td>SÍ</td>
  </tr>');
END LOOP;
commit;
HTP.P('</TABLE>
<H3><center>El borrado de '||coll_resp.count||' mensajes ha sido satisfactorio.</center></H3>
<H4><center>Pulse <A HREF="foro.muestra_temas">AQUÍ</A> para volver a la lista de mensajes</center></H4>');
pie;

-- Bloque de excepciones
EXCEPTION

WHEN OTHERS THEN
	cabecera('ERROR');
	HTP.P('<H2><center>ERROR al borrar los mensajes</center></H2>');
	pie;
  ROLLBACK;
END borrar_mensajes;




-- Procedimiento privado para el envío de Correos
PROCEDURE envio_mail (sender IN VARCHAR2,recipient IN VARCHAR2,subject IN VARCHAR2,message IN VARCHAR2) IS
mailhost VARCHAR2(30) := 'smtp.telefonica.net';
mail_conn utl_smtp.connection;
crlf VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );
mesg VARCHAR2( 1000 );

BEGIN

mail_conn := utl_smtp.open_connection(mailhost, 25);
mesg := 'Date: '|| TO_CHAR( SYSDATE, 'dd Mon yyyy hh24:mi:ss' ) || crlf || 
'From: < '|| sender||'>' || crlf ||
'Subject: '|| subject || crlf ||
'To: '|| recipient || crlf ||
'' || crlf || message;
utl_smtp.helo(mail_conn, mailhost);
utl_smtp.mail(mail_conn, sender);
utl_smtp.rcpt(mail_conn, recipient);
utl_smtp.data(mail_conn, mesg);
utl_smtp.quit(mail_conn);
END envio_mail;




PROCEDURE resultados_busqueda (clave VARCHAR2 DEFAULT NULL, autor VARCHAR2 DEFAULT NULL) IS
usu VARCHAR2(35);
tip NUMBER(2);
BEGIN

	-- Vamos a buscar el usuario y ver su Rango ( el rango 3 puede borrar mensajes )   -213-
	usu := busca_usuario;
	
	IF usu IS NOT NULL THEN
		SELECT tipo_usuario INTO tip FROM foro_usuarios WHERE usu = nick;

	cabecera('Resultados de la búsqueda');

	IF clave IS NOT NULL OR autor IS NOT NULL THEN
		HTP.P('<h2><center>Resultados de la Búsqueda</center></h2>

		<table width="85%"  border="0" align="center" cellspacing="5">
		<tr>
			<th scope="col">Tema</th>
			<th scope="col">Mensaje</th>
			<th scope="col">Autor</th>
			<th scope="col">Fecha</th>');
			-- Si es un moderador, activamos el "PODER" de borrar
			IF tip = 3 THEN
				HTP.P('<form name="formulario" method="GET" action="foro.borrar_mensajes">');
				HTP.P('<td><input type="submit" value="Borrar"></Td>');
			END IF;
		HTP.P('</tr>');
		
		-- Búsqueda por autor
		IF clave IS NULL AND autor IS NOT NULL THEN
		FOR REG IN (SELECT * FROM vista_de_busqueda WHERE nick = autor) LOOP
		HTP.P('<tr bgcolor="#cccccc">
			<td><A HREF="foro.muestra_tema?id_tema_pasada='||REG.id_tema||'">'||REG.nombre_tema||'</A></td>
			<td>'||REG.contenido||'</td>
			<td><A HREF="foro.muestra_perfil?id_usua='||REG.nick||'">'||REG.nick||'</A></td>
			<td>'||reg.fecha||'</td>');
			-- Si es un moderador, activamos el "PODER" de borrar
			IF tip = 3 THEN
				HTP.P('<td><INPUT TYPE=checkbox name=coll_resp value='||REG.id||'></Td>');
			END IF;
			HTP.P('</tr>');
		END LOOP;
		END IF;
		
		-- Búsqueda por palabra CLAVE
		IF clave IS NOT NULL AND autor IS NULL THEN
		FOR REG IN (SELECT * FROM vista_de_busqueda WHERE contenido LIKE '%'||clave||'%') LOOP
		HTP.P('<tr bgcolor="#cccccc">
			<td><A HREF="foro.muestra_tema?id_tema_pasada='||REG.id_tema||'">'||REG.nombre_tema||'</A></td>
			<td>'||REG.contenido||'</td>
			<td><A HREF="foro.muestra_perfil?id_usua='||REG.nick||'">'||REG.nick||'</A></td>
			<td>'||reg.fecha||'</td>');
			-- Si es un moderador, activamos el "PODER" de borrar
			IF tip = 3 THEN
				HTP.P('<td><INPUT TYPE=checkbox name=coll_resp value='||REG.id||'></Td>');
			END IF;
			HTP.P('</tr>');
		END LOOP;
		END IF;

		-- Búsqueda por palabra CLAVE Y AUTOR
		IF clave IS NOT NULL AND autor IS NOT NULL THEN
		FOR REG IN (SELECT * FROM vista_de_busqueda WHERE contenido LIKE '%'||clave||'%' AND nick = autor) LOOP
		HTP.P('<tr bgcolor="#cccccc">
			<td><A HREF="foro.muestra_tema?id_tema_pasada='||REG.id_tema||'">'||REG.nombre_tema||'</A></td>
			<td>'||REG.contenido||'</td>
			<td><A HREF="foro.muestra_perfil?id_usua='||REG.nick||'">'||REG.nick||'</A></td>
			<td>'||reg.fecha||'</td>');
			-- Si es un moderador, activamos el "PODER" de borrar
			IF tip = 3 THEN
				HTP.P('<td><INPUT TYPE=checkbox name=coll_resp value='||REG.id||'></Td>');
			END IF;
			HTP.P('</tr>');
		END LOOP;
		END IF;
		HTP.P('</table>');
	
	-- Sentencia nula
	ELSE
		HTP.P('<center><H2>No hay resultados para mostrar</H2></center>');
	END IF;
ELSE
	cabecera('Error');
	HTP.P('<body><center><H2>Error, ha de estar logueado para poder buscar</H2></center>');
END IF;
pie;
END resultados_busqueda;



PROCEDURE enviar_mail (direccion VARCHAR2 DEFAULT NULL) IS
nick_usuario VARCHAR2(35);
BEGIN
cabecera('Envío de e-mail','formulario.asunto');
	nick_usuario := busca_usuario;
	HTP.P('<center><H2>Envío de e-mail</H2></center>');
	-- Si está logueado
	IF nick_usuario IS NOT NULL THEN
		HTP.P('<form action="foro.enviar" method="get" name="formulario" onSubmit="return Comprueba()">
<table width="50%"  border="0" align="center" cellspacing="5">
  <tr>
    <th scope="row" width="25%"><div align="right">Asunto</div></th>
    <td width="5%"></td>
    <td width="70%"><input type="text" name="asunto" maxlength="50" size="45"></td>
  </tr>
  <tr>
    <th scope="row"><div align="right">Mensaje</div></th>
    <td><input type="hidden" name="username" value="'||nick_usuario||'">
	<input type="hidden" name="mail" value="'||direccion||'">
	<input type="hidden" name="operacion" value="Enviar">
	</td>
    <td><textarea name="texto" rows="6" cols="45"></textarea></td>
  </tr>
  <TR>
  <td><div align="right"><input type="submit" value="Enviar"></div></td>
    <td></td>
    <td><input type="reset" value="Reestablecer"></td>
    </td>
	</TR>
</table></form>

	<script language="JavaScript" type="text/javascript">

	function Comprueba()
    {
	if (document.formulario.asunto.value == "")
		{
		alert("No ha escrito ningún asunto")
		document.formulario.asunto.focus()
		return false
		}
	else if (document.formulario.texto.value == "")
		{
		alert("No ha escrito ningún texto")
		document.formulario.texto.focus()
		return false
		}
	else
		{
		return true
		}
    }
</script>

');
	-- En caso de NO estar logueado
	ELSE
		HTP.P('<center><H4>Tienes que estar logueado para poder enviar un e-mail</H4></center>');
	END IF;
pie;
END enviar_mail;




PROCEDURE dar_poderes (usuario VARCHAR2 DEFAULT NULL) IS
nick_usuario VARCHAR2(35);
tip NUMBER(2);
temp NUMBER(2);
nom VARCHAR2(35);
BEGIN
cabecera('Nombrar Moderadores');
	nick_usuario := busca_usuario;
	HTP.P('<center><H2>Nombrando Moderadores</H2></center>');

	-- Si está logueado
	IF nick_usuario IS NOT NULL and usuario IS NOT NULL THEN
		-- Buscamos el rango del usuario
		SELECT tipo_usuario INTO tip FROM foro_usuarios WHERE nick_usuario = nick;

		-- Cogemos su nombre
		SELECT nick INTO nom FROM foro_usuarios WHERE id = usuario;
		
		-- Si es un moderador y no está editándose a si mismo
		IF ( tip = 3  AND nick_usuario != nom ) THEN
			-- Miramos el tipo de usuario que es; si el tipo no es 3, se lo damos
			SELECT tipo_usuario INTO temp FROM foro_usuarios WHERE id = usuario;
			
			-- Si es un moderador, le quitamos ese rango
			IF temp = 3 THEN
				UPDATE foro_usuarios SET tipo_usuario = 2 WHERE id = usuario;
				HTP.P('<center><H4>El usuario '||nom||' ya <u>NO</u> es un moderador</H4></center>');
			-- En caso de que no lo sea, se lo damos
			ELSE
				UPDATE foro_usuarios SET tipo_usuario = 3 WHERE id = usuario;
				HTP.P('<center><H4>El usuario '||nom||' <u>es</u> ahora un moderador</H4></center>');
			END IF;

		-- Si no es moderador
		ELSE
			HTP.P('<center><H4>Sólo los moderadores pueden dar o quitar permisos,</H4></center>
			<center><H4>y nunca a sí mismos.</H4></center>');
		END IF;

	-- Si no está logueado
	ELSE
		HTP.P('<center><H3>Error</H3></center>
		<center><H4>Tienes que estar logueado para poder nombrar moderadores y</H4></center>
		<center><H4>tienes que pasar un identificador para cambiar los permisos</H4></center>');
	END IF;
	HTP.P('<center><H4>Pulse <A HREF="foro.lista_usuarios">AQUÍ</a> para volver a la lista de usuarios</H4></center>');
pie;
END dar_poderes;



END foro;

/
show errors