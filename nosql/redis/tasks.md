Go to [`track-progress.md`](../../docs/track-progress.md) to see your progress.

# Redis Practice Tasks

## [ ] 1. Simulate Login Cache
- Set `session:user:jc` with TTL of 600 seconds
- Validate expiration with `TTL`

## [ ] 2. Use Hashes for Product Info
- Create `product:1` with `HSET`
- Retrieve with `HGETALL`

## [ ] 3. Monitor Keyspace
- Use `INFO` to inspect memory usage and key count
- Simulate cache eviction with `maxmemory-policy`

## [ ] 4. Automate Cleanup
- Write a Bash script to delete expired keys
- Schedule with `cron` or simulate manually
