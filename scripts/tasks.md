Go to [`track-progress.md`](../README.md) to see your progress.

# Automation & Monitoring Tasks

## [ ] 1. Validate Backup Script
- Run `backup.sh` for each engine
- Confirm timestamped files appear in `backup/`
- Check file size and format (e.g. `.sql`, `.bson`, `.rdb`)

## [ ] 2. Simulate Restore Workflow
- Drop a table or collection manually
- Run `restore.sh` with matching timestamp
- Validate data integrity post-restore

## [ ] 3. Monitor PostgreSQL Connections
- Run `monitor.py` and log output
- Open multiple `psql` sessions to simulate load
- Confirm connection count increases

## [ ] 4. Add Logging to Scripts
- Modify `backup.sh` and `restore.sh` to log actions:
  ```bash
  echo "[INFO] Backup started at $(date)" >> backup.log

## [ ] 5. Simulate Cron-Based Automation
- Create a mock cron.txt:

    ```bash
    cron
    0 2 * * * /workspace/scripts/backup.sh >> /workspace/logs/cron.log 2>&1
    ```

- Run manually with:

    ```bash
    bash scripts/backup.sh >> logs/cron.log 2>&1
    ```

## [ ] 6. Add Error Handling
- Update scripts to exit on failure:

    ```bash
    set -e
    ```

## [ ] 7. Optional: Add Email Notification (Local)
- Use mail or sendmail to notify on backup success/failure
- Simulate with a local SMTP container or log to file