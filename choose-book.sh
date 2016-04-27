#!/bin/bash

BOOK_DIR=~/annex/documents/books

list () {
    find $BOOK_DIR -type f
}

choose () {
    list | rofi -dmenu
}

open () {
    local BOOK="$1"
    test -f "$BOOK" && xdg-open "$BOOK"
}

open "$(choose)"
