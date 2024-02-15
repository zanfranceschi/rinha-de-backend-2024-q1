conn = new Mongo();
db = conn.getDB("rinha");


db.statement.createIndex({ "client.id": 1 }, { unique: false });
db.member.createIndex({ "id": 1 }, { unique: true });

db.member.insert({
  "id": 1,
  "limit": 100000,
  "amount": 0
});
db.member.insert({
  "id": 2,
  "limit": 80000,
  "amount": 0
});
db.member.insert({
  "id": 3,
  "limit": 1000000,
  "amount": 0
});
db.member.insert({
  "id": 4,
  "limit": 10000000,
  "amount": 0
});
db.member.insert({
  "id": 5,
  "limit": 500000,
  "amount": 0
});
