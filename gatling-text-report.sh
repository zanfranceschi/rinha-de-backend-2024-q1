#!/usr/bin/env bash

RESULTS_DIR=./load-test/user-files/results
OUTPUT_REPORT=./gatling-text-report.txt

error() {
    echo "Você precisa ter jq instalado:"
    echo "https://jqlang.github.io/jq/"
    exit 1
}

jq --version > /dev/null || error

genTextReport() {

    for diretorio in $RESULTS_DIR/*; do
    (
        reportFileCount=$(find $diretorio -name index.html | wc -l)
        if [ $reportFileCount -eq "1" ]; then

            reportFile=$(find $diretorio -name index.html)

            executionTimestamp=$(grep -E "[0-9]{4}\-[0-9]{2}\-[0-9]{2} [0-9]" $reportFile | sed -e 's/<span>//g' -e 's/<\/span>//g' | sed 's/^[   ]*//;s/[    ]*$//')
            arquivoStats=$(find $diretorio -name stats.json)
            
            all=$(cat $arquivoStats | jq '.stats.numberOfRequests.total')
            allOk=$(cat $arquivoStats | jq '.stats.numberOfRequests.ok')
            allKo=$(cat $arquivoStats | jq '.stats.numberOfRequests.ko')
            
            allMinResponseTimeTotal=$(cat $arquivoStats | jq '.stats.minResponseTime.total')
            allMinResponseTimeOk=$(cat $arquivoStats | jq '.stats.minResponseTime.ok')
            allMinResponseTimeKo=$(cat $arquivoStats | jq '.stats.minResponseTime.ko')

            allMaxResponseTimeTotal=$(cat $arquivoStats | jq '.stats.maxResponseTime.total')
            allMaxResponseTimeOk=$(cat $arquivoStats | jq '.stats.maxResponseTime.ok')
            allMaxResponseTimeKo=$(cat $arquivoStats | jq '.stats.maxResponseTime.ko')

            allMeanResponseTimeTotal=$(cat $arquivoStats | jq '.stats.meanResponseTime.total')
            allMeanResponseTimeOk=$(cat $arquivoStats | jq '.stats.meanResponseTime.ok')
            allMeanResponseTimeKo=$(cat $arquivoStats | jq '.stats.meanResponseTime.ko')

            allPercentiles1Total=$(cat $arquivoStats | jq '.stats.percentiles1.total')
            allPercentiles1Ok=$(cat $arquivoStats | jq '.stats.percentiles1.ok')
            allPercentiles1Ko=$(cat $arquivoStats | jq '.stats.percentiles1.ko')

            allPercentiles2Total=$(cat $arquivoStats | jq '.stats.percentiles2.total')
            allPercentiles2Ok=$(cat $arquivoStats | jq '.stats.percentiles2.ok')
            allPercentiles2Ko=$(cat $arquivoStats | jq '.stats.percentiles2.ko')

            allPercentiles3Total=$(cat $arquivoStats | jq '.stats.percentiles3.total')
            allPercentiles3Ok=$(cat $arquivoStats | jq '.stats.percentiles3.ok')
            allPercentiles3Ko=$(cat $arquivoStats | jq '.stats.percentiles3.ko')

            allPercentiles4Total=$(cat $arquivoStats | jq '.stats.percentiles4.total')
            allPercentiles4Ok=$(cat $arquivoStats | jq '.stats.percentiles4.ok')
            allPercentiles4Ko=$(cat $arquivoStats | jq '.stats.percentiles4.ko')

            allgroup1Name=$(cat $arquivoStats | jq '.stats.group1.name' | sed -e s/\"//g)
            allgroup1Count=$(cat $arquivoStats | jq '.stats.group1.count')
            allgroup1Precentage=$(cat $arquivoStats | jq '.stats.group1.percentage')

            allgroup2Name=$(cat $arquivoStats | jq '.stats.group2.name' | sed -e s/\"//g)
            allgroup2Count=$(cat $arquivoStats | jq '.stats.group2.count')
            allgroup2Precentage=$(cat $arquivoStats | jq '.stats.group2.percentage')

            allgroup3Name=$(cat $arquivoStats | jq '.stats.group3.name'  | sed -e s/\"//g)
            allgroup3Count=$(cat $arquivoStats | jq '.stats.group3.count')
            allgroup3Precentage=$(cat $arquivoStats | jq '.stats.group3.percentage')

            allgroup4Name=$(cat $arquivoStats | jq '.stats.group4.name'  | sed -e s/\"//g)
            allgroup4Count=$(cat $arquivoStats | jq '.stats.group4.count')
            allgroup4Precentage=$(cat $arquivoStats | jq '.stats.group4.percentage')

            validacoes=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.numberOfRequests.total' )
            validacoesOk=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.numberOfRequests.ok' )
            validacoesKo=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.numberOfRequests.ko' )
            validacoesMin=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.minResponseTime.total' )
            validacoesp1=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.percentiles1.total' )
            validacoesp2=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.percentiles2.total' )
            validacoesp3=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.percentiles3.total' )
            validacoesp4=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.percentiles4.total' )
            validacoesMax=$(cat $arquivoStats | jq '.contents | map(select(.name == "validações"))[0].stats.maxResponseTime.total' )

            debitos=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.numberOfRequests.total' )
            debitosOk=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.numberOfRequests.ok' )
            debitosKo=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.numberOfRequests.ko' )
            debitosMin=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.minResponseTime.total' )
            debitosp1=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.percentiles1.total' )
            debitosp2=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.percentiles2.total' )
            debitosp3=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.percentiles3.total' )
            debitosp4=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.percentiles4.total' )
            debitosMax=$(cat $arquivoStats | jq '.contents | map(select(.name == "débitos"))[0].stats.maxResponseTime.total' )

            creditos=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.numberOfRequests.total' )
            creditosOk=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.numberOfRequests.ok' )
            creditosKo=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.numberOfRequests.ko' )
            creditosMin=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.minResponseTime.total' )
            creditosp1=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.percentiles1.total' )
            creditosp2=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.percentiles2.total' )
            creditosp3=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.percentiles3.total' )
            creditosp4=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.percentiles4.total' )
            creditosMax=$(cat $arquivoStats | jq '.contents | map(select(.name == "créditos"))[0].stats.maxResponseTime.total' )

            extratos=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.numberOfRequests.total' )
            extratosOk=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.numberOfRequests.ok' )
            extratosKo=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.numberOfRequests.ko' )
            extratosMin=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.minResponseTime.total' )
            extratosp1=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.percentiles1.total' )
            extratosp2=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.percentiles2.total' )
            extratosp3=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.percentiles3.total' )
            extratosp4=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.percentiles4.total' )
            extratosMax=$(cat $arquivoStats | jq '.contents | map(select(.name == "extratos"))[0].stats.maxResponseTime.total' )

            echo "Report start - ${executionTimestamp}"
            echo "Response Time Ranges"
            echo "  ${allgroup1Name}: ${allgroup1Count} requests - ${allgroup1Precentage}%"
            echo "  ${allgroup2Name}: ${allgroup2Count} requests - ${allgroup2Precentage}%"
            echo "  ${allgroup3Name}: ${allgroup3Count} requests - ${allgroup3Precentage}%"
            echo "  ${allgroup4Name}: ${allgroup4Count} requests - ${allgroup4Precentage}%"

            echo "Stats"
            
            echo "All Requests"
            echo "  total: ${all}"
            echo "  OK: ${allOk}"
            echo "  Nok: ${allKo}"
            echo "  Min: ${allMinResponseTimeTotal}"
            echo "  p50: ${allPercentiles1Total}"
            echo "  p75: ${allPercentiles2Total}"
            echo "  p95: ${allPercentiles3Total}"
            echo "  p99: ${allPercentiles4Total}"
            echo "  Max: ${allMaxResponseTimeTotal}"
            
            echo "validações"
            echo "  total: ${validacoes}"
            echo "  OK: ${validacoesOk}"
            echo "  Nok: ${validacoesKo}"
            echo "  Min: ${validacoesMin}"
            echo "  p50: ${validacoesp1}"
            echo "  p75: ${validacoesp2}"
            echo "  p95: ${validacoesp3}"
            echo "  p99: ${validacoesp4}"
            echo "  Max: ${validacoesMax}"

            echo "débitos"
            echo "  total: ${debitos}"
            echo "  OK: ${debitosOk}"
            echo "  Nok: ${debitosKo}"
            echo "  Min: ${debitosMin}"
            echo "  p50: ${debitosp1}"
            echo "  p75: ${debitosp2}"
            echo "  p95: ${debitosp3}"
            echo "  p99: ${debitosp4}"
            echo "  Max: ${debitosMax}"

            echo "créditos"
            echo "  total: ${creditos}"
            echo "  OK: ${creditosOk}"
            echo "  Nok: ${creditosKo}"
            echo "  Min: ${creditosMin}"
            echo "  p50: ${creditosp1}"
            echo "  p75: ${creditosp2}"
            echo "  p95: ${creditosp3}"
            echo "  p99: ${creditosp4}"
            echo "  Max: ${creditosMax}"

            echo "extratos"
            echo "  total: ${extratos}"
            echo "  OK: ${extratosOk}"
            echo "  Nok: ${extratosKo}"
            echo "  Min: ${extratosMin}"
            echo "  p50: ${extratosp1}"
            echo "  p75: ${extratosp2}"
            echo "  p95: ${extratosp3}"
            echo "  p99: ${extratosp4}"
            echo "  Max: ${extratosMax}"

            echo "Report End - ${executionTimestamp}"
            echo " "
        fi
    )
    done

}

genTextReport > $OUTPUT_REPORT
