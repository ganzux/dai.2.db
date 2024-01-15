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
		SELECT COUNT(*) INTO numero FROM foro_usuarios WHERE foro_usuarios.password = galleta.vals(1);
		-- Si existe la contraseña
		IF numero != 0 THEN
			-- Me recuperas el nombre
			SELECT foro_usuarios.nick INTO nombre FROM foro_usuarios WHERE foro_usuarios.password = galleta.vals(1);
		END IF; -- Existe el usuario
	END IF;  -- Existe la Cookie

  RETURN nombre;
end busca_usuario;




-- Procedimiento que genera un pie de Página
PROCEDURE pie IS
nombre VARCHAR2(40);
BEGIN
	nombre:=busca_usuario;
	HTP.P('<hr align="center" width="75%">');
	-- Si existe la Cookie
	IF (nombre IS NOT NULL) THEN
		HTP.P('<CENTER><b>Ud. está en el sistema como '||nombre||'</b></CENTER></BODY></HTML>');
	ELSE
		HTP.P('<CENTER><b>Ud. no está logueado en el sistema. <A HREF="foro.registro">(Registrarse)</b></A></CENTER></BODY></HTML>');
	END IF;
END pie;




-- Cabecera de las páginas
PROCEDURE cabecera (titulo VARCHAR2 DEFAULT NULL) IS
nomb VARCHAR2(35);
BEGIN
nomb := busca_usuario;
-- Cabecera de todas las webs
htp.p('<HTML><HEAD><TITLE>Foro de Mensajes -- '||titulo||'</TITLE>
 <LINK href="../alumnos/Alvaro/css/hoja.css" rel="stylesheet" type="text/css">
</HEAD><BODY onload="document.formulario.asunto.focus()">');
-- Tabla de Inicio de Sesión
HTP.P('<center><table border="0" cellpadding="2" cellspacing="2" width="95%">
    <tr>');

 IF nomb IS NOT NULL THEN
      HTP.P('<td align="left" width="50%"><div class="cattitle">Nombre de Usuario: '||nomb||'</div></td>');
 END IF;

      HTP.P('<td align="center"><a href="foro.login"><div class="cattitle">Inicio de Sesión</div></a></td>
		<td align="center"><A HREF="foro.nuevo_tema"><div class="cattitle">Nuevo Tema</div></A></td>
		<td align="center"><A HREF="foro.muestra_temas"><div class="cattitle">Lista de Temas</div></A></td>
		<td align="center"><A HREF="foro.perfil"><div class="cattitle">Perfil</div></A></td>
    </tr>
</table>
<hr align="center" width="75%">');
END cabecera;




PROCEDURE muestra_tema (id_tema_pasada NUMBER DEFAULT NULL) IS
nom VARCHAR2(35);
tem VARCHAR2(55);
BEGIN
  -- Si existe el tema
  IF id_tema_pasada IS NOT NULL THEN
	SELECT nombre_tema INTO tem FROM foro_temas WHERE foro_temas.id = id_tema_pasada;
    cabecera('Vista del Tema');

    HTP.P('<p><H2>Tema: '||tem||'</H2></p><table width="90%"  border="0" cellspacing="5" align="center">
    <tr>
		<th class="thCornerL" width="15%" nowrap="nowrap">Asunto</TH>
		<th class="thTop" nowrap="nowrap" width="50%">Mensaje</TH>
		<th class="thTop" nowrap="nowrap" width="15%">Autor</TH>
		<th class="thCornerR" nowrap="nowrap" width="15%">Fecha</TH>
    </tr>');
    FOR REG IN (SELECT * FROM foro_mensajes WHERE id_tema = id_tema_pasada ORDER BY id DESC)
    LOOP
      -- Metemos en el nom el nick del usuario
      SELECT nick INTO nom FROM foro_usuarios WHERE id = REG.id_usuario;
      HTP.P('<TR bgcolor="CCCCCC">');
      HTP.P('<TD><center>'||REG.asunto||'</TD>');
      HTP.P('<TD><center>'||REG.contenido||'</TD>');
      HTP.P('<TD><center><A HREF="foro.muestra_perfil?id_usua='||nom||'">'||nom||'</A></TD>');
      HTP.P('<TD><center>'||REG.fecha||'</TD>');
      HTP.P('</TR>');
    END LOOP;
    HTP.P('</TABLE><hr align="center" width="75%">
	<table width="75%"  border="0" align="center" cellspacing="0">
	  <tr bgcolor="lightblue">
	    <td width="30%"><div align="right"><-- Anterior</div></td>
	    <td width="5%"></td>
	    <td width="30%"><div align="center">');
      IF busca_usuario IS NOT NULL THEN
            HTP.P('<A HREF="foro.nuevo_mensaje?id_tema_pasada='||id_tema_pasada||'">Nuevo Mensaje</A>');
      END IF;
      HTP.P('</div></td>
	    <td width="5%"></td>
	    <td width="30%">Siguiente --></td>
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
    cabecera('Nuevo Mensaje');
    HTP.P('<form name="nuevo_mensaje" method="GET" action="foro.publicar">
    <p>Asunto
    <input name="asunto" type="text" size="50" maxlength="50"></p>
    <p>Mensaje
    <textarea name="texto" cols="90" rows="6"></textarea></p>
    <p>
    <input name="tema" type="hidden" value="'||id_tema_pasada||'">
    <input type="submit" value="Enviar Mensaje">
    <input type="reset" value="Borrar"></p>
    </form>');
    pie;
  END IF;
END nuevo_mensaje;



PROCEDURE publicar (asunto VARCHAR2 DEFAULT NULL,texto VARCHAR2 DEFAULT NULL, tema NUMBER DEFAULT NULL) IS
id_usuario_captada NUMBER(5);
nom VARCHAR2(35);
BEGIN


  -- Si tiene todos los campos requeridos
  IF asunto IS NOT NULL AND texto IS NOT NULL AND tema IS NOT NULL THEN
    cabecera('Publicar Mensaje');
    -- Cogemos el nombre del usuario de la cookie
    nom := busca_usuario;
    -- Buscamos la id de ese usuario
    SELECT id INTO id_usuario_captada FROM foro_usuarios WHERE nick = nom;
    -- Publicamos el mensaje
    INSERT INTO foro_mensajes VALUES (seq_foro_men.NEXTVAL,SYSDATE,asunto,texto,id_usuario_captada,tema);
    -- El HTML
    HTP.P('<H3>Mensaje publicado con éxito</H3>
	Pulse <A HREF="foro.muestra_tema?id_tema_pasada='||tema||'">AQUÍ</A> para volver al mensaje.');
  
  -- Algún campo es nulo
  ELSE
    cabecera('Error');
    IF asunto IS NULL THEN
      HTP.P('<H3>El asunto es requerido para poder publicar</H3>');
    END IF;

    IF texto IS NULL THEN
      HTP.P('<H3>El texto es requerido para poder publicar</H3>');
    END IF;

    IF tema IS NULL THEN
      HTP.P('<H3>El tema es requerido para poder publicar</H3>');
    END IF;
    HTP.P('<H3>Pulse <A HREF="foro.muestra_temas">AQUÍ</A> para volver</H3>');
  END IF;

    pie;
EXCEPTION WHEN OTHERS THEN HTP.P(':P');
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
    HTP.P('<H2>Te has desconectado con éxito</H2>
	<br>
	<A HREF="foro.principal"><center>VOLVER AL INICIO</A>');
  pie;
  -- Sin embargo, si no existe nada, error
  ELSE
    cabecera('Error');
    HTP.P('No estás logueado.');
    pie;
  END IF;
END salir;




PROCEDURE muestra_temas IS
BEGIN
	cabecera('Lista de Temas');
	HTP.P('<table width="90%"  border="0" cellspacing="3" align="center">
	<tr>
    <th class="thCornerL" width="50%" nowrap="nowrap">Título del Tema</th>
    <th class="thTop" nowrap="nowrap" width="20%">Autor</th>
    <th class="thTop" nowrap="nowrap">Mensajes</th>
    <th class="thCornerR" nowrap="nowrap" width="15%">Último Mensaje</th>
  </tr>');
	FOR REG IN (SELECT * FROM vista_temas)
    LOOP
		HTP.P('<TR bgcolor="#CCCCCC">');
		HTP.P('<TD><center><A class="topictitle" HREF="foro.muestra_tema?id_tema_pasada='||REG.id||'">'||REG.nombre_tema||'</A></TD>');
		HTP.P('<TD><center><A HREF="foro.muestra_perfil?id_usua='||REG.nick||'">'||REG.nick||'</A></TD>');
		HTP.P('<TD><center>0</TD>');
		HTP.P('<TD><center>'||SYSDATE||'</TD>');
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
	INSERT INTO foro_usuarios VALUES (seq_foro_usu.NEXTVAL,nombre,login,pass,mail);
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
cabecera();
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
      <td><input type="text" name="nombre" onkeyup="RellenaValores()"></td>
    </tr>
    <tr>
      <td><div align="right"><b>Login</b></div></td>
      <td></td>
	  <td><input type="text" name="login" onkeyup="RellenaValores()"></td>
    </tr>
    <tr>
      <td><div align="right"><b>Password</b></div></td>
      <td></td>
	  <td><input type="password" name="pass" onkeyup="RellenaValores()">
	  </td>
    </tr>
    <tr>
      <td><div align="right"><b>Repita el Password</b></div></th>
      <td></td>
	  <td><input type="password" name="pas2" onkeyup="RellenaValores()">
	  </td>
    </tr>

    <tr>
      <td><div align="right"><b>e-mail</b></div></th>
      <td></td>
	  <td><input type="text" name="mail" onkeyup="RellenaValores()"></td>
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
	  // Si el login está vacío
      if (document.enviar.login.value=="")
        {
        alert("El Campo Login Es Obligatorio")
		document.enviar.login.focus
        return false
        }
	  // Si ha pasado todas las comprobaciones, está OK
	  else
		{
		return true
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

	cabecera('Nuevo Tema');

	IF nombre IS NOT NULL THEN
		HTP.P('<form name="formulario" method="GET" action="foro.crear_nuevo_tema">
<b>Título del Tema</n>    <input name="asunto" type="text" size="50" maxlength="50">
<input type="Submit" value="Crear Nuevo Tema">
<input type=hidden name="usuario" value="'||nombre||'">
</form>');
	ELSE
		HTP.P('<h2>Tiene que estar Logueado para poder postear.</h2>');
	END IF;
  pie();
END nuevo_tema;



PROCEDURE crear_nuevo_tema (asunto VARCHAR2 DEFAULT NULL, usuario VARCHAR2 DEFAULT NULL) IS
id_usuario NUMBER(5);
BEGIN
  -- Si existen el Usuario Y el Asunto
  IF asunto IS NOT NULL AND usuario IS NOT NULL THEN
    SELECT foro_usuarios.id INTO id_usuario FROM foro_usuarios WHERE usuario = foro_usuarios.nombre;
    INSERT INTO foro_temas VALUES (seq_foro_tem.NEXTVAL,id_usuario,asunto);
    cabecera('Tema Creado');
    HTP.P('<h2>El TEMA ha sido Creado</h2>
	<h4><A HREF="foro.muestra_temas">Pulse AQUÍ para ver todos los temas</a></h4>');
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
PROCEDURE login (chorro VARCHAR2 DEFAULT NULL) IS
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
  HTP.P('<h2>Ya estás logueado en el Foro </h2>');
  HTP.P('<h4><a href="foro.salir">Desconectarse</a></h2>');
  pie;
  
  -- No Hay Cookie
  ELSE
  -- No hay Cookie, Si no hay Chorro
  IF chorro IS NULL THEN
    cabecera('Inicio de Sesión');
    HTP.P('<h2>Inicio de Sesión</h2>
    <script src="../alumnos/Alvaro/js/md5.js" type="text/javascript"></script>');
    HTP.P('<form name="datos"><center>
            <table border="0" cellpadding="2" cellspacing="2" width="50%">
             <tr>
              <td>Nombre de Usuario</td>
              <td><input type="text" name=usua onkeyup="CalculaHash(event)"></td>
             </tr>
             <tr>
            <td>Contraseña</td>
            <td><input type="password" name=pass onkeyup="CalculaHash(event)"></td>
           </tr>
          </table></form>');
    -- Ahora metemos el botón, que encriptará en nombre de usuario y el password
    -- y comprobará que existan o no
    HTP.P('<form name="botonenviar" method=GET onsubmit="return CompruebaTodo()">
      <input name=chorro type=hidden>
      <center><input type="submit" value="Entrar"></center></form>
  
      <script language="JavaScript" type="text/javascript">
          function CalculaHash(event)
          {
          document.botonenviar.chorro.value=hex_md5(document.datos.usua.value+document.datos.pass.value)
          }
  
          function CompruebaTodo()
          {
            if (document.datos.usua.value=="" || document.datos.pass.value=="")
              {
              alert("Los campos Login y Password son obligatorios")
              return false
              }
            else
              {
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
    SELECT COUNT(*) INTO numero FROM foro_usuarios WHERE foro_usuarios.password = chorro;
      -- Si existe la contraseña
      IF numero != 0 THEN
        -- Me recuperas el nombre
        SELECT foro_usuarios.nick INTO nombre FROM foro_usuarios WHERE foro_usuarios.password = chorro;
        -- Y me creas la Cookie
        OWA_UTIL.mime_header('text/html', FALSE);
        OWA_COOKIE.send ('foro',TO_CHAR(chorro));
        OWA_UTIL.http_header_close;
      -- Me pones la web
      cabecera('Inicio de Sesión');
      HTP.P('<h2>Bienvenido de Nuevo al Foro '||nombre||'</h2>');
      HTP.P('<h4><a href="foro.salir">Desconectarse</a></h4>');
      
      -- Usuario o contraseña no correctas
      ELSIF numero = 0 THEN
        cabecera('Usuario Incorrecto');
        HTP.P('<H3>Ha introducido un usuario o una contraseña no válidos</H3>
        <h4>Pulse <A HREF="foro.login">AQUÍ</A> para volver</h4>');
      END IF; -- Fin de que exista o no la contraseña
      pie;
  END IF; -- Existe o no el chorro
END IF;  -- Existe o no la Cookie

  EXCEPTION
    WHEN OTHERS THEN
      HTP.P('<p>Error de login: Se ha producido una Excepción '||SQLCODE||SQLERRM);
END login;





PROCEDURE perfil IS
nombre VARCHAR2(35);
BEGIN
nombre := busca_usuario;

	--Si existe el Usuario, ponemos sus datos
	IF nombre IS NOT NULL THEN
	cabecera('Perfil De Usuario');
	HTP.P('Perfil de '||nombre);
  pie;
  
	-- Sin embargo, si el Usuario no existe, error
	ELSE
    cabecera('Error , Logueate');
		HTP.P('<h3>Error, no está logueado en el sistema</h3>');
  	pie;  
	END IF;

END perfil;



-- Principal
PROCEDURE principal IS
BEGIN
cabecera();
HTP.P('<h1>FORO</h1>');
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
          HTP.P('<table width="50%"  border="0" align="center" cellspacing="6">
        <tr>
          <th><div align="right" width="50%">Nombre real </div></th>
          <td width="50%">');
          SELECT nombre INTO temp FROM vista_usuarios WHERE id_usua = nick;
          HTP.P(temp||'</td>
        </tr>
        <tr>
          <th><div align="right">Nick </div></th>
          <td>'||id_usua||'</td>
        </tr>
        <tr>
          <th><div align="right">e-mail </div></th>
          <td>');
          SELECT email INTO temp FROM vista_usuarios WHERE id_usua = nick;
          HTP.P(temp||'</td>
        </tr>
      </table>
       <h4>Ver todos los mensajes de '||id_usua||'</h4>');
    pie;
    
    -- Existe valor pero no encontramos el usuario
    ELSE
      cabecera('Error');
      HTP.P('<h3>Error, el usuario '||id_usua||' no existe.</h3>');
      pie;
    END IF; -- Existe el usuario
    
    -- No existe valor pasado
    ELSE
    cabecera('Error');
    HTP.P('<H3>Error, no indicó el usuario</h3>');
    pie;
    
  END IF; -- Existe el valor pasado
END muestra_perfil;

END foro;

/
show errors;

-- @ 'C:\Documents and Settings\AlVaRiTo\Escritorio\foro\foro_cuerpo.sql';