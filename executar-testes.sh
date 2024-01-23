#!/usr/bin/bash

#docker system prune -f

# Não use este script para executar seus testes locais, suba sua API
# na porta 9999 ou docker-compose e use `executar-teste-local.sh`

RESULTS_WORKSPACE=$(pwd)/resultados
GATLING_BIN_DIR=$HOME/gatling/3.10.3/bin
GATLING_WORKSPACE="$(pwd)/load-test/user-files"

runGatling() {
    sh $GATLING_BIN_DIR/gatling.sh -rm local -s RinhaBackendCrebitosSimulation \
        -rd "Rinha de Backend - 2024/Q1: Crébito" \
        -rf "$RESULTS_WORKSPACE/$1" \
        -sf "$GATLING_WORKSPACE/simulations"
}

startTest() {
    for i in {1..20}; do
        # 2 requests to wake the 2 api instances up :)
        curl --fail http://localhost:9999/clientes/1/extrato && \
        echo "" && \
        curl --fail http://localhost:9999/clientes/1/extrato && \
        echo "" && \
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

generateResults() {
    echo "# Resultados da Rinha de Backend, Segunda Edição" > RESULTADOS.md
    echo " " >> RESULTADOS.md
    echo "| participante | p99 | p98 | requisições ok | extrato | transações | outros erros | relatório completo |" >> RESULTADOS.md
    echo "| --           | --  | --  | --             | --      | --         | --           | --                 |" >> RESULTADOS.md

    for diretorio in resultados/*/; do
    (
        echo "==============="
        participante=$(echo $diretorio | sed -e 's/resultados\///g' -e 's/\///g')
        arquivoStats=$(find $diretorio -name stats.json)
        reportFile=$(find $diretorio -name index.html)
        simulationFile=$(find $diretorio -name simulation.log)
        reportDir=$(dirname $reportFile)

        echo computando $participante
        p99All=$(cat $arquivoStats | jq .stats.percentiles4.total)
        p98All=$(cat $arquivoStats | jq .stats.percentiles3.total) # altere gatling.conf pra configurar percentis diferentes
        totalAll=$(cat $arquivoStats | jq .stats.numberOfRequests.total)
        okAll=$(cat $arquivoStats | jq .stats.numberOfRequests.ok)
        nokAll=$(cat $arquivoStats | jq .stats.numberOfRequests.ko)
        percentageOk=$(awk -v okAll=$okAll -v totalAll=$totalAll 'BEGIN {print (okAll / totalAll) * 100.00}')
        nokExtrato=$(grep $simulationFile -e 'jmesPath(saldo.total)' | wc -l)
        nokTransacao=$(grep $simulationFile -e 'jmesPath(saldo)' | wc -l)
        nokOther=$(bc <<< "$nokAll - ($nokExtrato + $nokTransacao)")
        echo "| [$participante](./participantes/$participante) | ${p99All}ms | ${p98All}ms | ${percentageOk}% | $nokExtrato erros | $nokTransacao erros | $nokOther | [link]($reportDir) | " >> RESULTADOS.md
        echo "ok"
    )
    done
}

for diretorio in participantes/*/; do
(
    participante=$(echo $diretorio | sed -e 's/participantes\///g' -e 's/\///g')
    echo "======================"
    echo $participante

    testedFile="$RESULTS_WORKSPACE/$participante/testada"

    if test -f $testedFile; then
        echo "submissão '$participante' já testada - ignorando"
    else
        startApi $participante
        startTest $participante
        stopApi $participante
        touch $testedFile
    fi
)
done

generateResults
