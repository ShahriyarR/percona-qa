#!/bin/bash
CLIENT_NAME=$1
WORKDIR="${PWD}"
MYSQL_USER=root

if [[ "${CLIENT_NAME}" == "ps" ]]; then
  BASEDIR=$(ls -1td ?ercona-?erver-5.* | grep -v ".tar" | head -n1)
  BASEDIR="$WORKDIR/$BASEDIR"

elif [[ "${CLIENT_NAME}" == "ms" ]]; then
  BASEDIR=$(ls -1td mysql-5.* | grep -v ".tar" | head -n1)
  BASEDIR="$WORKDIR/$BASEDIR"

elif [[ "${CLIENT_NAME}" == "pxc" ]]; then
  BASEDIR=$(ls -1td Percona-XtraDB-Cluster-5.* | grep -v ".tar" | head -n1)
  BASEDIR="$WORKDIR/$BASEDIR"
fi

for i in $(sudo pmm-admin list | grep 'mysql:metrics[ \t]*PS_NODE' | awk -F[\(\)] '{print $2}') ; do
	MYSQL_SOCK=${i}
  echo "Selecting databases"
	${BASEDIR}/bin/mysql --user=${MYSQL_USER} --socket=${MYSQL_SOCK} -e "select schema_name from information_schema.schemata where schema_name not in ('mysql', 'information_schema', 'performance_schema', 'sys')"
done
