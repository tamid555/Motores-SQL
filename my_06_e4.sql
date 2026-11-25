USE saludlab;

EXPLAIN ANALYZE
SELECT centro_id, nombre
FROM centro_salud
WHERE ST_Distance_Sphere(ubicacion, POINT(-72.5047, 7.8939)) <= 5000;

EXPLAIN ANALYZE
SELECT atencion_id, historia->>'$.presion' AS presion, historia->>'$.sintomas[0]' AS sintoma
FROM atencion
WHERE CAST(historia->>'$.presion' AS UNSIGNED) > 140;