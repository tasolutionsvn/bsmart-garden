#!/bin/bash

# RUN
# . setup.sh

GITHUB_TOKEN="${GITHUB_TOKEN:-}"
branch="master"
github_api="https://api.github.com/repos/tasolutionsvn/activation/contents"

workingDir="$(pwd)";
if [ "$1" ]; then
    workingDir="$(echo -n $1)"
    mkdir -p $workingDir;
fi

# System update
curl_bin=$(which curl)
if [ "$curl_bin" = '' ]; then
    echo 'Install curl'
    apt-get -qqy update
    apt-get -qqy install curl 1>/dev/null
fi

# Download file setup

if [ -z $GITHUB_TOKEN ]; then
    read -p "Enter a Github key: " GITHUB_TOKEN
fi

countFiles=$(ls -l "$workingDir/persistent.sh" 2>/dev/null | wc -l)
if [ $countFiles -ge 1 ]; then
    echo 'Downloaded persistent.sh'
    return
fi

# Continue if not download yet
if [ ${#GITHUB_TOKEN} -eq 0 ]; then
    read -p "Enter a Github key: " GITHUB_TOKEN
    export GITHUB_TOKEN=$GITHUB_TOKEN
fi

curl -sL -H "Accept: application/vnd.github.v4.raw" -H "Authorization: token $GITHUB_TOKEN" -o "$workingDir/persistent.sh" "$github_api/persistent.sh?ref=$branch"

if [ -f $workingDir/persistent.sh ]; then 
    . $workingDir/persistent.sh $workingDir
else 
    echo 'Cannot download the file'
fi