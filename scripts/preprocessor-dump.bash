#!/bin/bash

[ "$1" = "supports" ] && {
    echo $@ >&2
    exit 0
}
STDIN=`cat`
echo -n "$STDIN" | jq --indent 4 > ./dump.json
echo -n "$STDIN" | jq -c '.[1]'
