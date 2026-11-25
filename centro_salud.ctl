LOAD DATA
INFILE '/tmp/centro_salud.csv'
APPEND INTO TABLE centro_salud
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(centro_id, nombre, ciudad_id, lat, lon)
