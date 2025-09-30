Go to [`Track progress`](./track-progress.md).

# 📚 CASE: [Short Title Here]

```
    Module: [Module]    Date: [Date]    Status: [Status]
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | [`Related Task`] |
| Commit: | [`Commit`] |

## 📍 Scenario
Briefly describe the situation or problem you're addressing.  
Example: A query on the `users` table is slow when filtering by email domain.

## 🎯 Objective
What are you trying to achieve or validate?  
Example: Improve query performance using indexing.

## 🧠 Hypothesis
What do you expect will happen?  
Example: Adding an index on `email` will reduce scan time.

## ⚙️ Execution
List the commands, scripts, or queries you ran. Use code blocks for clarity.

```sql
CREATE INDEX idx_email ON users(email);
EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%@example.com';
```

## 📊 Result
Summarize the output, logs, or metrics. Example: Execution time dropped from 120ms to 8ms. Index scan replaced full table scan.

## 🔍 Analysis
Why did it work (or not)? What did you learn? Example: The index helped because the query used a filter on an indexed column.

## 🛠️ Remediation or Follow-up
What changes did you make or document? Example: Added index strategy to docs/optimization.md. Scheduled weekly index review.
