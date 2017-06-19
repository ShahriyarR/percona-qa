@test "run pmm-admin under regular(non-root) user privileges" {
if [[ $(id -u) -eq 0 ]] ; then
	skip "Skipping this test, because you are running under root"
fi
run pmm-admin
echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "pmm-admin requires superuser privileges to manage system services." ]
}


@test "run pmm-admin under root privileges" {
if [[ $(id -u) -ne 0 ]] ; then
	skip "Skipping this test, because you are NOT running under root"
fi
run pmm-admin
echo "$output"
    [ "$status" -eq 1 ]
    [ "${lines[0]}" = "Usage:" ]
}

@test "run pmm-admin add mongodb" {
	COUNTER=0
  for i in $(sudo pmm-admin list | grep "mongo" | awk '{print $5}' | grep -v '-') ; do
		let COUNTER=COUNTER+1
		URI=${i}
	  run sudo pmm-admin add mongodb --uri ${URI} mongodb_instance_${COUNTER}
	  [ "$status" -eq 0 ]
	  #echo "${lines[0]}" | grep "OK, already"
	  echo "${lines[1]}" | grep "OK, now monitoring"
  done
}

@test "run pmm-admin add mongodb again" {
	COUNTER=0
	for i in $(sudo pmm-admin list | grep "mongo" | awk '{print $5}' | grep -v '-') ; do
		let COUNTER=COUNTER+1
		URI=${i}
		run sudo pmm-admin add mongodb --uri ${URI} mongodb_instance_${COUNTER}
		[ "$status" -eq 0 ]
		#echo "${lines[0]}" | grep "OK, already"
		echo "${lines[1]}" | grep "OK, already"
	done
}

# @test "run pmm-admin add mongodb named" {
#   run sudo pmm-admin add mongodb mymongo1
#   [ "$status" -eq 0 ]
#   echo "${lines[0]}" | grep "OK, already"
#   echo "${lines[1]}" | grep "OK, now monitoring"
# }
#
# @test "run pmm-admin add mongodb name again" {
#   run sudo pmm-admin add mongodb mymongo1
#   [ "$status" -eq 0 ]
#   echo "${lines[0]}" | grep "OK, already"
#   echo "${lines[1]}" | grep "OK, already"
# }

@test "run pmm-admin rm mongodb" {
  run sudo pmm-admin rm mongodb
  [ "$status" -eq 0 ]
  echo "${lines[0]}" | grep "OK, no system"
  echo "${lines[1]}" | grep "OK, removed"
}

@test "run pmm-admin rm mongodb named" {
  run sudo pmm-admin rm mongodb mymongo1
  [ "$status" -eq 0 ]
  echo "${lines[0]}" | grep "OK, no system"
  echo "${lines[1]}" | grep "OK, removed"
}

@test "run pmm-admin add mongodb queries" {
  run sudo pmm-admin add mongodb mongo-queries --dev-enable
  [ "$status" -eq 0 ]
  echo "${lines[0]}" | grep "OK, already"
  echo "${lines[1]}" | grep "OK, now monitoring"
}

@test "run pmm-admin rm mongodb queries" {
  run sudo pmm-admin rm mongodb mongo-queries --dev-enable
  [ "$status" -eq 0 ]
  echo "${lines[0]}" | grep "OK, no system"
  echo "${lines[1]}" | grep "OK, removed"
}
