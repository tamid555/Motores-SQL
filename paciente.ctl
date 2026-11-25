LOAD DATA
INFILE '/tmp/paciente.csv'
APPEND INTO TABLE paciente
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(paciente_id, nombre, fecha_nacimiento DATE "YYYY-MM-DD", ciudad_id)
