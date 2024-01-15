//solucion

create table TIT_AUT_NAC (
titulo varchar(50),
autor varchar(40),
nacionalidad varchar(25));


Fichero ctl
****************************************************************
LOAD DATA
     INFILE 'C:\Documents and Settings\Administrador\Mis documentos\LazaroCardenas\Curso2005-06\SQL\TituloAutorNacionalidad.txt'  "str '\n'"
     INTO TABLE  TIT_AUT_NAC
     FIELDS  TERMINATED  BY  '#'  OPTIONALLY  ENCLOSED  BY  '"'
     (titulo, autor,  nacionalidad)

******************************************************************
Llamada sqlloader

SQLLDR CONTROL=sql9.ctl, LOG=sample.log, BAD=baz.bad,USERID=scott/tiger@orcl, ERRORS=999, LOAD=2000,DISCARD=toss.dsc

****************************************************************
drop table  titulos;
drop table  autores;
drop table  nacionalidades;
create table nacionalidades (
id number(4),
nacionalidad varchar2(25));




create sequence nac_sequence
increment by 1
start with 1
nomaxvalue
nocycle
cache 10;

create sequence tit_sequence
increment by 1
start with 1
nomaxvalue
nocycle
cache 10;

create sequence aut_sequence
increment by 1
start with 1
nomaxvalue
nocycle
cache 10;


insert into nacionalidades(nacionalidad)
 select distinct(nacionalidad) from tit_aut_nac;

update nacionalidades
set id=nac_sequence.nextval;

create  table autores (
id number(4),
autor varchar2(40),
id_nac number(4));

insert into autores(autor,id_nac)
select autor,id from TIT_AUT_NAC,nacionalidades where TIT_AUT_NAC.nacionalidad=nacionalidades.nacionalidad group by autor,id
order by autor;

update autores
set id=aut_sequence.nextval;

create  table titulos (
id number(4),
titulo varchar2(50),
id_aut number(4));


insert into titulos(titulo,id_aut)
select titulo,id from TIT_AUT_NAC,autores where TIT_AUT_NAC.autor=autores.autor ;

update titulos
set id=tit_sequence.nextval;

alter table nacionalidades
add constraint pk_nac primary key (id);

alter table autores
add constraint pk_aut primary key (id);
alter table autores
add constraint fk_aut foreign key (id_nac) references nacionalidades(id);

alter table titulos
add constraint pk_tit primary key (id);
alter table titulos
add constraint fk_tit foreign key (id_aut) references autores(id);


/*Listado con el numero de titulos de cada nacionalidad*/	
SELECT nacionalidad, count(titulo)
	FROM nacionalidades n
	, titulos t
	, autores a
	where t.id_aut=a.id AND a.id_nac=n.id
	GROUP BY nacionalidad;

/*Nombre del autor que mas titulos tiene*/
select autor from autores where id=(
select id_aut from titulos
group by id_aut
having count(*)=(select max(count(*)) from titulos
			group by id_aut));
