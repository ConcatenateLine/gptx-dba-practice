import psycopg2, os, time
from datetime import datetime

# Use environment variables for flexibility
DB_NAME = os.getenv("DB_NAME", "gptxdb")
DB_USER = os.getenv("DB_USER", "admin")
DB_PASS = os.getenv("DB_PASS", "adminpass")
DB_HOST = os.getenv("DB_HOST", "gptx_postgres")  # Docker service name or container alias


def get_connections_count():
    try:
        conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            host=DB_HOST,
        )
        cur = conn.cursor()
        cur.execute("SELECT count(*) FROM pg_stat_activity;")
        print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] 🔍 Conexiones activas: {cur.fetchone()[0]}")
    except Exception as e:
        print("❌ Error al conectar:", e)
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()



if __name__ == "__main__":
    while True:
        get_connections_count()
        time.sleep(5)
