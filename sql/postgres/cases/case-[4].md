Go to [`Track progress`](./track-progress.md).

# 📚 CASE: Monitor Connections

```
    Module: sql/postgres    Date: 2025-10-01    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `postgres > Monitor Connections` |
| Commit: | `docs(postgres): add monitor connections case report` |

## 📍 Scenario
Simulate load with multiple `psql` sessions.

## 🎯 Objective
Monitor active connections and simulate load.

## 🧠 Hypothesis
Monitoring active connections is important to ensure database performance and scalability. As the number of active connections increases, the database may experience increased latency and memory usage. By monitoring active connections, we can identify potential bottlenecks and take proactive measures to optimize database performance.

## ⚙️ Execution
Simulate load with multiple `psql` sessions:

run monitoring script:

```bash
python scripts/monitor.py

# The monitoring was implmented as a service in docker-compose.yml
```

Simulate load with multiple `psql` sessions:
Open multiple `psql` sessions in different terminal windows:

```bash
docker exec -it gptx_postgres psql -U admin -d gptxdb
```
repeat 3 - 5 times to simulate concurrent users.

Re-run monitoring script:

```bash
python scripts/monitor.py

# The monitoring was implmented as a service in docker-compose.yml
```
Observe connections count increase. Optionally lig timestamps and counts.

## 📊 Result
- The monitoring was implmented as a service in docker-compose.yml
- The monitoring script was run in a separate terminal window
- The connections count increased as expected

## 🔍 Analysis
The monitoring was implmented as a service in docker-compose.yml for easy access and monitoring. This allowed us to monitor the number of active connections and identify potential bottlenecks.

## 🛠️ Remediation or Follow-up
- The monitoring was implmented as a service in docker-compose.yml
- The script was refactored to use environment variables for flexibility and logging for debugging.
- The script was scheduled to run every 5 seconds.

```bash
# Monitoring service output

[2025-10-02 04:27:54] 🔍 Conexiones activas: 8

[2025-10-02 04:27:59] 🔍 Conexiones activas: 8

[2025-10-02 04:28:04] 🔍 Conexiones activas: 8

[2025-10-02 04:28:09] 🔍 Conexiones activas: 8

[2025-10-02 04:28:14] 🔍 Conexiones activas: 7

[2025-10-02 04:28:19] 🔍 Conexiones activas: 7

[2025-10-02 04:28:24] 🔍 Conexiones activas: 6

[2025-10-02 04:28:29] 🔍 Conexiones activas: 6

[2025-10-02 04:28:34] 🔍 Conexiones activas: 6

[2025-10-02 04:28:39] 🔍 Conexiones activas: 6
```
