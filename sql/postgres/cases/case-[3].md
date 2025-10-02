Go to [`Track progress`](./track-progress.md).

# 📚 CASE: Simulate Backup and Restore

```
    Module: PostgreSQL    Date: 2025-10-01    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `postgres > Simulate Backup and Restore` |
| Commit: | `docs(postgres): add Simulate Backup and Restore case report` |

## 📍 Scenario
This simulates a production recovery where the users table is accidentally dropped and must be restored from a recent backup.

## 🎯 Objective
Validate that the backup and restore workflow works as expected.

## 🧠 Hypothesis
The backup and restore workflow will work as expected.

## ⚙️ Execution
Run the backup script, drop the users table, and restore from backup.

```bash
./backup.sh
```

```sql
DROP TABLE users;
```

```bash
./restore.sh
```

## 📊 Result
The backup and restore workflow worked as expected.

## 🔍 Analysis

The sequence involved dropping the users table, which simulates an accidental deletion. After restoring from backup, the table was successfully recovered, and the row count was validated to be the same as before the drop. This demonstrates the effectiveness of the backup and restore workflow in recovering from data loss due to accidental deletion.

## 🛠️ Remediation or Follow-up

```sql

❯ ./scripts/backup.sh
mysqldump: [Warning] Using a password on the command line interface can be insecure.

❯ ./utils/connect.sh postgres
✅ 'gptx_postgres' is running. Connecting to postgres...
psql (15.13 (Debian 15.13-1.pgdg120+1))
Type "help" for help.

gptxdb=# DROP TABLE users;
DROP TABLE
gptxdb=# SELECT * FROM users;
ERROR:  relation "users" does not exist
LINE 1: SELECT * FROM users;
                      ^
gptxdb=# exit

❯ 
./scripts/restore.sh 2025-10-01
SET
 set_config 
------------
 
(1 row)

SET
CREATE EXTENSION
COMMENT
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 1201
 setval 
--------
   1201
(1 row)

ALTER TABLE
CREATE INDEX
GRANT
mysql: [Warning] Using a password on the command line interface can be insecure.

❯ ./utils/connect.sh postgres
✅ 'gptx_postgres' is running. Connecting to postgres...
psql (15.13 (Debian 15.13-1.pgdg120+1))
Type "help" for help.

gptxdb=# SELECT COUNT(id) from users;
 count 
-------
  1201
(1 row)

gptxdb=# exit

```
