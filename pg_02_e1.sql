EXPLAIN (ANALYZE, BUFFERS)
SELECT a.atencion_id, p.nombre, c.nombre
FROM atencion a
JOIN paciente p ON p.paciente_id = a.paciente_id
JOIN centro_salud c ON c.centro_id = a.centro_id
WHERE a.diagnostico_id = 7
  AND a.fecha_atencion BETWEEN '2025-01-01' AND '2025-03-31';