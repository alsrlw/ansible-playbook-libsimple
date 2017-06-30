# Library Simplified Ansible Provisioner (Circulation Server)
This [Ansible playbook](http://docs.ansible.com/ansible/) will provision a [Library Simplified circulation server]
(https://github.com/NYPL-Simplified/circulation/) on Amazon Web Services (AWS). 

## Deploy Using Vagrant for Local Dev/Test
_Because it uses local docker containers to provide Elasticsearch and PostgreSQL, the `provision-vagrant.yml` playbook is not suitable for production._ 

This repository includes a `Vagrantfile` which will create the target virtual machine for you on your local workstation and run the playbook against that newly created virtual machine. 

1. [Install Ansible](http://docs.ansible.com/ansible/intro_installation.html) according to the instructions for the OS of the control machine
2. [Install Vagrant](https://www.vagrantup.com/docs/installation/) as well as a compatible hypervisor (VirtualBox, VMware, etc.)
3. Clone this repository to the control machine
5. Copy the file in `group_vars/all/main.yml.sample` to `group_vars/all/main.yml` and add your own values inside the blank quotes.
4. Open a terminal, `cd` into the repository root directory, and run:
```
vagrant up
```

## Deploy to Amazon Web Services
Ansible will connect to AWS and create the necessary AWS objects, then connect to your target EC2 server and put all of the Library Simplified components in place. 

### Requirements & Usage
You will need:
- An AWS account 
- A [control machine](http://docs.ansible.com/ansible/intro_installation.html) running Linux or MacOS (i.e. your workstation)
- AWS Identity and Access Management (IAM) account with credentials that have been granted the following permissions:
  - AmazonEC2FullAccess
  - AmazonRDSFullAccess
  - AmazonVPCFullAccess
  - AmazonESFullAccess

1. [Install Ansible](http://docs.ansible.com/ansible/intro_installation.html) according to the instructions for the OS of the control machine
2. Install [`python-boto`](https://pypi.python.org/pypi/boto) on the control machine
3. Add a file named `.boto` to your home directory on the control (administrator's local) machine with the following:
```
[Credentials]
aws_access_key_id = YOUR_AWS_ACCESS_KEY
aws_secret_access_key = YOUR_AWS_SECRET_ACCESS_KEY
```
4. Clone this repository to your control machine
5. Copy the file in `group_vars/all/main.yml.sample` to `group_vars/all/main.yml` and add your own values inside the blank quotes. Optionally, adjust the values as needed in `/roles/libsimple-aws-objects/defaults/main.yml` 
6. Open a terminal, `cd` into the repository root directory, and run:
```
ansible-playbook -i localhost provision-aws.yml -vv
```

