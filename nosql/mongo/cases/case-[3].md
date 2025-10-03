Go to [`Track progress`](../../../README.md).

# 📚 CASE: Profile a Query

```
    Module: MongoDB    Date: 2025-10-02    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `mongo > Profile a Query` |
| Commit: | [`docs(mongo): add profile a query case report`] |

## 📍 Scenario
Profile a query on the `products` collection.

## 🎯 Objective     
Improve query performance.

## 🧠 Hypothesis
Adding an index on `category` and `price` will reduce scan time.

## ⚙️ Execution
1. Insert Sample Data
```bash
use test

for (let i = 1; i <= 2999; i++) {
   db.products.insertOne({
     name: `Product ${i}`,
     category: i % 3 === 0 ? "Electronics" : i % 3 === 1 ? "Apparel" : "Accessories",
     price: Math.floor(Math.random() * 1000) + 50,
     stock: Math.floor(Math.random() * 100),
     createdAt: new Date()
   })
 };

```

2. Run query without index
```bash
db.products.find({ category: "Electronics", price: { $gt: 500 } }).explain("executionStats")
```

3. Add compound index
```bash
db.products.createIndex({ category: 1, price: 1 })
```

4. Run query with index
```bash
db.products.find({ category: "Electronics", price: { $gt: 500 } }).explain("executionStats")
```

## 📊 Result
- Inserted 2,999 product documents into test.products.
- Initial query { category: "Electronics", price: { $gt: 500 } } returned 697 documents using a COLLSCAN (collection scan).
- totalDocsExamined: 4,003
- totalKeysExamined: 0
- executionTimeMillis: 3

- Created compound index { category: 1, price: 1 }.

- Re-ran the same query, now using IXSCAN → FETCH plan.
- totalDocsExamined: 697
- totalKeysExamined: 697
- executionTimeMillis: 4

- indexBounds: category = "Electronics", price > 500

## 🔍 Analysis
- Query Behavior Without Index: The initial query triggered a full collection scan (COLLSCAN), examining all 4,003 documents to return 697 matches. This is expected in the absence of an index, and while the execution time was low due to dataset size, it’s inefficient at scale.
- Index Impact: After creating the compound index, MongoDB used an index scan (IXSCAN) followed by a fetch stage. The query examined only the relevant 697 index keys and documents, confirming index selectivity and coverage.
- Execution Time Comparison: Despite a slight increase in executionTimeMillis (from 3ms to 4ms), the indexed query is significantly more efficient in terms of document examination and future scalability. The time delta is likely due to fetch overhead and internal caching behavior.
- Operational Insight: This exercise validates the importance of compound indexes for multi-field filters. The index bounds confirm that MongoDB correctly optimized the query path. This pattern is ideal for e-commerce, analytics, or inventory systems where category and price are common filters.

## 🛠️ Remediation or Follow-up

```bash
❯ docker exec -it mongo2_replset mongosh

rs0 [direct: primary] test> use test;
already on db test
rs0 [direct: primary] test> for (let i = 1; i <= 2999; i++) {
...    db.products.insertOne({
...      name: `Product ${i}`,
...      category: i % 3 === 0 ? "Electronics" : i % 3 === 1 ? "Apparel" : "Accessories",
...      price: Math.floor(Math.random() * 1000) + 50,
...      stock: Math.floor(Math.random() * 100),
...      createdAt: new Date()
...    })
...  };
{
  acknowledged: true,
  insertedId: ObjectId('68df6a81be0d0b662bce6afd')
}
rs0 [direct: primary] test> db.products.find({ category: "Electronics", price: { $gt: 500 } }).explain("executionStats");
{
  explainVersion: '1',
  queryPlanner: {
    namespace: 'test.products',
    indexFilterSet: false,
    parsedQuery: {
      '$and': [
        { category: { '$eq': 'Electronics' } },
        { price: { '$gt': 500 } }
      ]
    },
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 697,
    executionTimeMillis: 3,
    totalKeysExamined: 0,
    totalDocsExamined: 4003,
    executionStages: {
      stage: 'COLLSCAN',
      filter: {
        '$and': [
          { category: { '$eq': 'Electronics' } },
          { price: { '$gt': 500 } }
        ]
      },
      nReturned: 697,
      executionTimeMillisEstimate: 0,
      works: 4004,
      advanced: 697,
      needTime: 3306,
      needYield: 0,
      saveState: 4,
      restoreState: 4,
      isEOF: 1,
      direction: 'forward',
      docsExamined: 4003
    }
  },
  command: {
    find: 'products',
    filter: { category: 'Electronics', price: { '$gt': 500 } },
    '$db': 'test'
  },
}
rs0 [direct: primary] test> db.products.createIndex({ category: 1, price: 1 });
category_1_price_1

rs0 [direct: primary] test> db.products.find({ category: "Electronics", price: { $gt: 500 } }).explain("executionStats");
{
  queryPlanner: {
    namespace: 'test.products',
    indexFilterSet: false,
    parsedQuery: {
      '$and': [
        { category: { '$eq': 'Electronics' } },
        { price: { '$gt': 500 } }
      ]
    },
    winningPlan: {
      stage: 'FETCH',
      inputStage: {
        stage: 'IXSCAN',
        keyPattern: { category: 1, price: 1 },
        indexName: 'category_1_price_1',
        isMultiKey: false,
        multiKeyPaths: { category: [], price: [] },
        isUnique: false,
        isSparse: false,
        isPartial: false,
        indexVersion: 2,
        direction: 'forward',
        indexBounds: {
          category: [ '["Electronics", "Electronics"]' ],
          price: [ '(500, inf.0]' ]
        }
      }
    },
    rejectedPlans: []
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 697,
    executionTimeMillis: 4,
    totalKeysExamined: 697,
    totalDocsExamined: 697,
    executionStages: {
      stage: 'FETCH',
      nReturned: 697,
      executionTimeMillisEstimate: 0,
      works: 698,
      advanced: 697,
      needTime: 0,
      needYield: 0,
      isEOF: 1,
      docsExamined: 697,
      alreadyHasObj: 0,
      inputStage: {
        stage: 'IXSCAN',
        nReturned: 697,
        executionTimeMillisEstimate: 0,
        works: 698,
        advanced: 697,
        needTime: 0,
        isEOF: 1,
        keyPattern: { category: 1, price: 1 },
        indexName: 'category_1_price_1',
        isMultiKey: false,
        multiKeyPaths: { category: [], price: [] },
        direction: 'forward',
        indexBounds: {
          category: [ '["Electronics", "Electronics"]' ],
          price: [ '(500, inf.0]' ]
        },
        keysExamined: 697,
        seeks: 1,
      }
    }
  },
  command: {
    find: 'products',
    filter: { category: 'Electronics', price: { '$gt': 500 } },
    '$db': 'test'
  },
  operationTime: Timestamp({ t: 1759472390, i: 5 })
}
rs0 [direct: primary] test> exit;

```