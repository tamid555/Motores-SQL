# Comparativa de motores SQL: PostgreSQL 18 vs MySQL 9.7 vs Oracle 26ai Free
Escenario C (salud publica). Universidad Simon Bolivar, Cucuta.

## Archivos
- `pg_*.sql`: esquema 3FN, datos sinteticos (100 000 atenciones), E1, E4 y exportacion a CSV (PostgreSQL)
- `my_*.sql`: esquema, carga de CSV, E1 y E4 (MySQL)
- `or_*.sql` y `*.ctl`: usuario, tablas, carga con SQL*Loader, E1 y E4 (Oracle)
- `e3_concurrencia.py`: carga concurrente con 10, 50 y 100 usuarios
- `res_*.txt`: salidas de E3 y E4

## Laboratorio (Docker, un contenedor encendido a la vez)
```bash
docker run -d --name pgis18 --memory=2g --cpus=2 -e POSTGRES_PASSWORD=admin123 -p 5432:5432 -v pgisdata:/var/lib/postgresql postgis/postgis:18-3.6
docker run -d --name mysql97 --memory=2g --cpus=2 -e MYSQL_ROOT_PASSWORD=admin123 -p 3307:3306 -v mysqldata:/var/lib/mysql mysql:9.7
docker run -d --name oracle26ai --memory=2g --cpus=2 -e ORACLE_PWD=admin123 -p 1521:1521 -v oradata:/opt/oracle/oradata container-registry.oracle.com/database/free:latest
```
Se uso la imagen de PostGIS porque la guia exige PostGIS. E3 en MySQL se ejecuto en un contenedor temporal (mysql97_e3, mismo volumen, 2 GB y 2 CPUs, puerto 3306).

## Reproduccion
1. Ejecutar `pg_01_datos.sql` en PostgreSQL y exportar con `pg_06_export.sql`.
2. Cargar los CSV en MySQL (`my_01`, `my_02`) y Oracle (`or_01`, `or_02`, `*.ctl`).
3. E1: `pg_02`/`my_04`/`or_03` antes y despues del indice (1 corrida de calentamiento y 3 medidas).
4. E2: dos sesiones simultaneas (psql, mysql, sqlplus) sobre `atencion_id` 1 y 2.
5. E3: `python e3_concurrencia.py --motor postgres|mysql|oracle`.
6. E4: `pg_05_e4`, `my_06_e4`, `or_05_e4`.

## Limitaciones
E3 en Oracle no completo las corridas 2 y 3 con 100 usuarios (ORA-12516). Ver `res_oracle_e3_consola.txt`.

## Uso de IA
Se uso un asistente de IA para guiar el montaje, generar scripts y redactar borradores. Los datos son las salidas reales de los motores.
