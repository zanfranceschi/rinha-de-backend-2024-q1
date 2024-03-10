let customers = [
  { id: 1, limit: 100000, balance: 0 },
  { id: 2, limit: 80000, balance: 0 },
  { id: 3, limit: 1000000, balance: 0 },
  { id: 4, limit: 10000000, balance: 0 },
  { id: 5, limit: 500000, balance: 0 },
]

db.customer.insertMany(customers)

db.customer.createIndex({ id: 1 })
db.transaction.createIndex({ customerId: 1, datetime: -1 })
