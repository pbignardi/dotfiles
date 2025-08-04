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
    test $ID == "debian"
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
    test $(which powershell.exe &> /dev/null)
}

function isLinux() {
    test "$(uname -s)" == "Linux"
}

function bw_login() {
    bw_session=${BW_SESSION:-}
    if [[ -z $bw_session ]]; then
        _info "Login Bitwarden CLI"
        export BW_SESSION=$(bw login --raw || bw unlock --raw)
    fi
}
