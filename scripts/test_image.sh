#!/bin/bash

set -e

error() {
    echo "ERROR: ${1}"
    exit 1
}

cleanup() {
    rm -rf ${temp_backend}
}

trap cleanup EXIT

if [ $# -eq 0 ] || [ $# -gt 2 ];
then
    error "Usage: ${0} [-i] <QCOW2.IMG>"
fi

if ! command -v transient &> /dev/null
then
    error "transient command not found"
fi

automatic_test() {
    temp_backend=$(mktemp -d)
    output=$(transient run -image-backend ${temp_backend} -image ${1},file=${1} -sshs \
                       -ssh-command "echo ssh working" -- \
                       -m 1G -smp 2 -machine accel=kvm:tcg)

    if echo $output | grep -qv "Linux version"; then
        error "Serial output not working as expected"
    fi

    if echo $output | grep -qv "ssh working"; then
        error "SSH output not working as expected"
    fi
}

interactive_test() {
    temp_backend=$(mktemp -d)
    transient run -image-backend ${temp_backend} -image ${1},file=${1} -sshs \
                   -ssh-timeout 780 -shutdown-timeout 500 -- \
                   -m 1G -smp 2 -machine accel=kvm:tcg
}

if [ "$1" == "-i" ]; then
    interactive_test ${2}
else
    automatic_test ${1}
    echo "Passed"
fi
