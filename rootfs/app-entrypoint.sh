#!/bin/bash
set -e

function initialize {
    # Package can be "installed" or "unpacked"
    status=`nami inspect $1`
    if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
        # Clean up inputs
        inputs=""
        if [[ -f /$1-inputs.json ]]; then
            inputs=--inputs-file=/$1-inputs.json
        fi
        nami initialize $1 $inputs
    fi
}

# Set default values
export APACHE_HTTP_PORT=${APACHE_HTTP_PORT:-"80"}
export APACHE_HTTPS_PORT=${APACHE_HTTPS_PORT:-"443"}
export SUGARCRM_USER_NAME=${SUGARCRM_USER_NAME:-"User"}
export SUGARCRM_LAST_NAME=${SUGARCRM_LAST_NAME:-"Name"}
export SUGARCRM_PASSWORD=${SUGARCRM_PASSWORD:-"bitnami"}
export SUGARCRM_EMAIL=${SUGARCRM_EMAIL:-"user@example.com"}
export MARIADB_USER=${MARIADB_USER:-"root"}
export MARIADB_HOST=${MARIADB_HOST:-"mariadb"}
export MARIADB_PORT=${MARIADB_PORT:-"3306"}

# Adding cron entries
ln -fs /opt/bitnami/sugarcrm/conf/cron /etc/cron.d/sugarcrm


if [[ "$1" == "nami" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   for module in apache php sugarcrm; do
    initialize $module
   done
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
