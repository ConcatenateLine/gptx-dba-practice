Go to [`Track progress`](../../../README.md).

# 📚 CASE: Automate Cleanup

```
    Module: nosql/redis    Date: 2025-10-03    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | [`nosql/redis > Automate Cleanup`] |
| Commit: | [`docs(redis): add automate cleanup case report`] |

## 📍 Scenario
Redis keys with short TTLs are simulated to test automated cleanup. A host-based cron job runs a Bash script that scans for keys nearing expiration and deletes them proactively.

## 🎯 Objective
Validate a scheduled cleanup mechanism using cron and redis-cli to remove keys with TTL under a threshold. Confirm automation via log inspection and TTL decay simulation.

## 🧠 Hypothesis
Keys with TTL under 60 seconds should be detected and deleted by the script. Cron should execute reliably every 5 minutes, and logs should reflect cleanup activity.

## ⚙️ Execution
1. Write a Bash script to delete expired keys
[`Cleanup script` ](../../../scripts/cleanup.sh)

2. Schedule with `cron` or simulate manually
Manual run:
```bash
docker exec -it gptx_redis bash -c "./scripts/cleanup.sh"
```

Cron job(Every 5 minutes):
```bash
# Add this line to crontab
*/5 * * * * docker exec gptx_redis bash /cleanup.sh
```

## 📊 Result
- Cron executed successfully every 5 minutes.
- Log entries confirmed deletion of keys with TTL under threshold:

```bash
Sat Oct  4 05:47:57 UTC 2025: Deleting cache:test with TTL 26
Sat Oct  4 05:48:10 UTC 2025: Deleting cache:testa with TTL 22
Sat Oct  4 05:57:13 UTC 2025: Deleting cache:test with TTL 33
Sat Oct  4 05:57:27 UTC 2025: Deleting cache:testa with TTL 14
```

- TTL decay and deletion timing aligned with expectations.
- No errors or permission issues in cron or script execution.

## 🔍 Analysis
- Host-based cron is reliable and avoids container complexity.
- TTL-based filtering ensures only near-expired keys are targeted.
- --scan avoids blocking and scales well for large keyspaces.
- Log output provides traceability and audit trail for cleanup actions.
- Redis handles TTL expiration natively, but this script adds proactive control.

## 🛠️ Remediation or Follow-up
```bash
## Copy script to Redis container
❯ docker cp ./scripts/cleanup.sh gptx_redis:/cleanup.sh

Successfully copied 2.05kB to gptx_redis:/cleanup.sh

## Set a key with TTL
❯ docker exec gptx_redis redis-cli SET cache:test "temp" EX 50

OK

## Run script
❯ docker exec gptx_redis bash /cleanup.sh

Deleting cache:test with TTL 30
1 

## Cron job(Every 1 minute for test)
## On host based
```bash
❯ crontab -e
no crontab for ubuntuuser - using an empty one

Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano        <---- easiest
  2. /usr/bin/vim.basic
  3. /usr/bin/vim.tiny
  4. /usr/bin/kiro
  5. /bin/ed

Choose 1-5 [1]: 1 
crontab: installing new crontab

# Add this line
*/1 * * * * docker exec gptx_redis bash /cleanup.sh

# Save and exit

## Set a key with TTL
❯ docker exec gptx_redis redis-cli SET cache:test "temp" EX 50

OK
```

Enable cron service:
```bash
❯ sudo systemctl enable cron
Synchronizing state of cron.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable cron

❯ sudo systemctl start cron

❯ sudo systemctl status cron
● cron.service - Regular background program processing daemon
     Loaded: loaded (/usr/lib/systemd/system/cron.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-10-02 09:23:56 CST; 1 day 14h ago

Oct 03 23:25:01 Device-line CRON[73854]: (CRON) info (No MTA installed, discarding outp>
lines 1-12

❯ 
```