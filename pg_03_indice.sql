CREATE INDEX idx_atencion_diag_fecha ON atencion(diagnostico_id, fecha_atencion);
ANALYZE atencion;