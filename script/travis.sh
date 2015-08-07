#!/usr/bin/env bash

set -e

function red() {
    echo -e "\e[00;31m$1\e[00m"
}

(bundle exec rspec && bundle exec cucumber) || { red "Failed specs"; exit 1; }
