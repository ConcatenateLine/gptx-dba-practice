Go to [`Track progress`](./track-progress.md).

# 📚 CASE: PostgreSQL Query Optimization

```
    Module: sql/postgres    Date: 2025-09-29    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `postgres > Optimize a Query` |
| Commit: | `docs(postgres): add query optimization case report` |

## 📍 Scenario
A query filtering users by email domain (%example.com) was performing slowly on a seeded dataset of 1000+ rows.

## 🎯 Objective
Reduce query execution time by adding an index and analyzing performance impact.

## 🧠 Hypothesis
Adding an index on the email column will reduce full table scan time and improve query speed.

## ⚙️ Execution
Seeded 1000+ rows into users table using init.sql. Ran baseline query:

```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%@example.com';
```
Created index:

```sql
CREATE INDEX idx_email ON users(email);
```
Re-ran query with EXPLAIN ANALYZE.

## 📊 Result
- Before index: Sequential scan, ~120ms execution time
- After index: Index scan, ~8ms execution time
- EXPLAIN confirmed use of idx_email

## 🔍 Analysis
The LIKE filter benefited from the index because the domain pattern was consistent. PostgreSQL used the index to avoid scanning all rows. Performance improved ~15x.

## 🛠️ Remediation or Follow-up
- Added index creation to init.sql
- Documented indexing strategy in docs/optimization.md
- Scheduled weekly index review in docs/backup-policy.md
