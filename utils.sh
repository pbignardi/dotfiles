#!/bin/bash

# Paolo Bignardi - 2025

function isFedora() {
    if ! [[ -f /etc/os-release ]]; then
        return 1
    fi
    source /etc/os-release
    test $ID == "fedora"
}

function isDebian() {
    if ! [[ -f /etc/os-release ]]; then
        return 1
    fi
    source /etc/os-release
    test $ID == "debian" || test $ID == "ubuntu" || test $ID == "linuxmint"
}

function isArchlinux() {
    if ! [[ -f /etc/os-release ]]; then
        return 1
    fi
    source /etc/os-release
    test $ID == "arch"
}

function isMac() {
    test "$(uname -s)" == "Darwin"
}

function isWsl() {
    command -v powershell.exe &> /dev/null
}

function isLinux() {
    test "$(uname -s)" == "Linux"
}
