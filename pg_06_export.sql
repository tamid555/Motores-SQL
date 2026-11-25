COPY ciudad TO '/tmp/ciudad.csv' CSV HEADER;
COPY diagnostico TO '/tmp/diagnostico.csv' CSV HEADER;
COPY (SELECT centro_id, nombre, ciudad_id, ST_Y(ubicacion::geometry) AS lat, ST_X(ubicacion::geometry) AS lon FROM centro_salud) TO '/tmp/centro_salud.csv' CSV HEADER;
COPY paciente TO '/tmp/paciente.csv' CSV HEADER;
COPY atencion TO '/tmp/atencion.csv' CSV HEADER;