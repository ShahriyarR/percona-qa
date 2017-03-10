CLIENT_NAME=$1
WORKDIR="${PWD}"
MYSQL_USER=root

function add_tables() {
  #mkdir -p $WORKDIR/logs
  #for i in ${ADDCLIENT[@]};do
    #CLIENT_NAME=$(echo $i | grep -o  '[[:alpha:]]*')
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

    for i in $(sudo pmm-admin list | grep "mysql:metrics" | sed 's|.*(||;s|)||') ; do
      let COUNTER=COUNTER+1
			MYSQL_SOCK=${i}
      for num in $(seq 1 1 100)
			    ${BASEDIR}/bin/mysql --user=${MYSQL_USER} --socket=${MYSQL_SOCK} -e "create table t${num}(id int not null)"
      done
		done
}

add_tables
