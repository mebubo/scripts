#!/bin/bash

activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")

activeWinId=${activeWinLine:40}

FILENAME="/tmp/$(date +%F_%H%M%S_%N).png"

import -window "$activeWinId" "$FILENAME"

echo "$FILENAME" | xsel -i
