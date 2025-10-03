Go to [`Track progress`](../../../README.md).

# 📚 CASE: Create a Replica Set (Local)

```
    Module: MongoDB    Date: 2025-10-02    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | [`mongo > Create a Replica Set (Local)`] |
| Commit: | `docs(mongo): add create replica set case report` |


## 📍 Scenario
Create a replica set in a local environment.

## 🎯 Objective
Create a replica set in a local environment.

## 🧠 Hypothesis
Create a replica set in a local environment.

## ⚙️ Execution

1. Add replica set config to `docker-compose.yml`
```yaml
services:
  mongo1_replset:
    image: mongo:6
    container_name: mongo1_replset
    ports:
      - 27017:27017
    command: mongod --replSet rs0 --bind_ip_all
  mongo2_replset:
    image: mongo:6
    container_name: mongo2_replset
    ports:
      - 27018:27017
    command: mongod --replSet rs0 --bind_ip_all
  mongo3_replset:
    image: mongo:6
    container_name: mongo3_replset
    ports:
      - 27019:27017
    command: mongod --replSet rs0 --bind_ip_all

```
2. Initiate with `rs.initiate()`
```bash
docker exec -it mongo1_replset mongosh
rs.initiate()
```
3. Validate with `rs.status()`
```bash
docker exec -it mongo1_replset mongosh
rs.status()
```
4. Insert a test document.
```bash
db.replica.insertOne({ msg: "hello from replica set" })
```
5. Read from a secondary node.
```bash
docker exec -it mongo2_replset mongosh
rs.status()
db.replica.find()
```
6. Simulate failover.
```bash
docker stop mongo1_replset
docker exec -it mongo2_replset mongosh
rs.status()
db.replica.find()
```
7. A new node should be elected as primary.
```bash
docker exec -it mongo2_replset mongosh
rs.status()
db.replica.find()
```


## 📊 Result
- Replica set rs0 successfully initiated with three members: mongo1, mongo2, and mongo3.
- rs.status() confirms one PRIMARY and two SECONDARY nodes.
- Inserted test document into db.replica on the primary node.
- Verified replication by reading from a secondary node was successful.
- Failover test: stopping mongo1 triggered election, and a new PRIMARY was assigned within ~10 seconds.
- rs.status() shows the new PRIMARY node was assigned.

## 🔍 Analysis
- Replica Set Initialization: The rs.initiate() command correctly registered all three nodes. Hostnames matched container names, ensuring internal resolution.
- Replication Behavior: The test document propagated across nodes, confirming that replication is functioning. Read preference override (secondaryPreferred) was necessary due to default restrictions on secondary reads.
- Failover Resilience: Election timing and reassignment of PRIMARY indicate that the replica set is healthy and capable of automatic recovery.
- Operational Insight: This setup simulates a realistic multi-node environment suitable for testing read preferences, failover logic, and eventual consistency.

## 🛠️ Remediation or Follow-up

```bash
❯ docker exec -it mongo1_replset mongosh

test> rs.initiate({ _id: "rs0", members: [{ _id: 0, host: "mongo1_replset"},{ _id: 1, host: "mongo2_replset"},{ _id: 2, host: "mongo3_replset"}] });
{ ok: 1 }
rs0 [direct: other] test> rs.status();
{
  set: 'rs0',
  myState: 1,
  term: Long('1'),
  members: [
    {
      _id: 0,
      name: 'mongo1_replset:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      self: true,
    },
    {
      _id: 1,
      name: 'mongo2_replset:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
    },
    {
      _id: 2,
      name: 'mongo3_replset:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1759451766, i: 6 }),
  },
  operationTime: Timestamp({ t: 1759451766, i: 6 })
}

rs0 [direct: primary] test> use test;
already on db test
rs0 [direct: primary] test> db.replica.insertOne({ msg: "hello from replica set" });
{
  acknowledged: true,
  insertedId: ObjectId('68df1e4776d40e7ba1ce5f47')
}
rs0 [direct: primary] test> exit;

❯ docker exec -it mongo2_replset mongosh
Current Mongosh Log ID: 68df1e774dedc399afce5f46

rs0 [direct: secondary] test> rs.secondaryOk();
DeprecationWarning: .setSecondaryOk() is deprecated. Use .setReadPref("primaryPreferred") instead
Setting read preference from "primary" to "primaryPreferred"

rs0 [direct: secondary] test> db.getMongo().setReadPref("secondaryPreferred");

rs0 [direct: secondary] test> db.test.find();

rs0 [direct: secondary] test> db.getMongo().getReadPref();
ReadPreference {
  mode: 'secondaryPreferred',
}
rs0 [direct: secondary] test> db.isMaster();
{
  hosts: [
    'mongo1_replset:27017',
    'mongo2_replset:27017',
    'mongo3_replset:27017'
  ],
  setName: 'rs0',
  setVersion: 1,
  ismaster: false,
  secondary: true,
  primary: 'mongo1_replset:27017',
  me: 'mongo2_replset:27017',
  readOnly: false,
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1759454525, i: 1 }),
  },
  operationTime: Timestamp({ t: 1759454525, i: 1 }),
  isWritablePrimary: false
}
rs0 [direct: secondary] test> db.replica.find();
[
  {
    _id: ObjectId('68df1e4776d40e7ba1ce5f47'),
    msg: 'hello from replica set'
  }
]
rs0 [direct: secondary] test> exit;

❯ docker stop mongo1_replset
mongo1_replset

❯ docker exec -it mongo2_replset mongosh

rs0 [direct: primary] test> rs.status();
{
  set: 'rs0',
  myState: 1,
  term: Long('2'),
  lastStableRecoveryTimestamp: Timestamp({ t: 1759459695, i: 2 }),
  members: [
    {
      _id: 0,
      name: 'mongo1_replset:27017',
      health: 0,
      state: 8,
      stateStr: '(not reachable/healthy)',
      uptime: 0,
      lastHeartbeatMessage: "Couldn't get a connection within the time limit",
    },
    {
      _id: 1,
      name: 'mongo2_replset:27017',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 8348,
      self: true,
    },
    {
      _id: 2,
      name: 'mongo3_replset:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 7968,
      syncSourceHost: 'mongo2_replset:27017',
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1759459715, i: 1 }),
  },
}
rs0 [direct: primary] test> db.replica.find();
[
  {
    _id: ObjectId('68df1e4776d40e7ba1ce5f47'),
    msg: 'hello from replica set'
  }
]
rs0 [direct: primary] test> exit;
```
