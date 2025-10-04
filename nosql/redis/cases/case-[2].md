Go to [`Track progress`](../../../README.md).

# 📚 CASE: Use Hashes for Product Info

```
    Module: nosql/redis    Date: 2025-10-03    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `nosql/redis > Use Hashes for Product Info` |
| Commit: | `docs(redis): add use hashes for product info case report` |

## 📍 Scenario
Simulate structured product storage using Redis hashes. The goal is to store and manipulate product metadata like name, price, and stock using hash operations.

## 🎯 Objective
Validate the use of Redis hashes (HSET, HGETALL) for storing and retrieving product information. Confirm field-level access, updates, and deletion.

## 🧠 Hypothesis
Redis hashes should allow efficient storage and retrieval of structured product data. Field updates and deletions should reflect immediately in the hash.

## ⚙️ Execution
1. Create `product:1` with `HSET`
```bash
HSET product:1 name "Product 1" price 10.99 stock 42
```

2. Retrieve with `HGETALL`
```bash
HGETALL product:1
```

3. Get a single field with `HGET`
```bash
HGET product:1 price
```

4. Get multiple fields with `HMGET`
```bash
HMGET product:1 name price
```

5. Check field existence with `HEXISTS`
```bash
HEXISTS product:1 name
```

6. Update a field with `HSET`
```bash
HSET product:1 price 19.99
```

7. Delete a field with `HDEL`
```bash
HDEL product:1 price
```

8. Delete the hash with `DEL`
```bash
DEL product:1
```

## 📊 Result
- HSET created product:1 with fields: name, price, stock.
- HGETALL returned all fields correctly.
- HGET confirmed individual field access.
- HEXISTS validated presence (name) and absence (names) of fields.
- HSET updated price from 10.99 to 19.99.
- HDEL removed price field.
- Final DEL removed the entire hash.
- Post-deletion HGETALL returned an empty array.

## 🔍 Analysis
- Redis hashes behave like lightweight structured objects.
- Field updates (HSET) and deletions (HDEL) are atomic and reflected immediately.
- HEXISTS is useful for validating schema assumptions.
- DEL cleanly removes the entire hash, and HGETALL confirms absence.
- This pattern is ideal for product catalogs, user profiles, or config maps where field-level access is needed.

## 🛠️ Remediation or Follow-up

```bash
❯ ./utils/connect.sh redis
✅ 'gptx_redis' is running. Connecting to redis...
127.0.0.1:6379> HSET product:1 name "Product 1" price 10.99 stock 42
(integer) 1
127.0.0.1:6379> HGETALL product:1
1) "name"
2) "Product 1"
3) "price"
4) "10.99"
5) "stock"
6) "42"
127.0.0.1:6379> HGET product:1 name
"Product 1"
127.0.0.1:6379> HGET product:1 price
"10.99"
127.0.0.1:6379> HEXISTS product:1 name
(integer) 1
127.0.0.1:6379> HEXISTS product:1 names
(integer) 0
127.0.0.1:6379> HSET product:1 price 19.99
(integer) 0
127.0.0.1:6379> HGETALL product:1
1) "name"
2) "Product 1"
3) "price"
4) "19.99"
5) "stock"
6) "42"
127.0.0.1:6379> HDEL product:1 price
(integer) 1
127.0.0.1:6379> HGETALL product:1
1) "name"
2) "Product 1"
3) "stock"
4) "42"
127.0.0.1:6379> DEL product:1
(integer) 1
127.0.0.1:6379> HGETALL product:1
(empty array)
127.0.0.1:6379> exit
```

