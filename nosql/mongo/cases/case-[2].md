Go to [`Track progress`](../../../README.md).

# 📚 CASE: Model Nested Documents

```
    Module: MongoDB    Date: 2025-10-02    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `mongo > Model Nested Documents` |
| Commit: | `docs(mongo): add model nested documents case report` |

## 📍 Scenario
Insert a user with nested address and preferences.

## 🎯 Objective
Use nested documents to store user information.

## 🧠 Hypothesis
Nested documents will be used to store user information.

## ⚙️ Execution
1. Insert a user with nested address and preferences

```bash
❯ docker exec -it mongo2_replset mongosh

db.users.insertOne({
  name: "Ana López",
  email: "ana@example.com",
  address: {
    street: "Calle Independencia 123",
    city: "Oaxaca",
    zip: "68000"
  },
  preferences: {
    language: "es",
    notifications: {
      email: true,
      sms: false
    }
  }
})

```

2. Query with dot notation

Find users by city
```bash
db.users.find({ "address.city": "Oaxaca" })
```

Find users who prefer email notifications
```bash
db.users.find({ "preferences.notifications.email": true })
```

Project only name and zip code
```bash
db.users.find({ "address.city": "Oaxaca" }, { name: 1, "address.zip": 1, _id: 0 })
```

## 📊 Result
- Document inserted with nested address and preferences fields.
- Dot notation queries successfully matched and projected nested values.
- Demonstrated MongoDB's ability to store and query hierarchical data without joins.

## 🔍 Analysis
- Document Structure: Embedding address and preferences reflects real-world user profiles and avoids unnecessary collection fragmentation.
- Query Precision: Dot notation allows targeting deeply nested fields with clarity and efficiency.
- Operational Insight: This pattern supports flexible schema evolution and is ideal for user-centric apps, especially when preferences or settings are scoped to individual users.

## 🛠️ Remediation or Follow-up

```bash
❯ docker exec -it mongo2_replset mongosh

rs0 [direct: primary] test> use test;
already on db test
rs0 [direct: primary] test> db.users.insertOne({
...   name: "Ana López",
...   email: "ana@example.com",
...   address: {
...     street: "Calle Independencia 123",
...     city: "Oaxaca",
...     zip: "68000"
...   },
...   preferences: {
...     language: "es",
...     notifications: {
...       email: true,
...       sms: false
...     }
...   }
... });

{
  acknowledged: true,
  insertedId: ObjectId('68df60493621267dcace5f47')
}
rs0 [direct: primary] test> db.users.find({ "address.city": "Oaxaca" });
[
  {
    _id: ObjectId('68df60493621267dcace5f47'),
    name: 'Ana López',
    email: 'ana@example.com',
    address: { street: 'Calle Independencia 123', city: 'Oaxaca', zip: '68000' },
    preferences: { language: 'es', notifications: { email: true, sms: false } }
  }
]
rs0 [direct: primary] test> db.users.find({ "preferences.notifications.email": true });

[
  {
    _id: ObjectId('68df60493621267dcace5f47'),
    name: 'Ana López',
    email: 'ana@example.com',
    address: { street: 'Calle Independencia 123', city: 'Oaxaca', zip: '68000' },
    preferences: { language: 'es', notifications: { email: true, sms: false } }
  }
]
rs0 [direct: primary] test> db.users.find(
...   { "address.city": "Oaxaca" },
...   { name: 1, "address.zip": 1, _id: 0 }
... );

[ { name: 'Ana López', address: { zip: '68000' } } ]
rs0 [direct: primary] test> exit

```