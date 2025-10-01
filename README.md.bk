# 📦 GPTX DBA Practice Workspace

A modular test environment for practicing database administration task. Includes SQL and NoSQL engines, automation scripts, monitoring tools, and governance documentation.


---

## 🧰 Technologies

- PostgreSQL 15
- MySQL 8
- Redis 7
- MongoDB 6
- Adminer (GUI)
- Docker Compose
- Bash & Python scripting

### Modules

- SQL
    - PostgreSQL & MySQL schemas, indexingm user roles
    - Backup & restore scripts
    - Query optimization with EXPLAIN ANALYZE

- NoSQL
    - Redis cache strategies and TTL
    - MongoDB document modeling, indexing, replication sets
 
- Automation
    - backup.sh: daily dumps with timestamp
    - restore.sh: restore from named backup
    - monitor.py: active connection count (PostgreSQL)

- Monitoring
    - Enable slow query logs
    - For configure: Prometheus + Grafana integration


### Folder Structure

```bash
.
├── docker-compose.yml
├── sql/
│   ├── postgres/
│   └── mysql/
├── nosql/
│   ├── redis/
│   └── mongo/
├── scripts/ 
├── docs/ 
└── backup/
```

---

## 🚀 Setup Instructions

### 1. Clone and initialize
```bash
git clone https://github.com/ConcatenateLine/gptx-dba-practice.git
cd gptx-dba-practice
docker compose up -d

# Check status
docker compose ps
```

### 2. Seed databases

```bash
# PostgreSQL
docker exec -i <postgres_container_id> psql -U admin -d gptxdb < sql/postgres/init.sql

# MySQL
docker exec -i <mysql_container_id> mysql -u root -prootpass gptxdb < sql/mysql/init.sql

# Redis
docker exec -i <redis_container_id> bash -c "$(cat nosql/redis/init.sh)"

# MongoDB
docker exec -i <mongo_container_id> mongosh < nosql/mongo/init.js

```

### 📚 Documentation

All governance, optimization, and role strategies are documented in the docs/ folder:

- roles.md: Role-based access control
- backup-policy.md: Backup frequency and restore procedures
- optimization.md: Query tuning tips
- governance.md: Integrity, security, and compliance guidelines

### 🧪 Practice Tasks

- sql/postgres/  [Tasks](./sql/postgres/tasks.md)
- sql/mysql/     [Tasks](./sql/mysql/tasks.md)
- nosql/redis/   [Tasks](./nosql/redis/tasks.md)
- nosql/mongo/   [Tasks](./nosql/mongo/tasks.md)
- scripts/       [Tasks](./scripts/tasks.md)
- docs/          [Tasks](./docs/tasks.md)

### Tracer (solutions/activities) 

[`track-progress.md`](./docs/track-progress.md)

### Connection
This script will open a connection to the database and allow you to interact with it.

Run connection script:
```bash
./utils/connect.sh <module> # <module> can be postgres, mysql, redis, mongo
```

[`connect.sh`](./utils/connect.sh)

### 🧑‍💻 Contributor Notes
This workspace is designed for hands-on DBA skill development and interview preparation. Each module is self-contained and documented for clarity. Feel free to fork, extend, or adapt to your own infrastructure.

