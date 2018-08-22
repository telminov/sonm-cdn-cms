# CSM
CMS is the element of [SONM CDN](https://github.com/telminov/sonm-cdn-node-manager/blob/master/SONM%20CDN.md)

Content management CMS. CRUD + rest API to the CDN nodes can follow the updates

## Installation
Install example on Digital Ocean instance with Ubuntu Server 18.04

Need installed packages: 
- python 2.X (for ansible)
- virtualenv 
- pip
- ansible


### use command line
Referens installation descripted in ansible-playbook - https://github.com/telminov/sonm-cdn-cms/blob/master/ansible/install.yml

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

### use installation script (Ubuntu/MacOS)
run for project directory
```
/bin/sh install.sh -a "INSTANCE_HOST_IP" -n "HOSTNAME" -p PORT
```

## Create first user
```
ssh root@INSTANCE_HOST_IP
docker exec -ti sonm-cms bash -c 'python3 ./manage.py createsuperuser'
```


## Add file
Go to Admin interface and a file - /admin/core/asset/. The file content will be available at /asset/<file-uuid> at CMS and at cdn nodes.
