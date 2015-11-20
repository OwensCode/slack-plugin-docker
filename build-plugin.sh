#!/bin/sh

print_usage() {
    script=$(basename "$0")

    cat <<HERE_DOC

$script [-h] [-d]

Build the slack-plugin project using a docker container.

    h: print help message
    n: not a clean build; incremental. Slightly faster, but not much.

HERE_DOC
}

CLEAN="clean"

while getopts ":hn" opt; do
    case $opt in
        n)
            echo "Performing incremental build; no clean" >&2
            CLEAN=
            ;;
        h)
            print_usage
            exit
            ;;
        \?)
            echo "Unexpected option: -$OPTARG. Use -h for help." >&2
            exit 1
            ;;
    esac
done

docker run --rm -t -i \
    -v "$PWD"/../slack-plugin:/slack-plugin \
    -v "$PWD"/../slack-plugin-docker/m2repo:/var/m2repo \
    slack-plugin-build \
    mvn $CLEAN install

