USE saludlab;

LOAD DATA INFILE '/var/lib/mysql-files/ciudad.csv' INTO TABLE ciudad
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/diagnostico.csv' INTO TABLE diagnostico
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/centro_salud.csv' INTO TABLE centro_salud
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(centro_id, nombre, ciudad_id, @lat, @lon)
SET ubicacion = POINT(@lon, @lat);

LOAD DATA INFILE '/var/lib/mysql-files/paciente.csv' INTO TABLE paciente
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE '/var/lib/mysql-files/atencion.csv' INTO TABLE atencion
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

ANALYZE TABLE ciudad, diagnostico, centro_salud, paciente, atencion;