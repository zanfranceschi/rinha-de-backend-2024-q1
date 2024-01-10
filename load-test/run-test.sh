GATLING_BIN_DIR=$HOME/gatling/3.9.5/bin

WORKSPACE=$HOME/projects/rinha-de-backend-2024-q1/load-test

sh $GATLING_BIN_DIR/gatling.sh -rm local -s RinhaBackendDebitosCreditosSimulation \
    -rd "Rinha de Backend - 2024/Q1: Crébito" \
    -rf $WORKSPACE/user-files/results \
    -sf $WORKSPACE/user-files/simulations \
    -rsf $WORKSPACE/user-files/resources \
