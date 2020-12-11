#!/bin/sh
set -e

# Check environment
if [ -z "${DATABASE_URL}" ]; then
    echo "DATABASE_URL is not set!" 1>&2 && exit 1
fi
if [ -z "${POSTGRES_SECRET_FILE}" ]; then
    echo "POSTGRES_SECRET_FILE is not set!" 1>&2 && exit 1
fi
if [ -z "${POSTGRES_VERSION}" ]; then
    echo "POSTGRES_VERSION is not set!" 1>&2 && exit 1
fi
if [ -z "${POSTGIS_VERSION}" ]; then
    echo "POSTGIS_VERSION is not set!" 1>&2 && exit 1
fi

# Create database and build indices
if [ "${NOMINATIM_MODE}" = "CREATE" ]; then
    if [ -z "${OSMFILE}" ]; then
        echo "OSMFILE is not set!" 1>&2 && exit 1
    fi
    if [ -z "${THREADS}" ]; then
        THREADS=2
    fi
    PGDIR=postgresdata
    curl -o /srv/nominatim/data/country_osm_grid.sql.gz https://www.nominatim.org/data/country_grid.sql.gz
    cp /srv/nominatim/build/module/nominatim.so /module/nominatim.so
    chmod a+r /module/nominatim.so
    chmod a+x /module/nominatim.so
    rm -rf /data/$PGDIR
    mkdir -p /data/$PGDIR

    export  PGDATA=/data/$PGDIR
    /srv/nominatim/build/utils/setup.php --osm-file $OSMFILE --all --threads $THREADS
    /srv/nominatim/build/utils/check_import_finished.php
fi

# Tail Apache logs
tail -f /var/log/apache2/* &

# Run Apache in the foreground
/usr/sbin/apache2ctl -D FOREGROUND
