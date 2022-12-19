#!/bin/bash

# RUN
# . setup.sh

GITHUB_TOKEN="${GITHUB_TOKEN:-}"
branch="master"
github_api="https://api.github.com/repos/tasolutionsvn/bsmart-gateway/contents"


# System update
curl_bin=$(which curl)
if [ "$curl_bin" = '' ]; then
    echo 'Install curl'
    apt-get -qqy update
    apt-get -qqy install curl 1>/dev/null
fi

# Download file setup

countFiles=$(ls -l "setup.sh" 2>/dev/null | wc -l)
if [ $countFiles -ge 1 ]; then
    echo 'Downloaded agent'
    return
fi

# Continue if not download yet
if [ ${#GITHUB_TOKEN} -eq 0 ]; then
    read -p "Enter a Github key: " GITHUB_TOKEN
    export GITHUB_TOKEN=$GITHUB_TOKEN
fi

curl -sL -H "Accept: application/vnd.github.v4.raw" \
    -H "Authorization: token $GITHUB_TOKEN" \
    -o "setup.sh" \
    "$github_api/setup.sh?ref=$branch"

if [ -f setup.sh ]; then 
    . setup.sh
else 
    echo 'Cannot download the file'
fi