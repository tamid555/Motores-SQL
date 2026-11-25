LOAD DATA
INFILE '/tmp/atencion.csv'
APPEND INTO TABLE atencion
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(atencion_id, paciente_id, centro_id, diagnostico_id, fecha_atencion DATE "YYYY-MM-DD", historia CHAR(1000))
