#!/bin/bash
set -x 
GATLING_URL="https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/3.10.3/gatling-charts-highcharts-bundle-3.10.3-bundle.zip"
GATLING_HOME="$HOME/gatling"
curl -Ls -o /tmp/gatling.zip "$GATLING_URL"
mkdir -p "$GATLING_HOME"
unzip -o -q /tmp/gatling.zip -d "$GATLING_HOME"
ln -sf "$GATLING_HOME/gatling-charts-highcharts-bundle-3.10.3" "$GATLING_HOME/3.10.3"
ls -liah "$GATLING_HOME/3.10.3/bin/gatling.sh"