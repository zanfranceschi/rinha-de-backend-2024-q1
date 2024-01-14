GATLING_BIN_DIR=$HOME/gatling/3.10.3/bin

WORKSPACE="$(pwd)/user-files"

sh $GATLING_BIN_DIR/gatling.sh -rm local -s RinhaBackendDebitosCreditosSimulation \
    -rd "Rinha de Backend - 2024/Q1: Crébito" \
    -rf $WORKSPACE/results \
    -sf $WORKSPACE/simulations
