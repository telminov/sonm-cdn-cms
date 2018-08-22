#!/bin/sh
# /bin/sh install.sh -a "INSTANCE_HOST_IP" -n "hostname" -p port


ERROR='\033[0;31m'
INFO='\033[1;34m'
NC='\033[m'
SUCCESS='\033[0;32m'

INSTANCE_HOST_IP=''
hostname=''
port=''

function check_error {
    if [ $? -ne 0 ]; then
      echo "${ERROR}ERROR";
        exit 1
      else
        echo "${SUCCESS}SUCCESS";
    fi
}

while getopts ":a:n:p:" opt; do
  case $opt in
    a) INSTANCE_HOST_IP="$OPTARG"
    ;;
    n) hostname="$OPTARG"
    ;;
    p) port="$OPTARG"
    ;;
    \?) echo "${ERROR}ERROR: ${NC}Invalid option -$OPTARG"; exit 1
    ;;
  esac
done

if [[ $INSTANCE_HOST_IP = "" ]]; then
   echo "${ERROR}ERROR: ${NC}Parameter INSTANCE_HOST_IP \"-a\" has been not empty";
fi

if [[ $hostname = "" ]]; then
   echo "${ERROR}ERROR: ${NC}Parameter hostname \"-n\" has been not empty";
fi

if [[ $port = "" ]]; then
   echo "${ERROR}ERROR: ${NC}Parameter port \"-p\" has been not empty";
fi

if [[ $hostname = ""  ||  $INSTANCE_HOST_IP = "" ||  $port = "" ]]; then
   exit 1
fi


echo "== INSTALATION SONM CDN CMS =="
echo "PORT:    " $port
echo "HOST:    " $hostname
echo "ADDRESS: " $INSTANCE_HOST_IP

echo "\n${INFO}Install python for remote host ... ${NC}"
ssh root@$INSTANCE_HOST_IP apt-get install -y python
check_error

if [ -d "./venv" ]; then
    echo "\n${INFO}Set virtual environment (venv) ...${NC}"
    source ./venv/bin/activate
    check_error
else
  echo "\n${INFO}Create virtual environment for ansible ... ${NC}"
  virtualenv venv
  check_error

  echo "\n${INFO}Set virtual environment (venv) ...${NC}"
  source ./venv/bin/activate
  check_error

  echo "\n${INFO}Install pip for current system ...${NC}"
  curl https://bootstrap.pypa.io/get-pip.py | python
  check_error
fi

echo "\n${INFO}Install ansible from ansible/requirements.txt ...${NC}"
pip install -r ansible/requirements.txt
check_error

echo "\n${INFO}Set INSTANCE_HOST_IP to ansible/inventory file ...${NC}"
echo "$INSTANCE_HOST_IP" > ansible/inventory
echo "${SUCCESS}SUCCESS";

echo "\n${INFO}Run ansible playbook (ansible/intsall.yml)...${NC}"
ansible-playbook -i ansible/inventory -u root ansible/install.yml -e "web_server_name=$INSTANCE_HOST_IP service_port=$port"
check_error