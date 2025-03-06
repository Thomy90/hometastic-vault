#!/bin/bash -e

(
    cd "$(dirname "$0")"

    FREQUENCY=${1:-daily}
    COUNT=${2:-0}

    sqlite3 data/db.sqlite3 ".backup data/db.sqlite3.bak"

    BACKUP_FILE=/tmp/vaultwarden-backup-${FREQUENCY}-${COUNT}.tar.gz

    tar --exclude=db.sqlite3 --exclude=db.sqlite3-* -czf ${BACKUP_FILE} data

    lftp vault.home.tastic.nas -e "set ftp:ssl-allow no; mkdir -f -p ${FREQUENCY}; put -O ${FREQUENCY} ${BACKUP_FILE}; quit"

    echo -n "Successfully transferred : " ; du -h ${BACKUP_FILE}
)
