#!/bin/bash

DATE=`date "+%Y%m%d-%H%M%S"`
LOG=$(mktemp)

if [ ! $# -eq 3 ] && [ ! $# -eq 2 ]; then
    echo "Usage $0 <remote:source> <destination> [email]"
    exit 1
fi

SRC=$1
DEST=$2
EMAIL=$3

NAME=$(basename $SRC)

_rsync () {
    rsync -aH --log-file=$LOG --link-dest=../current $SRC $DEST/incomplete-$DATE
}

update_symlink () {
    cd $DEST \
        && mv incomplete-$DATE $NAME-$DATE \
        && rm -f current \
        && ln -s $NAME-$DATE current
}

backup () {
    OUTPUT=$(_rsync && update_symlink 2>&1)
    local RET=$?
    if [ $RET -eq 0 ]; then
        STATUS="successful"
    else
        STATUS="failed"
    fi
}

_mail () {
    if [ -n "$EMAIL" ]; then
        mail -s "$STATUS backup $SRC $DATE" $EMAIL
    fi
}

email () {
    {
        cat <<EOF
Status:
$STATUS

------------------------------------------------------------------------

Output:
$OUTPUT

------------------------------------------------------------------------

Log:
$(cat $LOG)
EOF
    } | _mail
}

cleanup () {
    rm -fr $LOG
}

trap cleanup EXIT

backup
email
