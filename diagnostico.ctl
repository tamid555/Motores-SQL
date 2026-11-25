LOAD DATA
INFILE '/tmp/diagnostico.csv'
APPEND INTO TABLE diagnostico
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(diagnostico_id, codigo, nombre)
