#!/bin/sh

# install to run via cron. the following example will run every minute
#* * * * * <this script>

MEDIA_ROOT=/br_media
SPAWN_PROGRAM=/usr/local/freeswitch/scripts/xfer.pl
FILES=`find ${MEDIA_ROOT} -name '*.xfer'`

for file in $FILES
do
    if [ ! -f ${file}.* ]; then
        if [ -x ${SPAWN_PROGRAM} ]; then
            ${SPAWN_PROGRAM} ${file} &>${file}.progress &
        fi
    fi
done

