CREATE INDEX idx_atencion_diag_fecha ON atencion(diagnostico_id, fecha_atencion);
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'ATENCION');
EXIT;