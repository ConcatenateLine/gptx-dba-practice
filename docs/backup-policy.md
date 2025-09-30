# Backup and Recovery Policy

This policy defines backup frequency, retention, and recovery procedures.

## PostgreSQL / MySQL

### Daily Backup
- Full dump using `pg_dump` and `mysqldump`
- Stored in `/backup/YYYY-MM-DD.sql`

### Retention
- Keep last 7 daily backups
- Archive weekly snapshots for 1 month

### Restore Procedure
```bash
psql -U admin gptxdb < backup/postgres_2025-09-29.sql
```

## MongoDB

Use `mongodump` and `mongorestore` for backups and restores.

```bash
mongodump --db gptxdb --out backup/mongo_2025-09-29

mongorestore --db gptxdb backup/mongo_2025-09-29
```

## Redis

Use SAVE or BGSAVE, and persist dump.rdb

Notes:
- Automate with cron or systemd timers
- Validate backups weekly with test restores

