db = db.getSiblingDB("rinha");

db.createCollection("transactions");
db.createCollection("clients");

db.clients.insertMany([
    {_id: 1, balance: 0, limit: 100000, latest_transactions: [] },
    {_id: 2, balance: 0, limit: 80000 , latest_transactions: [] }, 
    {_id: 3, balance: 0, limit: 1000000, latest_transactions: [] },
    {_id: 4, balance: 0, limit: 10000000, latest_transactions: [] },
    {_id: 5, balance: 0, limit: 500000, latest_transactions: [] },
]);

db.transactions.createIndex({ client: 1 });
db.transactions.createIndex({ date: -1 });