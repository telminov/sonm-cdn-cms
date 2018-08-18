# CSM
Управление контентом CDN. CRUD + rest API, чтобы узлы CDN могли следить за обновлениями

## Installation
Install example on Digital Ocean instance with Ubuntu Server 18.04

install python on host
```
ssh root@INSTANCE_HOST_IP
apt install -y python
```

start install ansible-playbook
```
cd <project_path>/ansible
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
echo "INSTANCE_HOST_IP" > inventory

ansible-playbook -i inventory -u root install.yml -e "web_server_name=cms.cdn.sonm.soft-way.biz service_port=8082"
```
