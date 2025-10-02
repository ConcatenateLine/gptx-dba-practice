import psycopg2

conn = psycopg2.connect(dbname="gptxdb", user="admin", password="adminpass")
cur = conn.cursor()
cur.execute("SELECT count(*) FROM pg_stat_activity;")
print("Conexiones activas:", cur.fetchone()[0])

