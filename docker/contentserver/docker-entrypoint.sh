#!/bin/bash
set -e

. /opt/documentum/product/20.2/bin/dm_set_server_env.sh

function shutdown() {
  /opt/documentum/dba/dm_shutdown_dctm
  /opt/documentum/dba/dm_stop_Docbroker
}

trap shutdown SIGHUP SIGINT SIGTERM

/opt/documentum/dba/dm_launch_Docbroker

if [ ! -d /opt/documentum/dba/config/dctm ]; then
    echo "Create repository"
    /opt/documentum/product/20.2/install/dm_launch_server_config_program.sh -f /home/dmadmin/repository.properties
	echo "Stopping the repository"
    /opt/documentum/dba/dm_shutdown_dctm
fi

/opt/documentum/dba/dm_start_dctm

exec $@