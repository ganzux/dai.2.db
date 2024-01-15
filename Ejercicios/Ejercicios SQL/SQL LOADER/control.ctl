OPTIONS (SKIP=7)
LOAD DATA
INFILE 'd:\loader\codpos.txt'
INTO TABLE codigos
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
(provincia, poblacion, cp)