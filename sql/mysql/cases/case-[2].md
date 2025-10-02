Go to [`Track progress`](../../../README.md).

# 📚 CASE: Profile a Query

```
    Module: MySQL    Date: 2025-10-02    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `mysql > Profile a Query` |
| Commit: | `docs(mysql): add profile a query case report` |

## 📍 Scenario
Insert sample products with varying prices and run a query to find products above $1000.

## 🎯 Objective
Improve query performance using indexing.

## 🧠 Hypothesis
Adding an index on `price` will reduce scan time.

## ⚙️ Execution
Analyze the query performance before and after adding the index.

```sql
-- Generate 1000+ rows with dummy data
INSERT INTO products (name, price)
SELECT
  CONCAT('Product_', i),
  IF(i % 2 = 0, i * 100, i * 200)
FROM (
  SELECT i FROM (
    WITH RECURSIVE seq(i) AS (
      SELECT 1
      UNION ALL
      SELECT i + 1 FROM seq WHERE i < 1000
    )
    SELECT i FROM seq
  ) AS inner_seq
) AS final_seq;

EXPLAIN ANALYZE SELECT * FROM products WHERE price > 1000;
```

```sql
CREATE INDEX idx_price ON products(price);
EXPLAIN ANALYZE SELECT * FROM products WHERE price > 1000;
```
## 📊 Result
Query 1: SELECT * FROM products WHERE price BETWEEN 1000 AND 200000
- Access method: Full table scan
- Rows matched: 2979 out of 2997
- Execution time: ~1.34s
- Optimizer decision: Index not used due to low selectivity

Query 2: SELECT * FROM products FORCE INDEX (idx_price) WHERE price BETWEEN 1000 AND 200000
- Access method: Index range scan using idx_price
- Rows matched: 2979
- Execution time: ~4.72s

Optimizer override: Index was used, but performance degraded

## 🔍 Analysis
Index usage is not always faster — especially when filters match most rows.
EXPLAIN ANALYZE is essential for validating optimizer decisions and understanding real performance.
Best practice: Use indexes for high-selectivity filters, and avoid forcing index usage unless profiling shows consistent gains.

## 🛠️ Remediation or Follow-up

```sql
❯ ./utils/connect.sh mysql
✅ 'gptx_mysql' is running. Connecting to mysql...
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.4.6 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> INSERT INTO products (name, price)SELECT  CONCAT('Product_', i),  IF(i % 2 = 0, i * 100, i * 200)FROM (  SELECT i FROM (    WITH RECURSIVE seq(i) AS (      SELECT 1      UNION ALL      SELECT i + 1 FROM seq WHERE i < 999    )    SELECT i FROM seq  ) AS inne
r_seq) AS final_seq;
Query OK, 999 rows affected (0.06 sec)
Records: 999  Duplicates: 0  Warnings: 0

mysql> EXPLAIN ANALYZE SELECT * FROM products WHERE price BETWEEN 1000 AND 200000;
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                 |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Filter: (products.price between 1000 and 200000)  (cost=302 rows=2979) (actual time=0.217..1.34 rows=2979 loops=1)
    -> Table scan on products  (cost=302 rows=2997) (actual time=0.213..0.969 rows=2997 loops=1)
 |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> EXPLAIN ANALYZE SELECT * FROM products FORCE INDEX (idx_price)  WHERE price BETWEEN 1000 AND 200000;
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Index range scan on products using idx_price over (1000.00 <= price <= 200000.00), with index condition: (products.price between 1000 and 200000)  (cost=0.71 rows=1) (actual time=0.0339..4.72 rows=2979 loops=1)
 |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> Exit; 
```
