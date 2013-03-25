#!/bin/bash

BOOK_DIR=~/documents/books/pdf

list_fullnames () {
    find $BOOK_DIR -name \*.pdf
}

get_basenames () {
    while read NAME; do
        echo $(basename "$NAME")
    done
}

choose () {
    list_fullnames | get_basenames | dmenu
}

open () {
    local BOOK="$1"
    evince $BOOK_DIR/"$BOOK"
}

open "$(choose)"
