CREATE OR REPLACE PACKAGE BODY encuesta AS

PROCEDURE principal (voteID NUMBER DEFAULT NULL,Boton VARCHAR2 DEFAULT NULL) IS

-- Metemos todos los nombres de las pelis en un Cursor llamado nombres
CURSOR nombres IS SELECT id,nombre FROM datos_encuesta ORDER BY nombre;
-- Una cookie auxiliar
galletita OWA_COOKIE.cookie;
-- Variable Auxiliar
auxiliar VARCHAR2(20);
BEGIN

-- Lo primero es meter en la Cookie auxiliar la cookie:
galletita := OWA_COOKIE.get('encuesta_pelicula');

IF voteID IS NOT NULL AND galletita.num_vals = 0 THEN
  -- Me haces el Update
  UPDATE datos_encuesta SET votos=votos+1 WHERE datos_encuesta.id=voteID;
  COMMIT;
  -- Y me creas la Cookie
  OWA_UTIL.mime_header('text/html', FALSE);
  OWA_COOKIE.send ('encuesta_pelicula',TO_CHAR(voteID));  
  OWA_UTIL.http_header_close;
END IF;

htp.p('<HTML><HEAD><TITLE>Encuesta</TITLE></HEAD>

<BODY bgcolor=#333399 text=000000 link=FFFFFF vlink=FFFFFF>

<CENTER>');
IF Boton IS NOT NULL AND voteID IS NOT NULL AND galletita.num_vals = 0 THEN
  HTP.P('¡¡¡ Gracias por votar !!!');
END IF;
HTP.P('<FORM action="encuesta.principal" method="get">

<TABLE border=1><TR><TD>
<TABLE width=100% border=0 cellspacing=0 cellpadding=10>
<TR><TD colspan=2 bgcolor=#CCCCCC>
 <FONT size=3><B>Encuesta de Películas</B></TD></TR>

 <TR><TD bgcolor=FFFFFF><FONT size=3>');


IF galletita.num_vals = 0 THEN
  HTP.P('<BR><FONT size=-1>(Puedes votar tu pelicula favorita)</font><BR><BR>');
ELSE
  SELECT nombre INTO auxiliar FROM datos_encuesta
  WHERE id = galletita.vals(1);
  HTP.P('<BR><FONT size=-1>(Sólo puedes Votar una vez, y tú ya has votado por '||auxiliar||')</font><BR><BR>');
END IF;

FOR REG IN nombres LOOP
HTP.P('<INPUT type="radio" name="voteID" value='||REG.id||'><font color=#333399><b>'||REG.nombre||'</b></font> <BR>');
END LOOP;
HTP.P(' </TD></TR></TABLE>

</TD></TR></TABLE>
<P><INPUT class=boton type=submit name="Boton" value="Votar">
  <a href=encuesta.resultado>(Ver resultados)</a>
</FORM>

</CENTER>
</BODY>
</HTML>
');

END principal;

PROCEDURE resultado IS

-- Metemos todos los nombres de las pelis en un Cursor llamado nombres
CURSOR nombres IS SELECT id,nombre,votos FROM datos_encuesta ORDER BY votos DESC;

total NUMBER(5);
porcen NUMBER (5,2);

BEGIN

SELECT SUM(votos) INTO total FROM datos_encuesta;

HTP.P('<HTML><HEAD><TITLE>Resultados de la Encuesta</TITLE></HEAD>

<BODY bgcolor=#333399 text=000000 link=FFFFFF vlink=FFFFFF>

<CENTER><TABLE cellSpacing=0 cellPadding=2 width="100%" border=0>
   <TR><TD vAlign=top width="100%">
   <CENTER>

   <FONT color="#FFFFFF" size=+1><b>Resultados</b></FONT><P>
   	<TABLE cellspacing=2 cellPadding=0 bgColor=#000000 border=0>
       	<TR><TD colspan=2>
        		<TABLE cellSpacing=2 cellPadding=5 bgColor=#ffffff border=0>
        		<TR><TD>
        		    <CENTER><BR>
 "<B>Encuesta de Peliculas </B><BR><BR><TABLE>');

-- Cursor para todas las películas
FOR REG IN nombres LOOP
-- Metemos el porcentaje de sus votos en una variable temporal
porcen := REG.votos*100/total;
-- Escribimos le nombre
HTP.P('<TR><TD>'||REG.nombre||'</TD><TD>');
-- Si tiene algún voto, le ponemos el dibujo
IF REG.votos > 0 THEN
	  HTP.P('<IMG height=14 src="/alumnos/imagenes/leftbar.gif" width=7><IMG height=14 alt="32 %" src="/alumnos/imagenes/mainbar.gif" width= '||REG.VOTOS*100/total||'><IMG height=14 src="/alumnos/imagenes/rightbar.gif" width=7>');
END IF;
-- Escribimos porcentaje de votos y número de votos
	  HTP.P('</TD><TD>'||porcen||'% ('||reg.votos||')</TD></TR>');
END LOOP;

-- Ponemos el total de pelis
HTP.P('Total: '||total||'</table></table><br><br><a href="encuesta.principal">(Volver)</a></body></html>');
END resultado;

END encuesta;

/
show errors;