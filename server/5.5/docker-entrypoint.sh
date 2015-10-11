#!/bin/bash

set -e

JOOMLA_PHP_VERSION='5.5'

if [[ "$1" == apache2* ]]; then
        if [ -n "$MYSQL_PORT_3306_TCP" ]; then
                if [ -z "$JOOMLA_DB_HOST" ]; then
                        JOOMLA_DB_HOST='mysql'
                else
                        echo >&2 "warning: both JOOMLA_DB_HOST and MYSQL_PORT_3306_TCP found"
                        echo >&2 "  Connecting to JOOMLA_DB_HOST ($JOOMLA_DB_HOST)"
                        echo >&2 "  instead of the linked mysql container"
                fi
        fi

        if [ -z "$JOOMLA_DB_HOST" ]; then
                echo >&2 "error: missing JOOMLA_DB_HOST and MYSQL_PORT_3306_TCP environment variables"
                echo >&2 "  Did you forget to --link some_mysql_container:mysql or set an external db"
                echo >&2 "  with -e JOOMLA_DB_HOST=hostname:port?"
                exit 1
        fi

        # If the DB user is 'root' then use the MySQL root password env var
        : ${JOOMLA_DB_USER:=root}
        if [ "$JOOMLA_DB_USER" = 'root' ]; then
                : ${JOOMLA_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
        fi

        if [ -z "$JOOMLA_TEST_APP_NAME" ]; then
                echo >&2 "error: missing required JOOMLA_TEST_APP_NAME environment variable"
                echo >&2 "  Did you forget to -e JOOMLA_TEST_APP_NAME=... ?"
                echo >&2
                echo >&2 "  (Also of interest might be JOOMLA_TEST_JOOMLA_VERSIONS and JOOMLA_TEST_APP_VERSIONS.)"
                exit 1
        fi

        if [ -z "$JOOMLA_TEST_JOOMLA_VERSIONS" ]; then
                echo >&2 "error: missing required JOOMLA_TEST_JOOMLA_VERSIONS environment variable"
                echo >&2 "  Did you forget to -e JOOMLA_TEST_JOOMLA_VERSIONS=... ?"
                echo >&2
                echo >&2 "  (Also of interest might be JOOMLA_TEST_APP_NAME and JOOMLA_TEST_APP_VERSIONS.)"
                exit 1
        fi

        if [ -z "$JOOMLA_TEST_APP_VERSIONS" ]; then
                echo >&2 "error: missing required JOOMLA_TEST_APP_VERSIONS environment variable"
                echo >&2 "  Did you forget to -e JOOMLA_TEST_APP_VERSIONS=... ?"
                echo >&2
                echo >&2 "  (Also of interest might be JOOMLA_TEST_APP_NAME and JOOMLA_TEST_JOOMLA_VERSIONS.)"
                exit 1
        fi

        if [ -z "$JOOMLA_DB_PASSWORD" ]; then
                echo >&2 "error: missing required JOOMLA_DB_PASSWORD environment variable"
                echo >&2 "  Did you forget to -e JOOMLA_DB_PASSWORD=... ?"
                echo >&2
                echo >&2 "  (Also of interest might be JOOMLA_DB_USER and JOOMLA_DB_NAME_PREFIX.)"
                exit 1
        fi

        # Ensure the MySQL Database is created
        php /usr/src/scripts/makedb.php "$JOOMLA_DB_HOST" "$JOOMLA_DB_USER" "$JOOMLA_DB_PASSWORD" "$JOOMLA_TEST_APP_NAME" "$JOOMLA_PHP_VERSION" "$JOOMLA_TEST_JOOMLA_VERSIONS" "$JOOMLA_TEST_APP_VERSIONS"

        echo >&2 "========================================================================"
        echo >&2
        echo >&2 "This server is now configured to run Joomla! tests"
        echo >&2 "You will need the following database information to install Joomla:"
        echo >&2 "Host Name: $JOOMLA_DB_HOST"
        echo >&2 "Database Username: $JOOMLA_DB_USER"
        echo >&2 "Database Password: $JOOMLA_DB_PASSWORD"
        echo >&2 "Databases Created: "$JOOMLA_TEST_APP_NAME"_"$JOOMLA_PHP_VERSION"_<Joomla Version>_<App Version>"
        echo >&2
        echo >&2 "========================================================================"
fi

exec "$@"
