# Adding tests for gui tests here

DIR="pmm-qa"

@test "run pmm gui tests" {
  if [ ! -d "$DIR" ]; then
    git clone https://github.com/Percona-QA/pmm-qa.git
    cd pmm-qa
    git pull
  fi
  run bash ~/$DIR/start.sh config_saucelabs.js $url
}
