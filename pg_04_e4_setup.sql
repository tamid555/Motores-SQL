CREATE INDEX idx_centro_ubicacion ON centro_salud USING GIST (ubicacion);
ANALYZE centro_salud;