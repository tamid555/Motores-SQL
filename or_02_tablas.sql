CREATE TABLE ciudad (
  ciudad_id NUMBER PRIMARY KEY,
  nombre VARCHAR2(60) NOT NULL
);
CREATE TABLE diagnostico (
  diagnostico_id NUMBER PRIMARY KEY,
  codigo VARCHAR2(10) NOT NULL,
  nombre VARCHAR2(80) NOT NULL
);
CREATE TABLE centro_salud (
  centro_id NUMBER PRIMARY KEY,
  nombre VARCHAR2(80) NOT NULL,
  ciudad_id NUMBER NOT NULL REFERENCES ciudad(ciudad_id),
  lat NUMBER NOT NULL,
  lon NUMBER NOT NULL,
  ubicacion SDO_GEOMETRY
);
CREATE TABLE paciente (
  paciente_id NUMBER PRIMARY KEY,
  nombre VARCHAR2(80) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  ciudad_id NUMBER NOT NULL REFERENCES ciudad(ciudad_id)
);
CREATE TABLE atencion (
  atencion_id NUMBER PRIMARY KEY,
  paciente_id NUMBER NOT NULL REFERENCES paciente(paciente_id),
  centro_id NUMBER NOT NULL REFERENCES centro_salud(centro_id),
  diagnostico_id NUMBER NOT NULL REFERENCES diagnostico(diagnostico_id),
  fecha_atencion DATE NOT NULL,
  historia CLOB NOT NULL CONSTRAINT ck_historia_json CHECK (historia IS JSON)
);
EXIT;