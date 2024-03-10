#!/bin/bash

startWarmupMakeTransactions() {
    for i in {1..30}; do
        # 2 requests to wake the 2 api instances up :)
        curl --fail -s --request POST \
                      --url http://nginx:9999/clientes/1/transacoes \
                      --header 'Content-Type: application/json' \
                      --data '{
                        "valor": 1000,
                        "tipo" : "c",
                        "descricao" : "descricao"
                    }' > /dev/null && \
        curl --fail -s --request POST \
                              --url http://nginx:9999/clientes/1/transacoes \
                              --header 'Content-Type: application/json' \
                              --data '{
                                "valor": 1000,
                                "tipo" : "d",
                                "descricao" : "descricao"
                            }' > /dev/null
    done
}


startWarmupExtract() {
    for i in {1..30}; do
        # 2 requests to wake the 2 api instances up :)
        curl --fail -s http://nginx:9999/clientes/1/extrato?skip=true > /dev/null && \
        curl --fail -s http://nginx:9999/clientes/1/extrato?skip=true > /dev/null
    done
}


startTest() {
  echo "Starting test..."
  for i in {1..200}; do
      # 2 requests to wake the 2 api instances up :)
      curl --fail -s http://nginx:9999/clientes/1/extrato?skip=true > /dev/null && \
      curl --fail -s http://nginx:9999/clientes/1/extrato?skip=true > /dev/null && \
      break || sleep 0.1;
  done
  echo "finish test"
}

reset() {
  curl -s --request DELETE \
    --url http://api01:8080/clientes/reset
  curl -s --request DELETE \
      --url http://api02:8080/clientes/reset
}


startTest;
startWarmupMakeTransactions &
startWarmupExtract &

wait

reset
