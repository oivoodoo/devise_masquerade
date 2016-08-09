#!/usr/bin/env bash

set -e

function red() {
    echo -e "\e[00;31m$1\e[00m"
}

(cd spec/dummy/ && RAILS_ENV=test bundle exec rake db:setup && cd ../../ && bundle exec rspec && bundle exec cucumber) || { red "Failed specs"; exit 1; }
