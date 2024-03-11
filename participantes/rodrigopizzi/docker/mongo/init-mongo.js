print('Start #################################################################');

db = db.getSiblingDB('rinha');

db.clients.insert([
    {_id: 1, limit: 100000, balance: 0, transactions:[]},
    {_id: 2, limit: 80000, balance: 0, transactions:[]},
    {_id: 3, limit: 1000000, balance: 0, transactions:[]},
    {_id: 4, limit: 10000000, balance: 0, transactions:[]},
    {_id: 5, limit: 500000, balance: 0, transactions:[]},
]);