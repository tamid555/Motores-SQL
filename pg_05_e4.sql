-- Centros a menos de 5 km del centro de Cucuta
EXPLAIN (ANALYZE)
SELECT centro_id, nombre
FROM centro_salud
WHERE ST_DWithin(ubicacion, ST_SetSRID(ST_MakePoint(-72.5047, 7.8939), 4326)::geography, 5000);

-- Historia clinica en JSON: atenciones con presion mayor a 140
EXPLAIN (ANALYZE)
SELECT atencion_id, historia->>'presion' AS presion, historia->'sintomas'->>0 AS sintoma
FROM atencion
WHERE (historia->>'presion')::int > 140;