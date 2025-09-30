# Query Optimization Guide

This guide helps identify and resolve performance bottlenecks.

## PostgreSQL / MySQL

### Tools
- `EXPLAIN`, `ANALYZE`
- Index usage and cardinality
- Query cache (MySQL)

### Tips
- Avoid `SELECT *`
- Use covering indexes
- Normalize where appropriate
- Profile joins and subqueries

## MongoDB

### Tools
- `explain()`
- Index hints

### Tips
- Use compound indexes
- Avoid `$where` and regex on large datasets
- Use projection to limit fields

## Redis

### Tips
- Use appropriate data types (`SET`, `HASH`, `ZSET`)
- Avoid large keys or values
- Use TTL for ephemeral data

## Monitoring
- Enable slow query logs
- Track cache hit/miss ratio
- Use Grafana dashboards for live metrics

