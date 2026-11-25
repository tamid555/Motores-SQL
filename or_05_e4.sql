ALTER TABLE centro_salud ADD (ubicacion SDO_GEOMETRY);

UPDATE centro_salud
SET ubicacion = SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(lon, lat, NULL), NULL, NULL);
COMMIT;

INSERT INTO user_sdo_geom_metadata (table_name, column_name, diminfo, srid)
VALUES (
  'CENTRO_SALUD',
  'UBICACION',
  SDO_DIM_ARRAY(
    SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005),
    SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)
  ),
  4326
);
COMMIT;

CREATE INDEX idx_centro_ubicacion ON centro_salud(ubicacion)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

EXEC DBMS_STATS.GATHER_SCHEMA_STATS('SALUDLAB');

SET SERVEROUTPUT ON
DECLARE
  t0 TIMESTAMP;
  t1 TIMESTAMP;
  ms NUMBER;
  v_cnt NUMBER;
BEGIN
  FOR i IN 1..4 LOOP
    t0 := SYSTIMESTAMP;
    SELECT COUNT(*) INTO v_cnt
    FROM centro_salud
    WHERE SDO_WITHIN_DISTANCE(
      ubicacion,
      SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(-72.5047, 7.8939, NULL), NULL, NULL),
      'distance=5 unit=KM'
    ) = 'TRUE';
    t1 := SYSTIMESTAMP;
    ms := EXTRACT(MINUTE FROM (t1 - t0)) * 60000 + EXTRACT(SECOND FROM (t1 - t0)) * 1000;
    DBMS_OUTPUT.PUT_LINE('Espacial Corrida ' || i || ' (filas=' || v_cnt || '): ' || ROUND(ms, 3) || ' ms');
  END LOOP;

  FOR i IN 1..4 LOOP
    t0 := SYSTIMESTAMP;
    SELECT COUNT(*) INTO v_cnt
    FROM atencion
    WHERE JSON_VALUE(historia, '$.presion' RETURNING NUMBER) > 140;
    t1 := SYSTIMESTAMP;
    ms := EXTRACT(MINUTE FROM (t1 - t0)) * 60000 + EXTRACT(SECOND FROM (t1 - t0)) * 1000;
    DBMS_OUTPUT.PUT_LINE('JSON Corrida ' || i || ' (filas=' || v_cnt || '): ' || ROUND(ms, 3) || ' ms');
  END LOOP;
END;
/
EXIT;