-- nos conectamos como administradores

create table control_conexiones (
usuario varchar2(20),
momento timestamp,
evento varchar2(20));

create or replace trigger ctrl_conexiones
after logon
on database
begin
	insert into control_conexiones
		values(ORA_LOGIN_USER,SYSTIMESTAMP,ORA_SYSEVENT);
END;
/
		
create table control_eventos (
usuario varchar2(20),
momento timestamp,
evento varchar2(20));


create or replace trigger ctrl_eventos
after ddl
on database
begin
	insert into control_eventos
		values(ORA_LOGIN_USER,SYSTIMESTAMP,ORA_SYSEVENT||'*'||ORA_DICT_OBJ_NAME);
END;
/
	