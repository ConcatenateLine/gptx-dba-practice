db = db.getSiblingDB("gptxdb");

db.users.insertOne({
  username: "jc",
  email: "jc@example.com",
  created_at: new Date()
});

db.products.createIndex({ price: 1 });
