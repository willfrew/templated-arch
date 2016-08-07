# TODO configurable logging level

function debug(){
  if [[ "$DEBUG" == "true" ]]; then
    echo "$1"
  fi
}

function info(){
  echo "$1"
}

function fatal(){
  echo "\e[91m$1\e[0m"
  exit 1
}
