import argparse
import math
import random
import statistics
import time
from concurrent.futures import ThreadPoolExecutor

SQL_ORACLE = """
SELECT a.atencion_id, p.nombre, d.codigo, d.nombre, c.nombre, a.fecha_atencion
FROM atencion a
JOIN paciente p ON a.paciente_id = p.paciente_id
JOIN diagnostico d ON a.diagnostico_id = d.diagnostico_id
JOIN centro_salud c ON a.centro_id = c.centro_id
WHERE a.atencion_id = :1
"""

SQL_STD = """
SELECT a.atencion_id, p.nombre, d.codigo, d.nombre, c.nombre, a.fecha_atencion
FROM atencion a
JOIN paciente p ON a.paciente_id = p.paciente_id
JOIN diagnostico d ON a.diagnostico_id = d.diagnostico_id
JOIN centro_salud c ON a.centro_id = c.centro_id
WHERE a.atencion_id = %s
"""

def crear_conexion(motor):
    if motor == "oracle":
        import oracledb
        return oracledb.connect(user="saludlab", password="admin123", dsn="localhost:1521/FREEPDB1")
    elif motor == "mysql":
        import mysql.connector
        return mysql.connector.connect(
            host="127.0.0.1", port=3306, user="root", password="admin123",
            database="saludlab", autocommit=False
        )
    elif motor == "postgres":
        import psycopg
        return psycopg.connect(
            "host=127.0.0.1 port=5432 dbname=saludlab user=postgres password=admin123",
            autocommit=False
        )

def ejecutar_carga(motor, usuarios, ops_por_usuario):
    sql = SQL_ORACLE if motor == "oracle" else SQL_STD
    conexiones = [crear_conexion(motor) for _ in range(usuarios)]

    def worker(idx):
        conn = conexiones[idx]
        cur = conn.cursor()
        rng = random.Random(1000 + idx)
        tiempos = []
        for _ in range(ops_por_usuario):
            aid = rng.randint(1, 100000)
            param = [aid] if motor == "oracle" else (aid,)
            t0 = time.perf_counter()
            cur.execute(sql, param)
            cur.fetchall()
            conn.commit()
            t1 = time.perf_counter()
            tiempos.append((t1 - t0) * 1000.0)
        cur.close()
        return tiempos

    inicio = time.perf_counter()
    latencias = []
    with ThreadPoolExecutor(max_workers=usuarios) as pool:
        for res in pool.map(worker, range(usuarios)):
            latencias.extend(res)
    fin = time.perf_counter()

    for c in conexiones:
        c.close()
    time.sleep(3)

    total_ops = usuarios * ops_por_usuario
    tps = total_ops / (fin - inicio)
    latencias.sort()
    idx_p95 = max(0, math.ceil(0.95 * len(latencias)) - 1)
    p95 = latencias[idx_p95]
    return tps, p95

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--motor", required=True, choices=["oracle", "mysql", "postgres"])
    args = parser.parse_args()

    print(f"\n=== EXPERIMENTO E3: {args.motor.upper()} ===")
    print("Calentando cache (20 usuarios x 15 tx)...")
    ejecutar_carga(args.motor, 20, 15)

    resumen = []
    for usuarios in (10, 50, 100):
        ops_por_usuario = max(10, 1000 // usuarios)
        tps_lista, p95_lista = [], []
        print(f"\n--- Concurrencia: {usuarios} usuarios ({usuarios * ops_por_usuario} tx/corrida) ---")
        for corrida in range(1, 4):
            tps, p95 = ejecutar_carga(args.motor, usuarios, ops_por_usuario)
            tps_lista.append(tps)
            p95_lista.append(p95)
            print(f"  Corrida {corrida}: TPS = {tps:.2f} | Latencia p95 = {p95:.3f} ms")
        resumen.append((
            usuarios,
            statistics.mean(tps_lista), statistics.stdev(tps_lista),
            statistics.mean(p95_lista), statistics.stdev(p95_lista)
        ))

    print("\n=== RESUMEN FINAL E3 ===")
    print("Usuarios | TPS Promedio | TPS DE  | p95 Promedio (ms) | p95 DE (ms)")
    for u, tps_m, tps_sd, p95_m, p95_sd in resumen:
        print(f"{u:8d} | {tps_m:12.2f} | {tps_sd:7.2f} | {p95_m:17.3f} | {p95_sd:11.3f}")

if __name__ == "__main__":
    main()
