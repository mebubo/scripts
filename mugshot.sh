#!/bin/bash

DEST_DIR=$HOME/annex/img/mugshots/

fswebcam -r 640x480 --no-banner $DEST_DIR/$(date +%y%m%d-%H%M%S).jpg
