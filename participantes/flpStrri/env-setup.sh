curl -f --silent --request POST --header 'Content-Type: application/json' --data '{"id":1,"limite":100000}' api-1:3000/clientes
curl -f --silent --request POST --header 'Content-Type: application/json' --data '{"id":2,"limite":80000}' api-2:3000/clientes
curl -f --silent --request POST --header 'Content-Type: application/json' --data '{"id":3,"limite":1000000}' api-1:3000/clientes
curl -f --silent --request POST --header 'Content-Type: application/json' --data '{"id":4,"limite":10000000}' api-2:3000/clientes
curl -f --silent --request POST --header 'Content-Type: application/json' --data '{"id":5,"limite":500000}' api-1:3000/clientes
