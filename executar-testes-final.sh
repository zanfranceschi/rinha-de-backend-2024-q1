#!/usr/bin/env bash

# Não use este script para executar seus testes locais, suba sua API
# na porta 9999 ou docker-compose e use `executar-teste-local.sh`

RESULTS_WORKSPACE=$(pwd)/resultados
GATLING_BIN_DIR=$HOME/gatling/bin
GATLING_WORKSPACE="$(pwd)/load-test/user-files"

countAPIsToBeTested() {
    pushd ./participantes > /dev/null
    echo "APIs to be tested:"
    find '.' -mindepth 1 -maxdepth 1 -type d \! -exec test -e '{}/testada' \; -print
    find '.' -mindepth 1 -maxdepth 1 -type d \! -exec test -e '{}/testada' \; -print | wc -l
    popd > /dev/null
}

runGatling() {
    sh $GATLING_BIN_DIR/gatling.sh -rm local -s RinhaBackendCrebitosSimulation \
        -rd "Rinha de Backend - 2024/Q1: Crébito - $1" \
        -rf "$RESULTS_WORKSPACE/$1" \
        -sf "$GATLING_WORKSPACE/simulations"
}

startTest() {
    sleep 5
    for i in {1..20}; do
        # requests to wake the 2 api instances up :)
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
    pushd participantes/$1 > /dev/null
        for i in {1..5}; do
            docker compose pull > docker-compose.logs && \
            break || sleep 2;
        done
        nohup docker compose up --build >> docker-compose.logs &
    popd > /dev/null
}

stopApi() {
    pushd participantes/$1 > /dev/null
        docker compose rm -f
        docker compose down --volumes
        docker compose rm -v -f
    popd > /dev/null
}

generateResults() {
    echo " " > TEMP-OK.md
    echo "| participante | multa SLA (> 249ms) | multa SLA (inconsistência saldo) | multa total | valor a receber | relatório |" >> TEMP-OK.md
    echo "| --           | --                  | --                               | --          | --              | --        |" >> TEMP-OK.md

    #echo " " > TEMP-NOK.md
    #echo "| participante | logs |" >> TEMP-NOK.md
    #echo "| --           | --   |" >> TEMP-NOK.md

    valorContrato=100000.0
    SLARespostasOk=98.0
    multaInconsistenciaSaldoLimiteUnidade=803.01
   echo "computando participantes..."
    for diretorio in resultados/*/; do
    (
        participante=$(echo $diretorio | sed -e 's/resultados\///g' -e 's/\///g')

        reportFileCount=$(find $diretorio -name index.html | wc -l)

        if [ $reportFileCount -eq "1" ]; then

            arquivoStats=$(find $diretorio -name stats.json)
            reportFile=$(find $diretorio -name index.html)
            simulationFile=$(find $diretorio -name simulation.log)
            reportDir=$(dirname $reportFile)

            totalRequests=$(cat $arquivoStats | jq '.stats.numberOfRequests.total')
            responsesOkMenos250ms=$(cat $arquivoStats | jq '.stats.group1.count')
            porcentagemRespostasAceitaveis=$(python3 -c "print(round(${responsesOkMenos250ms} / ${totalRequests} * 100, 2))")
            inconsistenciasSaldoLimite=$(grep "ConsistenciaSaldoLimite" $simulationFile | wc -l)
            inconsistenciaTransacoesSaldo=$(grep "jmesPath(saldo.total).find.is" $simulationFile | wc -l)
            multaSLA250ms=$(python3 -c "print(max(0.0, round(((${SLARespostasOk} - ${porcentagemRespostasAceitaveis}) * 1000), 2)))")
            multaSLAInconsSaldo=$(python3 -c "print(round(((${inconsistenciasSaldoLimite} + ${inconsistenciaTransacoesSaldo}) * ${multaInconsistenciaSaldoLimiteUnidade}), 2))")
            multaSLATotal=$(python3 -c "print(round(${multaSLA250ms} + ${multaSLAInconsSaldo}, 2))")
            pagamento=$(python3 -c "print(max(0.0, round(${valorContrato} - ${multaSLATotal}, 2)))")

            echo -n "| [$participante](./participantes/$participante) " >> TEMP-OK.md
            echo -n "| USD ${multaSLA250ms} " >> TEMP-OK.md
            echo -n "| USD ${multaSLAInconsSaldo} " >> TEMP-OK.md
            echo -n "| USD ${multaSLATotal} " >> TEMP-OK.md
            echo -n "| **USD ${pagamento}** " >> TEMP-OK.md
            echo    "| [link]($reportDir) |" >> TEMP-OK.md
        #else
        #    echo -n "| [$participante](./participantes/$participante) " >> TEMP-NOK.md
        #    echo    "| [docker-compose.logs](./participantes/$participante/docker-compose.logs) |" >> TEMP-NOK.md
        fi
    )
    done

    cat RESULTADOS-HEADER.md > RESULTADOS.md
    cat TEMP-OK.md >> RESULTADOS.md

    echo " " >> RESULTADOS.md
    #echo "#### Participantes Sem Execução/Relatório" >> RESULTADOS.md
    #cat TEMP-NOK.md >> RESULTADOS.md

    rm TEMP-OK.md
    #rm TEMP-NOK.md
}

generateTestsStatus() {

    numParticipantes=$(ls -d participantes/*/ | wc -l)

    echo "# Status da Execução dos Testes" > STATUS-TESTES.md
    echo "Tabela com os status das execuções de testes para cada submissão." >> STATUS-TESTES.md
    echo "" >> STATUS-TESTES.md
    echo "Atualizada **$(date)** com **$numParticipantes** submissões." >> STATUS-TESTES.md
    echo " " >> STATUS-TESTES.md
    echo "| participante | status | p75 geral |" >> STATUS-TESTES.md
    echo "| --           | --     | --        |" >> STATUS-TESTES.md

    for diretorio in resultados/*/; do
    (
        participante=$(echo $diretorio | sed -e 's/resultados\///g' -e 's/\///g')

        echo -n "| [$participante](./participantes/$participante) " >> STATUS-TESTES.md

        reportFileCount=$(find $diretorio -name index.html | wc -l)
        if [ $reportFileCount -eq "1" ]; then
            arquivoGlobalStats=$(find $diretorio -name global_stats.json)
            p75=$(cat $arquivoGlobalStats | jq '.percentiles2.total')
            echo "| ok | $p75 |" >> STATUS-TESTES.md
        else
           echo "| falha - [logs](./participantes/$participante/docker-compose.logs) | -- |" >> STATUS-TESTES.md
        fi
    )
    done
}

runAllTests() {
    for diretorio in participantes/*/; do
    (
        participante=$(echo $diretorio | sed -e 's/participantes\///g' -e 's/\///g')
        #echo "======================"
        #echo $participante

        testedFile="$diretorio/testada"

        if ! test -f $testedFile; then
            #echo "submissão '$participante' já testada - ignorando"
            rm -rf "$RESULTS_WORKSPACE/$participante"
            countAPIsToBeTested
            startApi $participante
            startTest $participante
            stopApi $participante
            echo "testada em $(date)" > $testedFile
            echo "abra um PR removendo esse arquivo caso queira que sua API seja testada novamente" >> $testedFile
        fi
    )
    done
}

limitLogsSize() {
    echo "limitando logs..."
    for diretorio in participantes/*/; do
    (
        participante=$(echo $diretorio | sed -e 's/participantes\///g' -e 's/\///g')
        logs=$(find $diretorio -name docker-compose.logs | wc -l)

        if [ $logs -eq "1" ]; then
            head -n 500 $diretorio/docker-compose.logs > $diretorio/docker-compose.logs~
            mv -f $diretorio/docker-compose.logs~ $diretorio/docker-compose.logs
        fi
    )
    done
}

backupResults () {
    destDir=$HOME/projects/rinha-de-backend-2024-q1-resultados

    rsync -au --delete ./resultados/ $destDir/resultados
    cp -f ./README.md $destDir/README.md
    cp -f ./RESULTADOS.md $destDir/RESULTADOS.md
    cp -f ./RESULTADOS-HEADER.md $destDir/RESULTADOS-HEADER.md
    cp -f ./executar-testes-final.sh $destDir/executar-testes-final.sh
    cp -f ./executar-testes-final-polling.sh $destDir/executar-testes-final-polling.sh

    pushd $destDir > /dev/null
        git add .
        git commit -m "backup $(date)"
        git push -u origin main
    popd > /dev/null
}

clearAllDockerThings() {
    docker system prune -f -a
    docker volume prune -f -a 
}

syncGit() {
    git pull
    git add .
    git commit -m "execução de testes $(date)"
    git push
}


gitignoreGarbage() {
    pushd ./participantes > /dev/null
    find . -user root > .gitignore
    git add .gitignore
    sed -i 's/\.\///g' .gitignore
    popd > /dev/null
}

gitignoreGarbage
syncGit
clearAllDockerThings
countAPIsToBeTested
runAllTests
generateResults
generateTestsStatus
limitLogsSize
backupResults
