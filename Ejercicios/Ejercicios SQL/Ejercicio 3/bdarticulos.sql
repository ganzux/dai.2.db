drop table stock;
drop table articulo;
drop table proveedor;
drop table almacen;

create table articulo(
id_art char(2),
descripcion varchar2(10),
precio_comp number(6),
precio_vent number(6),
proveedor char(2),
ord_pte number(4),
constraint pk_articulo primary key (id_art));

create table almacen(
id_alm	char(2),
direccion	varchar2(15),
num_max_art	number(6),
constraint pk_almacen primary key (id_alm));

create table stock(
id_art char(2),
id_alm char(2),
cant	number(5),
constraint pk_stock primary key (Id_art,Id_alm),
constraint fk_stock1 foreign key (id_art) references articulo,
constraint fk_stock2 foreign key (id_alm) references almacen);


insert INTO articulo values('P1','TUERCA',15000,17000,'S1',600);
insert INTO articulo values('P2','PERNO',12000,13000,'S1',NULL);
insert INTO articulo values('P3','BIRLO',11500,13000,'S5',300);
insert INTO articulo values('P4','BIRLO',12000,14000,'S2',NULL);
insert INTO articulo values('P5','LEVA',7000,10000,'S2',500);
insert INTO articulo values('P6','ENGRANE',6000,9000,'S3',900);
insert INTO articulo values('P8','VALVULA',6200,8000,'S1',NULL);
insert INTO articulo values('P9','COJINETE',400,700,'S1',2000);
insert INTO articulo values('R1','TORNILLO',150,220,'S2',1000);
insert INTO articulo values('R2','ESCARPIA',120,190,'S5',NULL);
insert INTO articulo values('R3','PISTON',10000,14000,'S3',20);

INSERT INTO ALMACEN VALUES ('A1','CALLE 34,2',8000);
INSERT INTO ALMACEN VALUES ('A2','CALLE 34,12',16000);
INSERT INTO ALMACEN VALUES ('A3','CALLE 26,15',25000);
INSERT INTO ALMACEN VALUES ('A4','CALLE 22,6',15000);

INSERT INTO STOCK VALUES ('P1','A1',200);
INSERT INTO STOCK VALUES ('P1','A2',700);
INSERT INTO STOCK VALUES ('P3','A1',400);
INSERT INTO STOCK VALUES ('P4','A1',200);
INSERT INTO STOCK VALUES ('P2','A3',200);
INSERT INTO STOCK VALUES ('P3','A4',500);
INSERT INTO STOCK VALUES ('P3','A2',600);
INSERT INTO STOCK VALUES ('P3','A3',1200);
INSERT INTO STOCK VALUES ('P5','A4',800);
INSERT INTO STOCK VALUES ('P5','A3',100);
INSERT INTO STOCK VALUES ('P6','A1',1600);
INSERT INTO STOCK VALUES ('P2','A1',900);
INSERT INTO STOCK VALUES ('R1','A2',100);
INSERT INTO STOCK VALUES ('R2','A2',500);
INSERT INTO STOCK VALUES ('P9','A4',1000);
INSERT INTO STOCK VALUES ('P8','A4',70);
INSERT INTO STOCK VALUES ('P9','A3',920);

create table proveedor(
id_prov char(2),
nombre varchar2(10),
saldo_deudor number(7),
constraint pk_proveedor primary key (id_prov));

insert into proveedor
values('S1','LOZANO',100000);
insert into proveedor
values('S2','GOMEZ',250000);
insert into proveedor
values('S3','SUAREZ',400000);
insert into proveedor
values('S4','RAMIREZ',0);
insert into proveedor
values('S5','MARTIN',300000);

ALTER TABLE ARTICULO
ADD (CONSTRAINT FK_ARTICULO FOREIGN KEY (PROVEEDOR) REFERENCES PROVEEDOR(ID_PROV));

commit;