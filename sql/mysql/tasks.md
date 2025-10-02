Go to [`track-progress.md`](../../README.md) to see your progress.

# MySQL Practice Tasks

## [ ] 1. Create a Developer Role
- Create `dev_user` with access to `products`
- Restrict schema changes

## [ ] 2. Profile a Query
- Insert sample products with varying prices
- Run: `SELECT * FROM products WHERE price > 1000`
- Add index on `price`, compare `EXPLAIN`

## [ ] 3. Enable Slow Query Log
- Modify MySQL config to enable slow query logging
- Run a slow query and inspect the log

## [ ] 4. Test Backup/Restore
- Use `backup.sh` and `restore.sh`
- Validate data integrity after restore
