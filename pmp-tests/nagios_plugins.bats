# Created by Shahriyar Rzayev(Shako) from Percona
# PMP for Nagios things...


@test "run pmp-check-mysql-deadlocks test" {
command_status=$(su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-deadlocks -H 127.0.0.1 -i 1 -w 0 -c 60")
echo "$output"
    echo "${command_status}" | grep "OK"
}

@test "run pmp-check-unix-memory test" {
  command_status=$(su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-unix-memory")
  echo "$output"
  echo "${command_status}" | grep "OK"
}

@test "run pmp-check-pt-table-checksum test" {
  command_status=$(su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-pt-table-checksum")
  echo "$output"
  echo "${command_status}" | grep "OK"
}

@test "run pmp-check-mysql-ts-count test" {
  command_status=$(su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-ts-count")
  echo "$output"
  echo "${command_status}" | grep "OK"
}

@test "run pmp-check-mysql-status without options" {
  # Should give error with status 3
  run su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-status"
  echo $output
  [ "$status" -eq 3 ]
}

@test "run pmp-check-mysql-status with some options" {
  command_status=$(su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-status -x Created_tmp_disk_tables -o / -y Uptime -I 5 -w 10")
  echo $output
  echo "${command_status}" | grep "OK"
}

@test "run pmp-check-mysql-replication-running without options" {
  commant_status=$(su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-replication-running --master-conn")
  echo $output
  echo "${commant_status}" |  grep "OK"
}

@test "run pmp-check-mysql-replication-running with --master-conn" {
  # Should give a syntax error here
  run su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-replication-running --master-conn fff"
  echo $output
  [ "$status" -eq 3 ]
}

@test "run pmp-check-mysql-replication-delay with --unconfigured" {
  # Should give UNK
  run su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-replication-delay --unconfigured"
  echo $output
  [ "$status" -eq 3 ]
}

@test "run pmp-check-mysql-replication-delay without any option" {
  commant_status=$(su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-replication-delay")
  echo $output
  echo "${commant_status}" |  grep "OK"
}

@test "run pmp-check-mysql-processlist without any option" {
  commant_status=$(su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-processlist")
  echo $output
  echo "${commant_status}" |  grep "OK"
}

@test "run pmp-check-mysql-processlist with -C wrong value" {
  # Should give an Error
  run su -l nagios -c "env -i HOME=/usr/local/nagios /usr/local/nagios/libexec/pmp-check-mysql-processlist -w 1 -C sddfsdf"
  echo $output
  [ "$status" -eq 3 ]
}
