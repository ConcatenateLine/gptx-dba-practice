Go to [`track-progress.md`](../../README.md) to see your progress.

# PostgreSQL Practice Tasks

## [ ] 1. Create a Role with Limited Access
- Create a `reporting_user` role with read-only access to `users`
- Validate with `\du` and `\z`

## [ ] 2. Optimize a Query
- Insert 1000+ rows into `users`
- Run a slow query: `SELECT * FROM users WHERE email LIKE '%@example.com'`
- Add an index and compare `EXPLAIN ANALYZE` before/after

## [ ] 3. Simulate Backup and Restore
- Run `backup.sh`
- Drop the `users` table
- Restore from backup and validate row count

## [ ] 4. Monitor Connections
- Use `monitor.py` to count active connections
- Simulate load with multiple `psql` sessions
