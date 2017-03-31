#!/usr/bin/env bats

WORKDIR="${PWD}"
SCRIPT_PWD="$BATS_TEST_DIRNAME"


# pmm-framework.sh functions

function pmm_framework_setup() {
  run ${SCRIPT_PWD}/pmm-framework.sh --setup
}

function pmm_framework_add_clients() {
  run ${SCRIPT_PWD}/pmm-framework.sh --addclient=$1,$2
}

function pmm_wipe_all() {
  run ${SCRIPT_PWD}/pmm-framework.sh --wipe
}

function pmm_wipe_clients() {
  run ${SCRIPT_PWD}/pmm-framework.sh --wipe-clients
}

function  pmm_wipe_server() {
  run ${SCRIPT_PWD}/pmm-framework.sh --wipe-server
}

# functions for bats calling

function run_linux_metrics_tests() {
  bats ${SCRIPT_PWD}/linux-metrics.bats
}

function run_generic_tests() {
  run bats ${SCRIPT_PWD}/generic-tests.bats
}

function run_ps_specific_tests() {
  run bats ${SCRIPT_PWD}/ps-specific-tests.bats
}

function run_pxc_specific_tests() {
  run bats ${SCRIPT_PWD}/pxc-specific-tests.bats
}

function run_mongodb_specific_tests() {
  run bats ${SCRIPT_PWD}/mongodb-tests.bats
}

function run_proxysql_tests() {
  run bats ${SCRIPT_PWD}/proxysql-tests.bats
}

# Additional functions
function run_create_table() {
  run bash ${SCRIPT_PWD}/create_table.sh $1 $2
}


if [[ $instance_t != "mo" ]] ; then
  run_linux_metrics_tests
fi
