#!/bin/bash

# download coursera videos

if [ ! $# -eq 2 ]; then
    echo "Usage: $0 <cookie header> <index page url>"
    exit 1
fi

COOKIE_HEADER="$1"
INDEX_URL="$2"

shift 2

EXTRACT_PATTERN="${EXTRACT_PATTERN-.mp4}"

_wget () {
    wget -c --content-disposition --header "$COOKIE_HEADER" "$@"
}

dl_index () {
    _wget -O - "$INDEX_URL"
}

extract_urls () {
    grep "$EXTRACT_PATTERN" | while read LINE; do
        URL="${LINE#*href=\"}"
        echo "${URL%\"}"
    done
}

dl_files () {
    while read URL; do
        _wget "$URL"
    done
}

dl_index | extract_urls | dl_files
