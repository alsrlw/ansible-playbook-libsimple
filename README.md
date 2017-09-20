# Library Simplified Ansible Provisioner (Circulation Server)
This set of automation files using [Vagrant](http://https://www.vagrantup.com/) and [Ansible](http://docs.ansible.com/ansible/) will provision a [Library Simplified circulation server](https://github.com/NYPL-Simplified/circulation/) in a variety of development environments. 

*Deployment Options:*
* [Deploy Using Vagrant to Local VM for Dev Testing](#vagrant-local)
* [Deploy Using Ansible to Amazon Web Services](#ansible-aws)
* [Deploy Using Vagrant to Linode.com (Single)](#vagrant-linode-single)


<a name="vagrant-local"></a>
## Deploy Using Vagrant to Local VM for Dev Testing
_Because it uses local docker containers to provide Elasticsearch and PostgreSQL, the `provision-vagrant.yml` playbook is not suitable for production._ 

This repository includes a Vagrant configuration file which will create the target virtual machine for you on your local workstation and run an Ansible playbook against that newly created virtual machine. 

1. [Install Ansible](http://docs.ansible.com/ansible/intro_installation.html) according to the instructions for the OS of the control machine. For the Elasticsearch container you will need a recent version of Ansible (> 2.x). You can check the version number installed with the command
```
ansible --version
```

2. [Install Vagrant](https://www.vagrantup.com/docs/installation/) as well as a compatible hypervisor (VirtualBox, VMware, etc.)
3. Clone this repository to the control machine
4. Copy the file in `group_vars/all/main.yml.sample` to `group_vars/all/main.yml` and add your own values inside the blank quotes.
5. Copy the file `Vagrantfile.virtualbox` to `Vagrantfile`
6. Open a terminal, `cd` into the repository root directory, and run:
```
ansible-galaxy install -r roles.yml
vagrant up
```

### Remove the Virtual Machine
Whenever you create resources for development and testing purposes, you need a way to remove or delete the resources. This is part of the typical deploy-test-destroy cycle. To remove the virtual machine you've created so you can retest from scratch:

1. `cd` to the project directory, if needed
2. Shut down the server: `vagrant halt`
3. Destroy the server resources: `vagrant destroy`

At this point, you can make whatever changes you may need to the source/configuration files. To test again, simply re-issue the `vagrant up` command.


<a name="ansible-aws"></a>
## Deploy Using Ansible to Amazon Web Services
Ansible will connect to your AWS account and create the necessary AWS objects, then connect to your target EC2 server and put all of the Library Simplified components in place. 

### Requirements
You will need:
- An AWS account 
- A [control machine](http://docs.ansible.com/ansible/intro_installation.html) running Linux or MacOS (i.e. your workstation)
- AWS Identity and Access Management (IAM) account with credentials that have been granted the following permissions:
  - AmazonEC2FullAccess
  - AmazonRDSFullAccess
  - AmazonVPCFullAccess
  - AmazonESFullAccess

### Deployment Instructions
1. [Install Ansible](http://docs.ansible.com/ansible/intro_installation.html) according to the instructions for the OS of the control machine
2. Install [`python-boto3`](https://pypi.python.org/pypi/boto) on the control machine
3. Add a file named `.boto` to your home directory on the control (administrator's local) machine with the following:
```
[Credentials]
aws_access_key_id = YOUR_AWS_ACCESS_KEY
aws_secret_access_key = YOUR_AWS_SECRET_ACCESS_KEY
```
4. Clone this repository to your control machine
5. Make a Bash script executable: `chmod +x ./aws-destroy`
6. Copy the file `group_vars/all/main.yml.sample` to `group_vars/all/main.yml` and add your own values inside the blank quotes. 
7. Copy the file `roles/libsimple-aws-objects/defaults/main.yml.sample` to `roles/libsimple-aws-objects/default/main.yml`, add the appropriate AWS account number, and adjust other values as needed. 
8. Open a terminal, `cd` into the repository root directory, and run:
```
ansible-galaxy install -r roles.yml
ansible-playbook -i localhost provision-aws.yml -vv
```

### Remove the AWS Services
As mentioned for the VirtualBox option above, you likely will need to remove AWS services you've created in this deployment, either to test again or because your need for them has ceased. Because the AWS Elasticsearch Service (ES) is not yet fully supported by an Ansible module, a console command is required to remove that service. Therefore, a Bash script is provided to start the process. ***Be aware that removing AWS resources will take several minutes to complete (perhaps as long as 20-30 minutes)***; some services are inter-connected, so a parent service must wait until a child service can be destroyed before the parent removal can proceed. To begin the removal process:

1. `cd` to the project directory, if needed
2. Destroy the AWS resources: `./aws-destroy`

Once the process has completed, you can make whatever changes you may need to the source/configuration files. To test again, simply re-issue the `ansible-playbook` command shown in step 7 above.


<a name="vagrant-linode-single"></a>
## Deploy Using Vagrant to Linode.com (Single)
As mentioned in the local Vagrant example above, this implementation is currently only for non-production purposes. It will create a single-server solution for the Circulation Manager with minimal security/scalability considerations. It _is_ sufficient, however, for learning how the system operates and for testing.  
                     
This repository includes a Vagrant configuration file which will create the target virtual server for you in an existing Linode.com account. Ansible playbooks are also executed to configure services in that newly created virtual server. 

### Requirements
You will need:
- A Linode.com account 
- A [control machine](http://docs.ansible.com/ansible/intro_installation.html) running Linux or MacOS (i.e. your workstation)
- A Linode API key created within your Linode.com account

### Deployment Instructions
1. [Install Ansible](http://docs.ansible.com/ansible/intro_installation.html) according to the instructions for the OS of the control machine. For the Elasticsearch container you will need a recent version of Ansible (> 2.x). You can check the version number installed with the command
```
ansible --version
```
2. [Install Vagrant](https://www.vagrantup.com/docs/installation/) as well as a compatible hypervisor (VirtualBox, VMware, etc.)
3. [Install Git](https://gist.github.com/derhuerst/1b15ff4652a867391f03#file-linux-md) source code manager so you can access this repository.
4. Open a console/terminal window if not open.
5. Run the following commands to install the necessary or (optional) utilities:
```
sudo pip install linode-python
vagrant plugin install vagrant-linode
; (Optional) If you want to experiment with Linode API access from the console command-line
; On RedHat distributions:
sudo yum install linode-cli
sudo yum install perl-LWP-Protocol-https
; Or on Debian distributions:
sudo apt-get install linode-cli
sudo apt-get install liblwp-protocol-https-perl
```
6. Create a directory for this project's file: `mkdir ~/simplye_circman` (or something similar) 
7. Make the project directory current: `cd ~/simplye_circman`
8. Clone this repository to the control machine: `git clone https://github.com/alsrlw/ansible-playbook-libsimple.git ./`
9. Copy the file in `group_vars/all/main.yml.sample` to `group_vars/all/main.yml` and add your own values inside the blank quotes.
10. Copy the file in `vars/linode_vars.yml.sample` to `vars/linode_vars.yml` and add your own values inside the blank quotes.
11. Copy the file `Vagrantfile.linode` to `Vagrantfile`
12. Register for an account at Linode.com if you don't currently have one. (First seven days are free, but a credit card is required.)
13. Log into your Linode account and create an API key to use with the Vagrant file below:
	* After logging in, click the ***my profile*** link
    * Enter your account password again to re-authorize access
    * Click the ***API Keys*** tab
    * In the ***Label*** field, enter a distinctive name, such as *SimplyE Circman Test*
    * There's no need to select an expiration period
    * Click the ***Create API Key*** button
    * Select and copy from the green highlight bar the text of the API key.
14. Paste the resulting Linode API key text to the appropriate variable value in `vars/linode_vars.yml`.
15. Create an SSH key pair for use in connecting the the virtual server as the admin user; create the user .ssh directory, if needed. When prompted for a password (twice), press <ENTER> key to create a passphraseless key--handy if you need programmatic access to the server as we're doing here.
```
mkdir ~/.ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/scm_linode_test1
```
16. If you wish to access the Linode API from the command line and installed the optional utilities above, you will need to create a configuration file at `~/.linodecli/config`. The CLI utility comes with a simple configuration script that creates this file (along with an API key for this specific access method). Start the configuration by issuing the command: `linode configure` and enter appropriate defaults.
17. Generate a crypted password for your admin user password:
    `python -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass(), crypt.mksalt(crypt.METHOD_SHA512)))'`
18. Copy the printed crypted value from the output of #17 into the appropriate variable value in `vars/linode_vars.yml`.
19. Install a standard Ansible role from the Galaxy repository: `ansible-galaxy install -r roles.yml`
20. Execute the Vagrant file to create and provision the server: `vagrant up`

### Accessing the Server Console
There are two methods of accessing the new server's console (beside the web-based LISH console in the Linode Manager screen):
1. Using Vagrant, where you will be logged in as the root user: `vagrant ssh`
2. Using an SSH client, where you will be logged in as the admin user configured from your variable settings
	* You will need the admin_username and the admin_ssh_keyname values you set in `vars/linode_vars.yml`
	* You will also needthe IP address of the new server (displayed in the Vagrant output or in the Linode Manager panel)
	* Using the command line SSH utility: `ssh <admin_username>@<ip-address> -i ~/.ssh/<admin_ssh_keyname>` 

### Remove the Virtual Server
To remove the virtual server you've created at Linode:

1. `cd` to the project directory, if needed
2. Shut down the server: `vagrant halt`
3. Destroy the server resources: `vagrant destroy`

At this point, you can make whatever changes you may need to the source/configuration files. To re-deploy another server, simply re-issue the `vagrant up` command.
