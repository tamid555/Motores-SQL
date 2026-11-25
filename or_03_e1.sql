SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET LINESIZE 200
SET PAGESIZE 100

EXEC DBMS_STATS.GATHER_SCHEMA_STATS(USER);

DECLARE
  t0 TIMESTAMP;
  t1 TIMESTAMP;
  n NUMBER;
  ms NUMBER;
BEGIN
  FOR i IN 1..4 LOOP
    t0 := SYSTIMESTAMP;
    SELECT SUM(a.atencion_id + LENGTH(p.nombre) + LENGTH(c.nombre)) INTO n
    FROM atencion a
    JOIN paciente p ON p.paciente_id = a.paciente_id
    JOIN centro_salud c ON c.centro_id = a.centro_id
    WHERE a.diagnostico_id = 7
      AND a.fecha_atencion BETWEEN DATE '2025-01-01' AND DATE '2025-03-31';
    t1 := SYSTIMESTAMP;
    ms := EXTRACT(MINUTE FROM (t1 - t0)) * 60000 + EXTRACT(SECOND FROM (t1 - t0)) * 1000;
    DBMS_OUTPUT.PUT_LINE('Corrida ' || i || ': ' || ROUND(ms, 3) || ' ms');
  END LOOP;
END;
/

EXPLAIN PLAN FOR
SELECT a.atencion_id, p.nombre, c.nombre
FROM atencion a
JOIN paciente p ON p.paciente_id = a.paciente_id
JOIN centro_salud c ON c.centro_id = a.centro_id
WHERE a.diagnostico_id = 7
  AND a.fecha_atencion BETWEEN DATE '2025-01-01' AND DATE '2025-03-31';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
EXIT;