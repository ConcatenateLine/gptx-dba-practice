Go to [`Track progress`](../../../README.md).

# 📚 CASE: Enable Slow Query Log

```
    Module: MySQL    Date: 2025-10-02    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `mysql > Enable Slow Query Log` |
| Commit: | `docs(mysql): add enable slow query log case report` |

## 📍 Scenario
Enable slow query log to identify and optimize slow queries.

## 🎯 Objective
Enable slow query log and analyze the slow query log.

## 🧠 Hypothesis
Slow query log will help identify and optimize slow queries.

## ⚙️ Execution
1. Modify MySQL config to enable slow query logging
```sql
-- Enable slow query logging
SET GLOBAL slow_query_log = 'ON';

-- Set slow query threshold (e.g., 2 seconds)
SET GLOBAL long_query_time = 2;

-- Confirm settings
SHOW VARIABLES LIKE 'slow_query_log%';
SHOW VARIABLES LIKE 'long_query_time';
```
2. Run a slow query and inspect the log
```sql
SELECT * FROM products WHERE price > 1000;
```
or 
```sql
SELECT SLEEP(3);
```

3. Analyze the slow query log
```sql
SHOW VARIABLES LIKE 'slow_query_log%';
```

Inspect the slow query log file
```bash
docker exec -i gptx_mysql cat /var/lib/mysql/7303b8f6d3b9-slow.log 
## example directory
```

## 📊 Result
Slow query log enabled
- slow_query_log: ON
- slow_query_log_file: /var/lib/mysql/7303b8f6d3b9-slow.log

## 🔍 Analysis
Enabling the slow query log provided a reliable mechanism for capturing and analyzing performance bottlenecks in MySQL. By executing a deliberately slow query (SELECT SLEEP(3)), the system confirmed that:

- Logging was correctly activated and directed to the expected file path.
- The query was captured with precise metadata, including execution time, lock time, and row metrics.
- The log format is structured for downstream parsing and analysis, supporting tools like pt-query-digest or custom audit scripts.

This validates the slow query log as a foundational tool for performance profiling, especially in staging or production environments. It also reinforces the importance of pairing runtime diagnostics with query planning (EXPLAIN ANALYZE) to triangulate root causes and optimize execution paths.

## 🛠️ Remediation or Follow-up

```sql
mysql> SHOW VARIABLES LIKE 'slow_query_log%';
+---------------------+--------------------------------------+
| Variable_name       | Value                                |
+---------------------+--------------------------------------+
| slow_query_log      | ON                                   |
| slow_query_log_file | /var/lib/mysql/7303b8f6d3b9-slow.log |
+---------------------+--------------------------------------+
2 rows in set (0.00 sec)


mysql> SELECT SLEEP(3);
+----------+
| SLEEP(3) |
+----------+
|        0 |
+----------+
1 row in set (3.00 sec)

mysql> exit
Bye
```

```bash
❯ docker exec -i gptx_mysql cat /var/lib/mysql/7303b8f6d3b9-slow.log
/usr/sbin/mysqld, Version: 8.4.6 (MySQL Community Server - GPL). started with:
Tcp port: 3306  Unix socket: /var/run/mysqld/mysqld.sock
Time                 Id Command    Argument
# Time: 2025-10-02T21:02:29.727037Z
# User@Host: root[root] @ localhost []  Id:    13
# Query_time: 3.000516  Lock_time: 0.000000 Rows_sent: 1  Rows_examined: 1
use gptxdb;
SET timestamp=1759438946;
SELECT SLEEP(3);
```