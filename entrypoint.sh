#!/bin/bash

DATAPATH="/data"
TSPATH="/usr/local/bin/teamspeak3"

#   Setup the trap
function stop {
    PID=$(ps -C "ts3server" -o pid=)
    kill $PID
    wait $PID
    exit
}

trap stop EXIT

#   Create the group
if [ $GID -ne 0 ]
then
    GROUP=service
    groupadd -g $GID $GROUP
else
    GROUP=root
fi

#   Create the user
if [ $UID -ne 0 ]
then
    USER=service
    useradd -r -s /bin/false -u $UID -g $GROUP $USER
else
    USER=root
fi

cd $DATAPATH

#   Create the ini file if it does not exist yet
if [ ! -e ${DATAPATH}/ts3server.ini ]
then
    ${TSPATH}/ts3server createinifile=1
fi

#   Generate the SQLite database if needed and link it to the data directory
if [ ! -e ${DATAPATH}/ts3server.sqlitedb ]
then
    ${TSPATH}/ts3server_minimal_runscript.sh inifile=/data/ts3server.ini & PID=$! && kill $PID && wait $PID
    mv ${TSPATH}/ts3server.sqlitedb $DATAPATH
else
    rm ${TSPATH}/ts3server.sqlitedb
fi

ln -s ${DATAPATH}/ts3server.sqlitedb ${TSPATH}/ts3server.sqlitedb

#   Create the files directory and link it to the data directory
if [ ! -e ${DATAPATH}/files ]
then
    if [ -e ${TSPATH}/files ]
    then
        mv ${TSPATH}/files $DATAPATH
    else
        mkdir ${DATAPATH}/files
    fi
else
    rm -r ${TSPATH}/files
fi

ln -s ${DATAPATH}/files ${TSPATH}/files

#   Make shure that the user is the owner
chown -R $USER:$GROUP $TSPATH $DATAPATH

#   Start up the server as the given user
su -c "${TSPATH}/ts3server_minimal_runscript.sh inifile=/data/ts3server.ini" -s /bin/bash $USER

