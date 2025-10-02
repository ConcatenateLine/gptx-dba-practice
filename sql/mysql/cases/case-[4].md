Go to [`Track progress`](../../../README.md).

# 📚 CASE: Test Backup/Restore

```
    Module: MySQL    Date: 2025-10-02    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `mysql > Test Backup/Restore` |
| Commit: | `docs(mysql): add test backup/restore case report` |

## 📍 Scenario
Test backup and restore process.

## 🎯 Objective
Realize backup and restore process.

## 🧠 Hypothesis
Backup and restore process will work as expected.

## ⚙️ Execution
1. Run backup script
2. Run restore script

```bash
./scripts/backup.sh
./scripts/restore.sh
```

3. Validate data integrity after restore

```bash
docker exec -i gptx-mysql -u root -e "SELECT COUNT(*) FROM products;"
```

## 📊 Result
Backup and restore process will work as expected.

## 🔍 Analysis
Backup and restore process will work as expected.

## 🛠️ Remediation or Follow-up
```sql
❯ ./scripts/backup.sh
mysqldump: [Warning] Using a password on the command line interface can be insecure.

❯ ./utils/connect.sh mysql
✅ 'gptx_mysql' is running. Connecting to mysql...
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 20
Server version: 8.4.6 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SELECT count(id) FROM products;
+-----------+
| count(id) |
+-----------+
|       999 |
+-----------+
1 row in set (0.00 sec)

mysql> DROP TABLE products;
Query OK, 0 rows affected (0.04 sec)

mysql> SELECT count(id) FROM products;
ERROR 1146 (42S02): Table 'gptxdb.products' doesn't exist
```

```bash
❯ ./scripts/restore.sh 2025-10-02
SET
 set_config 
------------
 
(1 row)

SET
CREATE EXTENSION
COMMENT
SET
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
GRANT
mysql: [Warning] Using a password on the command line interface can be insecure.


❯ ./utils/connect.sh mysql
✅ 'gptx_mysql' is running. Connecting to mysql...
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 22
Server version: 8.4.6 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SELECT count(id) FROM products;
+-----------+
| count(id) |
+-----------+
|       999 |
+-----------+
1 row in set (0.00 sec)

mysql> exit; 
```

