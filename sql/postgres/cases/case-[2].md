Go to [`Track progress`](./../../../README.md).

# 📚 CASE: Optimize a Query

```
    Module: PostgreSQL    Date: 2025-10-01    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `postgres > Optimize a Query` |
| Commit: | `docs(postgres): add Optimize a Query case report` |

## 📍 Scenario
The users table contains over 1000 records. A reporting query using a wildcard email filter (LIKE '%@example.com') is performing slowly. 

## 🎯 Objective
The goal is to analyze and improve query performance using indexing strategies.

## 🧠 Hypothesis
Adding an index on `email` will reduce scan time.

## ⚙️ Execution
List the commands, scripts, or queries you ran. Use code blocks for clarity.

```sql
-- Generate 1000+ rows with dummy emails
DO $$
BEGIN
  FOR i IN 1..1200 LOOP
    INSERT INTO users (username, email)
    VALUES (
      'User_' || i,
      CASE WHEN i % 2 = 0 THEN 'user_' || i || '@example.com'
           ELSE 'user_' || i || '@other.com'
      END
    );
  END LOOP;
END $$;

-- Run the slow query
SELECT * FROM users WHERE email LIKE '%@example.com';

-- Analyze the query plan
EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%@example.com';

-- Add index
CREATE INDEX idx_email ON users(email);

-- Run the slow query again
SELECT * FROM users WHERE email LIKE '%@example.com';

-- Analyze the query plan
EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%@example.com';
```

## 📊 Result
Before Index: Sequential scan with high cost and latency.

After Index: Index scan may still fallback to seq scan due to leading wildcard, but planner may optimize differently.

## 🔍 Analysis
Indexing is not always the solution for all types of queries. In this case, the leading wildcard in the LIKE pattern prevents the index from being used effectively.

## 🛠️ Remediation or Follow-up
```sql
❯ 
./utils/connect.sh postgres
✅ 'gptx_postgres' is running. Connecting to postgres...
psql (15.13 (Debian 15.13-1.pgdg120+1))
Type "help" for help.

gptxdb=# DO $$
BEGIN
  FOR i IN 1..1200 LOOP
    INSERT INTO users (username, email)
    VALUES (
      'User_' || i,
      CASE WHEN i % 2 = 0 THEN 'user_' || i || '@example.com'
           ELSE 'user_' || i || '@other.com'
      END
    );
  END LOOP;
END $$;
DO
gptxdb=# SELECT * FROM users WHERE email LIKE '%@example.com';
gptxdb=# EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%@example.com';
                                             QUERY PLAN                                              
-----------------------------------------------------------------------------------------------------
 Seq Scan on users  (cost=0.00..26.01 rows=631 width=41) (actual time=0.007..0.170 rows=600 loops=1)
   Filter: ((email)::text ~~ '%@example.com'::text)
   Rows Removed by Filter: 601
 Planning Time: 0.225 ms
 Execution Time: 0.211 ms
(5 rows)

gptxdb=# CREATE INDEX idx_email ON users(email);
CREATE INDEX
gptxdb=# SELECT * FROM users WHERE email LIKE '%@example.com';
gptxdb=# EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%@example.com';
                                             QUERY PLAN                                              
-----------------------------------------------------------------------------------------------------
 Seq Scan on users  (cost=0.00..26.01 rows=631 width=41) (actual time=0.008..0.209 rows=600 loops=1)
   Filter: ((email)::text ~~ '%@example.com'::text)
   Rows Removed by Filter: 601
 Planning Time: 0.052 ms
 Execution Time: 0.235 ms
(5 rows)

gptxdb=# EXIT;
```

