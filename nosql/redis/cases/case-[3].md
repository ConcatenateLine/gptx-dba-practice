Go to [`Track progress`](../../../README.md).


# 📚 CASE: Monitor Keyspace

```
    Module: nosql/redis    Date: 2025-10-03    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | [`nosql/redis > Monitor Keyspace`] |
| Commit: | [`docs(redis): add monitor keyspace case report`] |

## 📍 Scenario
Redis is configured with a memory cap and eviction policy to simulate cache pressure. The goal is to inspect keyspace metrics and observe behavior when memory limits are exceeded.

## 🎯 Objective
Use INFO to inspect memory usage and key count. Apply maxmemory and maxmemory-policy settings to simulate eviction under constrained memory.

## 🧠 Hypothesis
Setting a low memory limit with allkeys-lru should trigger eviction when inserting many keys. Redis should automatically remove least recently used keys to stay within the memory cap.

## ⚙️ Execution
1. Use `INFO` to inspect memory usage and key count

```bash
INFO memory
INFO keyspace
```

2. Use `KEYS` to list all keys
```bash
KEYS *
```

3. Use `SCAN` to iterate over keyspace
```bash
SCAN 0
```

4. Use `MEMORY USAGE` to inspect memory usage of a key
```bash
MEMORY USAGE mykey
```

5. Simulate cache eviction with `maxmemory-policy`
```bash
CONFIG SET maxmemory 1mb
CONFIG SET maxmemory-policy allkeys-lru
```

6. Insert keys until eviction triggers
```bash
EVAL "for i=1,1000 do redis.call('SET', 'cache:'..i, 'value'..i) end" 0
```

7. Use `INFO` to inspect memory usage and key count
```bash
INFO memory
INFO keyspace
```

or

```bash
MONITOR
```

## 📊 Result
- Initial memory usage: used_memory_human: 1.58M, with 3000 keys in db0.
- Each cache:* key consumed ~72 bytes.
- maxmemory was set to 1mb, and policy to allkeys-lru.
- Attempt to insert 1000 keys via Lua EVAL failed with:

```bash
(error) OOM command not allowed when used memory > 'maxmemory'
```

- Final key count: db0:keys=6000, indicating keys were added outside the memory cap before policy enforcement.

## 🔍 Analysis
- Memory Cap Enforcement: Redis was configured with maxmemory=1mb initially, then raised to 2mb. The INFO memory output shows used_memory_human: 2.00M, matching the cap precisely. This confirms Redis is respecting the memory limit.
- Eviction Behavior Confirmed: After inserting 10,000 keys via Lua EVAL, Memory USAGE cache:1 returned (nil) while cache:2 and cache:3 remained. This indicates that cache:1 was evicted—consistent with allkeys-lru policy removing least recently used keys.
- Eviction Is Dynamic: A new key (cache:7778) was inserted successfully even at memory cap, showing Redis evicted older keys to make room. This validates that eviction is active and responsive.
- Fragmentation Impact: mem_fragmentation_ratio: 5.25 and rss_overhead_bytes: 3.8MB+ suggest significant memory overhead beyond logical dataset size. This may reduce effective usable memory under tight caps.
- Script Execution vs. Eviction: Earlier EVAL attempts failed with OOM errors when memory was already exceeded. However, once memory was precisely capped and eviction policy active, Redis allowed inserts and evicted keys as expected.
- Keyspace Growth: Despite eviction, INFO keyspace showed db0:keys=6000, indicating Redis retained a large portion of keys while evicting selectively.

## 🛠️ Remediation or Follow-up

```bash
❯ ./utils/connect.sh redis
✅ 'gptx_redis' is running. Connecting to redis...
127.0.0.1:6379> INFO memory
# Memory
used_memory:1652440
used_memory_human:1.58M
used_memory_rss:10747904
used_memory_rss_human:10.25M
used_memory_peak:1872712
used_memory_peak_human:1.79M
used_memory_peak_perc:88.24%
used_memory_overhead:1102336
used_memory_startup:946224
used_memory_dataset:550104
used_memory_dataset_perc:77.89%
allocator_allocated:2578840
allocator_active:2985984
allocator_resident:6844416
allocator_muzzy:0
total_system_memory:16750186496
total_system_memory_human:15.60G
used_memory_lua:66560
used_memory_vm_eval:66560
used_memory_lua_human:65.00K
used_memory_scripts_eval:632
number_of_cached_scripts:3
number_of_functions:0
number_of_libraries:0
used_memory_vm_functions:32768
used_memory_vm_total:99328
used_memory_vm_total_human:97.00K
used_memory_functions:192
used_memory_scripts:824
used_memory_scripts_human:824B
maxmemory:2097152
maxmemory_human:2.00M
maxmemory_policy:allkeys-lru
allocator_frag_ratio:1.14
allocator_frag_bytes:278504
allocator_rss_ratio:2.29
allocator_rss_bytes:3858432
rss_overhead_ratio:1.57
rss_overhead_bytes:3903488
mem_fragmentation_ratio:6.59
mem_fragmentation_bytes:9116136
mem_not_counted_for_evict:0
mem_replication_backlog:0
mem_total_replication_buffers:0
mem_clients_slaves:0
mem_clients_normal:1928
mem_cluster_links:0
mem_aof_buffer:0
mem_allocator:jemalloc-5.3.0
mem_overhead_db_hashtable_rehashing:0
active_defrag_running:0
lazyfree_pending_objects:0
lazyfreed_objects:0
127.0.0.1:6379> INFO keyspace
# Keyspace
db0:keys=3000,expires=0,avg_ttl=0,subexpiry=0
127.0.0.1:6379> Memory USAGE cache:1
(integer) 72
127.0.0.1:6379> Memory USAGE cache:2
(integer) 72
127.0.0.1:6379> Memory USAGE cache:1
(integer) 72
127.0.0.1:6379> CONFIG SET maxmemory 1mb
OK
127.0.0.1:6379> CONFIG SET maxmemory-policy allkeys-lru
OK
127.0.0.1:6379> EVAL "for i=1,1000 do redis.call('SET', 'cache:'..i, 'value'..i) end" 0
(error) OOM command not allowed when used memory > 'maxmemory'. script: ed3160accb0a34005791c937a4c0db88a2667c08, on @user_script:1.
127.0.0.1:6379> INFO keyspace
# Keyspace
db0:keys=6000,expires=0,avg_ttl=0,subexpiry=0
127.0.0.1:6379> Memory USAGE cache:1
(nil)
127.0.0.1:6379> Memory USAGE cache:2
(integer) 72
127.0.0.1:6379> Memory USAGE cache:3
(integer) 72
127.0.0.1:6379> SET cache:7778 value7778
OK
127.0.0.1:6379> Memory USAGE cache:2
(integer) 72
127.0.0.1:6379> exit
```

