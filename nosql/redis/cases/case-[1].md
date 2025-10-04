Go to [`Track progress`](../../../README.md).

# 📚 CASE: Simulate Login Cache

```
    Module: nosql/redis    Date: 2025-10-03    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `nosql/redis > Simulate Login Cache` |
| Commit: | `docs(redis): add simulate login cache case report` |

## 📍 Scenario
Simulate a login cache using Redis. Set a key-value pair with a TTL of 600 seconds to mimic a login session. Validate expiration with the `TTL` command.

## 🎯 Objective
Validate expiration of a key-value pair in Redis.

## 🧠 Hypothesis
Use `TTL` to validate expiration of a key-value pair in Redis.

## ⚙️ Execution

1. set a key-value pair with a TTL of 600 seconds to mimic a login session.
```bash
SET session:user:jc "active" EX 600
```

2. validate expiration with the `TTL` command.
```bash
TTL session:user:jc
```
- if the key is expired, the command will return -2
- if the key is not expired, the command will return the remaining time in seconds
- if the key exists but has no expiration, the command will return -1

3. Check if the key exists.
```bash
EXISTS session:user:jc
```

4. Use GET to retrieve the value.
```bash
GET session:user:jc
```

5. Use EXPIRE to update TTL.
```bash
EXPIRE session:user:jc 600
```

6. Use DEL to delete the key.
```bash
DEL session:user:jc
```

## 📊 Result
The commands were executed in order, with the expected results.

- The `SET` command successfully set the key-value pair with a TTL of 600 seconds.
- The `TTL` command returned the remaining time in seconds, validating that the key had not expired.
- The `EXISTS` command returned 1, indicating that the key exists.
- The `GET` command returned the value associated with the key.
- The `EXPIRE` command updated the TTL of the key.
- The `DEL` command deleted the key.

The execution demonstratedstrated the correct use of the `SET`, `TTL`, `EXISTS`, `GET`, `EXPIRE`, and `DEL` commands in Redis.

## 🔍 Analysis
The results of the follow-up section demonstrate the correct use of the `SET`, `TTL`, `EXISTS`, `GET`, `EXPIRE`, and `DEL` commands in Redis.

The key-value pair was successfully set with a TTL of 600 seconds, and the `TTL` command was used to validate that the key had not expired. The `EXISTS` command confirmed that the key exists, and the `GET` command retrieved the value associated with the key. The `EXPIRE` command updated the TTL of the key, and the `DEL` command deleted the key.

The follow-up section also demonstrates the use of the `TTL` command to validate the expiration of a key-value pair in Redis. The command returned the remaining time in seconds, indicating that the key had not expired.


## 🛠️ Remediation or Follow-up

```bash
❯ ./utils/connect.sh redis
✅ 'gptx_redis' is running. Connecting to redis...
127.0.0.1:6379> SET session:user:jc "active" EX 600
OK
127.0.0.1:6379> TTL session:user:jc
(integer) 590
127.0.0.1:6379> GET session:user:jc
"active"
127.0.0.1:6379> EXPIRE session:user:jc 777
(integer) 1
127.0.0.1:6379> TTL session:user:jc
(integer) 770
127.0.0.1:6379> DEL session:user:jc
(integer) 1
127.0.0.1:6379> EXPIRE session:user:jc 777
(integer) 0
127.0.0.1:6379> GET session:user:jc
(nil)
127.0.0.1:6379> TTL session:user:jc
(integer) -2
127.0.0.1:6379> EXISTS session:user:jc
(integer) 0
127.0.0.1:6379> exit
```
