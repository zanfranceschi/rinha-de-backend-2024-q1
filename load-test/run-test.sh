#!/usr/bin/bash

runGatling() {
    GATLING_BIN_DIR=$HOME/gatling/3.10.3/bin

    WORKSPACE="$(pwd)/user-files"

    sh $GATLING_BIN_DIR/gatling.sh -rm local -s RinhaBackendCrebitosSimulation \
        -rd "Rinha de Backend - 2024/Q1: Crébito" \
        -rf $WORKSPACE/results \
        -sf $WORKSPACE/simulations
}

for i in {1..20}; do
    # 2 requests to wake the 2 api instances up :)
    curl --fail http://localhost:9999/clientes/1/extrato && \
    curl --fail http://localhost:9999/clientes/1/extrato && \
    runGatling && \
    break || sleep 2;
done