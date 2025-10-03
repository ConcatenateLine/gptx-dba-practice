Go to [`Track progress`](../../../README.md).

# 📚 CASE: Simulate Sharding

```
    Module: MongoDB    Date: 2025-10-03    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `mongo > Simulate Sharding` |
| Commit: | `docs(mongo): add simulate sharding case report` |

## 📍 Scenario
Simulate sharding for a collection.

## 🎯 Objective
Simulate mongodb sharding locally.

## 🧠 Hypothesis
Simulate mongodb sharding locally.

## ⚙️ Execution
1. Add multiple mongo containers. [`docker-compose.yml`](../docker-composer.yml)
   - mongo_config1      2 config servers
   - mongo_config2
   - mongo_shard1a      2 shard replica sets (each with 2 nodes)
   - mongo_shard1b
   - mongo_shard2a
   - mongo_shard2b
   - mongo_mongos       1 mongos router

2. initial replica sets
Use mongosh to connect to each replica set and run:

Config servers:
```bash
rs.initiate({
  _id: "configReplSet",
  configsvr: true,
  members: [
    { _id: 0, host: "mongo_config1" },
    { _id: 1, host: "mongo_config2" }
  ]
})
```

Shard 1:
```bash
rs.initiate({
  _id: "shard1",
  members: [
    { _id: 0, host: "mongo_shard1a" },
    { _id: 1, host: "mongo_shard1b" }
  ]
})
```

Shard 2:
```bash
rs.initiate({
  _id: "shard2",
  members: [
    { _id: 0, host: "mongo_shard2a" },
    { _id: 1, host: "mongo_shard2b" }
  ]
})
```
3. Connect to mongos and add shards.

```bash
docker exec -it mongo_mongos mongosh
Inside the shell:

sh.addShard("shard1/mongo_shard1a,mongo_shard1b")
sh.addShard("shard2/mongo_shard2a,mongo_shard2b")
```

4. Enable Sharding on a Database
```bash
sh.enableSharding("test")
```
Then shard a collection:

```bash
db.products.createIndex({ category: 1 })
sh.shardCollection("test.products", { category: 1 })
```

## 📊 Result
- Sharded cluster successfully configured.
- Shards are distributed across the cluster.
- Chunk ranges are visible.

## 🔍 Analysis
- Cluster Topology: The simulated environment mirrors a realistic production sharded setup, with separate config servers, shard replica sets, and a routing layer. This validates contributor understanding of horizontal scaling architecture.
- Shard Key Selection: Sharding on category provides predictable routing for category-based queries. This is ideal for e-commerce or inventory datasets where categorical filtering is common.
- Query Routing: Queries using the shard key are efficiently routed to relevant shards. Non-shard-key queries trigger scatter-gather behavior, which is expected and observable in mongos logs.
- Operational Insight: The mongos logs confirm healthy routing behavior, config server connectivity, and client metadata parsing. This validates that the router is functioning and ready for distributed workloads.
- Scalability Simulation: This setup allows future testing of chunk migration, balancer activity, and write distribution. It also lays the groundwork for contributor onboarding, diagnostics scripting, and performance profiling across shards.

## 🛠️ Remediation or Follow-up

Config servers:

```bash
❯ docker exec -it mongo_config1 mongosh

test> rs.initiate({
...   _id: "configReplSet",
...   configsvr: true,
...   members: [
...     { _id: 0, host: "mongo_config1" },
...     { _id: 1, host: "mongo_config2" }
...   ]
... });
{ ok: 1, lastCommittedOpTime: Timestamp({ t: 1759484378, i: 1 }) }
configReplSet [direct: other] test> exit

❯ docker exec -it mongo_config2 mongosh

configReplSet [direct: secondary] test> exit
```

Config shards:

```bash
❯ docker exec -it mongo_shard1a mongosh

test> rs.initiate({
...   _id: "shard1",
...   members: [
...     { _id: 0, host: "mongo_shard1a" },
...     { _id: 1, host: "mongo_shard1b" }
...   ]
... });
{ ok: 1 }
shard1 [direct: other] test> exit

❯ docker exec -it mongo_shard1b mongosh

shard1 [direct: secondary] test> exit


❯ docker exec -it mongo_shard2a mongosh

test> rs.initiate({
...   _id: "shard2",
...   members: [
...     { _id: 0, host: "mongo_shard2a" },
...     { _id: 1, host: "mongo_shard2b" }
...   ]
... });
{ ok: 1 }
shard2 [direct: other] test> exit

❯ docker exec -it mongo_shard2b mongosh

shard2 [direct: secondary] test> exit

```

Connect mongos and add shards: 

```bash
❯ docker exec -it mongo_mongos mongosh

[direct: mongos] test> sh.addShard("shard1/mongo_shard1a,mongo_shard1b")
{
  shardAdded: 'shard1',
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1759487931, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1759487931, i: 1 })
}
[direct: mongos] test> sh.addShard("shard2/mongo_shard2a,mongo_shard2b")
{
  shardAdded: 'shard2',
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1759487949, i: 7 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1759487949, i: 7 })
}
[direct: mongos] test> exit
```
Enable sharding on a database:

```bash
❯ docker exec -it mongo_mongos mongosh

[direct: mongos] test> sh.enableSharding("test");
{
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1759488394, i: 5 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1759488394, i: 2 })
}
[direct: mongos] test> db.products.createIndex({ category: 1});
category_1
[direct: mongos] test> sh.shardCollection("test.products",{ category:1 });
{
  collectionsharded: 'test.products',
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1759488634, i: 30 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1759488634, i: 26 })
}
[direct: mongos] test> exit;
```

Insert documents:

```bash
for (let i = 1; i <= 1000; i++) {
  db.products.insertOne({
    name: `Product ${i}`,
    category: i % 3 === 0 ? "Electronics" : i % 3 === 1 ? "Apparel" : "Accessories",
    price: Math.floor(Math.random() * 1000),
    createdAt: new Date()
  })
}
```

Validation operations (Visual verification):

```bash
❯ docker exec -it mongo_mongos mongosh

[direct: mongos] test> sh.status();
Look for:
- test.products listed under sharded collections
- Chunk ranges and shard assignments

[direct: mongos] test> db.products.find({ category: "Accessories", price: { $lt: 300 } }).explain("executionStats");
Look for:
- Shards array showing distribution of documents across shards

```

Optional: Tail Logs Live:
Then run queries or insert data to observe routing and chunk behavior in real time.
```bash

❯ docker logs -f mongo_mongos | grep -i shard

```

