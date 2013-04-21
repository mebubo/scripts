#!/bin/sh

DATE=`date "+%Y%m%d-%H%M%S"`
SRC=/home/mebubo/annex/
REMOTE=mebubo@192.168.0.65
DEST=/store/sdbackup/backups/mebub
NAME=annex
EMAIL=dolgovs@gmail.com
LOG=$(mktemp)

_rsync () {
    rsync -aH --log-file=$LOG --link-dest=../current $REMOTE:$SRC $DEST/incomplete-$DATE
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
    mail -s "$STATUS backup $NAME $REMOTE $DATE" $EMAIL
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
