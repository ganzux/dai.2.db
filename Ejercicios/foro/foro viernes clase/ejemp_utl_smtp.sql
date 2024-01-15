create or replace PROCEDURE SI_SEND_MAIL
( sender IN VARCHAR2,
recipient IN VARCHAR2,
subject IN VARCHAR2,
message IN VARCHAR2)
IS
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
END SI_SEND_MAIL;
/

execute SI_SEND_MAIL('javirobles@telefonica.net','javier@cnice.mecd.es','Saludito','kk de vaca');