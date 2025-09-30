Go to [`track-progress.md`](../../docs/track-progress.md) to see your progress.

# MongoDB Practice Tasks

## [ ] 1. Create a Replica Set (Local)
- Add replica set config to `docker-compose.yml`
- Initiate with `rs.initiate()`
- Validate with `rs.status()`

## [ ] 2. Model Nested Documents
- Insert a user with nested address and preferences
- Query with dot notation

## [ ] 3. Profile a Query
- Use `explain()` on a query with and without index
- Add compound index and compare performance

## [ ] 4. Simulate Sharding (Optional)
- Add multiple Mongo containers
- Configure sharding with `mongos`
