#!/usr/bin/bash

#docker system prune -f

RESULTS_WORKSPACE=$(pwd)/resultados/primeira-fase
GATLING_BIN_DIR=$HOME/gatling/3.10.3/bin
GATLING_WORKSPACE="$(pwd)/load-test/user-files"

runGatling() {
    echo "$RESULTS_WORKSPACE/$1"
    
    sh $GATLING_BIN_DIR/gatling.sh -rm local -s RinhaBackendCrebitosCompeticaoSimulation \
        -rd "Rinha de Backend - 2024/Q1: Crébito" \
        -rf "$RESULTS_WORKSPACE/$1" \
        -sf "$GATLING_WORKSPACE/simulations"
}

startTest() {
    for i in {1..20}; do
        # 2 requests to wake the 2 api instances up :)
        curl --fail http://localhost:9999/clientes/1/extrato && \
        curl --fail http://localhost:9999/clientes/1/extrato && \
        runGatling $1 && \
        break || sleep 2;
    done
}

startApi() {
    mkdir -p "$RESULTS_WORKSPACE/$1"
    pushd participantes/$1
    docker-compose up -d --build
    docker-compose logs > "$RESULTS_WORKSPACE/$1/docker-compose.logs"
    popd
}

stopApi() {
    pushd participantes/$1
    docker-compose rm -f
    docker-compose down
    popd
}

for diretorio in participantes/*/; do
(
    participante=$(echo $diretorio | sed -e 's/participantes\///g' -e 's/\///g')
    echo "======================"
    echo $participante

    testedFile="$RESULTS_WORKSPACE/$participante/testada"

    if test -f $testedFile; then
        echo "Submissão '$participante' já testada - ignorando."
    else
        startApi $participante
        startTest $participante
        stopApi $participante
        touch $testedFile
    fi
)
done
