CREATE DATABASE IF NOT EXISTS saludlab;
USE saludlab;

CREATE TABLE ciudad (
  ciudad_id INT PRIMARY KEY,
  nombre VARCHAR(60) NOT NULL
);
CREATE TABLE diagnostico (
  diagnostico_id INT PRIMARY KEY,
  codigo VARCHAR(10) NOT NULL,
  nombre VARCHAR(80) NOT NULL
);
CREATE TABLE centro_salud (
  centro_id INT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  ciudad_id INT NOT NULL,
  ubicacion POINT NOT NULL,
  FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id)
);
CREATE TABLE paciente (
  paciente_id INT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  ciudad_id INT NOT NULL,
  FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id)
);
CREATE TABLE atencion (
  atencion_id INT PRIMARY KEY,
  paciente_id INT NOT NULL,
  centro_id INT NOT NULL,
  diagnostico_id INT NOT NULL,
  fecha_atencion DATE NOT NULL,
  historia JSON NOT NULL,
  FOREIGN KEY (paciente_id) REFERENCES paciente(paciente_id),
  FOREIGN KEY (centro_id) REFERENCES centro_salud(centro_id),
  FOREIGN KEY (diagnostico_id) REFERENCES diagnostico(diagnostico_id)
);