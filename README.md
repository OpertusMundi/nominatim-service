# Nominatim service

Recipe to deploy [OSM nominatim](https://nominatim.org) with docker-compose.

## Build and run

Copy `.env.example` to `.env` and configure as needed.

Copy `compose.yml.example` to `compose.yml` (or `docker-compose.yml`) and adjust to your needs (e.g. specify volume source locations etc.). You will at least need to configure the network (inside `compose.yml`) to attach to.

For example, you can create a private network named `opertusmundi_network`:

    docker network create --attachable opertusmundi_network

Build:

    docker-compose -f compose.yml build

Prepare the following files/directories (directory and file names are indicative, since they could be changed in environment variables):

   * `./osm_data/*.osm.pbf`:  the OSM pbf file (download for [here](https://planet.openstreetmap.org) for the whole planet or e.g. from [geofabrik.de](https://download.geofabrik.de) for partial -testing- data),
   * `./secrets/postgres`: file containing the password for the PostGIS database user,
   * `/tmp/nominatim/module`: in case PostgreSQL is running outside the container (default case), prepare a directory into which the compiled module `nominatim.so` will be written.

A PostGIS super-user should be passed to nominatim, in order to prepare the database. However, the web application is connected by default to the database with a user `www-data`, which **should have been created in the database manually** before running the application.

Start application:

    docker-compose -f compose.yml up

## Environment variables

* `DATABASE_URL`: The database URL in the form `postgresql://user@host:port/database`.
* `POSTGRES_SECRET_FILE`: The secret file path containing the PostgreSQL (super)user password.
* `POSTGRES_VERSION`: The PostgreSQL version (>=9.3).
* `POSTGIS_VERSION`: The PostGIS version (>=2.2).
* `DATABASE_MODULE_PATH`: The path for the database module.
* `NOMINATIM_MODE`: If set to `CREATE`, the contents of the OSM file will be ingested into PostgreSQL.
**NOTE**: Database will be created; if it already exists, execution fails.
* `OSMFILE`: The OSM pbf file path (required only if `NOMINATIM_MODE=CREATE`).
* `THREADS`: The number of threads to be used for database preparation (default: 2).
* `REPLICATION_URL`: The upstream URL for data replication (set only if replication is desired).
* `REPLICATION_UPDATE_INTERVAL`: How often upstream publishes diffs (in seconds).
* `REPLICATION_RECHECK_INTERVAL`: How long to sleep if no update found yet (in seconds).
