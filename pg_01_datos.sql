CREATE EXTENSION IF NOT EXISTS postgis;

-- 5 tablas en 3FN
CREATE TABLE ciudad (
  ciudad_id SERIAL PRIMARY KEY,
  nombre VARCHAR(60) NOT NULL
);
CREATE TABLE diagnostico (
  diagnostico_id SERIAL PRIMARY KEY,
  codigo VARCHAR(10) NOT NULL,
  nombre VARCHAR(80) NOT NULL
);
CREATE TABLE centro_salud (
  centro_id SERIAL PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  ciudad_id INT NOT NULL REFERENCES ciudad(ciudad_id),
  ubicacion GEOGRAPHY(Point,4326) NOT NULL
);
CREATE TABLE paciente (
  paciente_id SERIAL PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  ciudad_id INT NOT NULL REFERENCES ciudad(ciudad_id)
);
CREATE TABLE atencion (
  atencion_id SERIAL PRIMARY KEY,
  paciente_id INT NOT NULL REFERENCES paciente(paciente_id),
  centro_id INT NOT NULL REFERENCES centro_salud(centro_id),
  diagnostico_id INT NOT NULL REFERENCES diagnostico(diagnostico_id),
  fecha_atencion DATE NOT NULL,
  historia JSONB NOT NULL
);

-- Datos sinteticos
INSERT INTO ciudad(nombre) SELECT 'Ciudad ' || g FROM generate_series(1,10) g;
INSERT INTO diagnostico(codigo, nombre)
  SELECT 'D' || g, 'Diagnostico ' || g FROM generate_series(1,50) g;
INSERT INTO centro_salud(nombre, ciudad_id, ubicacion)
  SELECT 'Centro ' || g, 1 + (g % 10),
         ST_SetSRID(ST_MakePoint(-72.50 + (random()-0.5)*0.2, 7.89 + (random()-0.5)*0.2), 4326)::geography
  FROM generate_series(1,500) g;
INSERT INTO paciente(nombre, fecha_nacimiento, ciudad_id)
  SELECT 'Paciente ' || g, DATE '1950-01-01' + floor(random()*25000)::int, 1 + floor(random()*10)::int
  FROM generate_series(1,20000) g;
INSERT INTO atencion(paciente_id, centro_id, diagnostico_id, fecha_atencion, historia)
  SELECT 1 + floor(random()*20000)::int, 1 + floor(random()*500)::int, 1 + floor(random()*50)::int,
         DATE '2024-01-01' + floor(random()*700)::int,
         jsonb_build_object('presion', 90 + floor(random()*60)::int,
                            'temperatura', round((36 + random()*3)::numeric, 1),
                            'sintomas', jsonb_build_array('fiebre','tos'))
  FROM generate_series(1,100000) g;
ANALYZE;