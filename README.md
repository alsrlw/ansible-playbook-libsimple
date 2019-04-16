# Library Simplified Ansible Provisioner (Circulation Server)
This set of automation files using [Ansible](http://docs.ansible.com/ansible/) and [Vagrant](http://https://www.vagrantup.com/) will provision a [Library Simplified Circulation Manager](https://github.com/NYPL-Simplified/circulation/) in a variety of development environments. 

*Deployment Options:*
* [Deploy Using Vagrant to Local VM for Dev Testing](#vagrant-local)
* [Deploy Using Vagrant to Linode.com for Dev Testing](#vagrant-linode-single)
* [Deploy Using Ansible to Amazon Web Services](#ansible-aws)

<a name="prereqs"></a>
## Installing Prerequisites ##
### Git ###
All of the publicly available software repositories for the Library Simplified project are managed using Git for source control. We have used Git for the demonstration server deployment files as well. While it is not an absolute requirement (you could download a zip archive), we recommend that you install Git on the machine (the *control machine*) from which you deploy your Circulation Manager servers. Having Git available makes it easy to keep the repository up-to-date.

For more information on installing Git, see the [*Git Pro book*](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) online.

### Ansible ###
Each of the three deployment options shown below make use of Ansible playbooks to install various utilities and the SimplyE Circulation Manager software on virtual servers, either local or online. So you need to install Ansible on your "control machine."

Because using Ansible for deployment is not supported on Windows computers natively, we suggest using a Linux desktop or a Mac to act as the Ansible controller.

See the Ansible [Installation Guide](http://docs.ansible.com/ansible/intro_installation.html) for details. Deploying the Elasticsearch container in local or Linode.com virtual machines from this repository requires a recent version of Ansible (> 2.x). But creating a new install now from the *Guide* should provide you that. To check definitively, you can check the version number installed with the command:
```
ansible --version
```

### Vagrant ###

If you choose to deploy your demonstration Circulation Manager to a local machine or to Linode.com, Vagrant is a great tool to assist in creating those virtual machines. You will need to install Vagrant as well so that you can use the Vagrantfile automation scripts we've included in the repository.

See Hashicorp's [Vagrant installation](https://www.vagrantup.com/docs/installation/) page for details.


### VirtualBox ###
Last, if you wish to deploy the Circulation Manager to a local virtual machine on your Mac or Linux desktop computer using this repository, you will need to install VirtualBox as well. Other virtual machine tools (VMWare, Hyper-V) will work just as well; however, the virtualization tool we've used in this repository is VirtualBox. If you choose to use one of the other common tools, you just need to revise the Vagrantfile configuration to be appropriate for that tool.

See Oracle's [VirtualBox](https://www.virtualbox.org/wiki/Downloads) downloads page for more information.


<a name="vagrant-local"></a>
## Deploy Using Vagrant to Local VM for Dev Testing
*Because it uses local docker containers to provide Elasticsearch and PostgreSQL, the `provision-vagrant.yml` playbook is not suitable for production.*

This repository includes a Vagrant configuration file which will create the target virtual machine for you on your local workstation. The Vagrant file runs two Ansible playbooks against that newly created virtual machine, which will deploy the containers necessary to have a running Circulation Manager instance. To get started, follow these steps.

1. Open a command-line terminal and make a directory to store this repository; for example:
```
mkdir /home/user/vagrant_projects/libsimple
```
2. Change directories to the repository directory:
```
cd /home/user/vagrant_projects/libsimple`
```
3. Clone this repository to its local directory:
```
git clone https://github.com/alsrlw/ansible-playbook-libsimple.git ./
```
4. Copy the sample variable files to their working versions:
```
cp group_vars/all/main.yml.sample group_vars/all/main.yml
cp vars/containers.yml.sample vars/containers.yml
cp vars/virtualbox_multi_vars.yml.sample vars/virtualbox_multi_vars.yml
```
Open each file and revise or fill in values as needed for each variable.

5. Copy the proper Vagrantfile to its operational name:
```
cp Vagrantfile.virtualbox-multi Vagrantfile
```
9. Once you have the variable values all configured and have established the `Vagrantfile`, you are ready create and start the virtual server. Because there are two potential servers represented in the Vagrantfile, you need to issue the Vagrant command and specify the Circulation Manager machine to spin up the demonstration server:
```
vagrant up circmgr
```

### Remove the Virtual Machine
Whenever you create resources for development and testing purposes, you need a way to remove or delete the resources. This is part of the typical deploy-test-destroy cycle. Vagrant makes this easy by providing a destroy command. Remember that the Vagrantfile specifies more than one server, so you have to name it in the destroy command.

1. Open a command-line terminal and change directories to the project directiory; for example:
```
cd /home/user/vagrant_projects/libsimple
```
2. Shut down the virtual server:
```
vagrant halt circmgr
```
3. Destroy the server resources:
```
vagrant destroy circmgr
```

At this point, you can make whatever changes you may need to the source/configuration files. To test again, simply re-issue the `vagrant up circmgr` command from the project directory.


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
1. Open a command-lin terminal and run the following commands to install the necessary or (optional) utilities:
```
sudo pip install linode-python
vagrant plugin install vagrant-linode
; (Optional) If you want to experiment with Linode API access from
; the console command-line
; On RedHat distributions:
sudo yum install linode-cli
sudo yum install perl-LWP-Protocol-https
; Or on Debian distributions:
sudo apt-get install linode-cli
sudo apt-get install liblwp-protocol-https-perl
```
2. Also make a directory to house this repository; for example:
```
mkdir /home/user/vagrant_projects/libsimple
```
3. Change directories to the respository directory:
```
cd /home/user/vagrant_projects/libsimple`
```
4. Clone this repository to its local directory:
```
git clone https://github.com/alsrlw/ansible-playbook-libsimple.git ./
```
5. Copy the sample variable files to their working versions:
```
cp group_vars/all/main.yml.sample group_vars/all/main.yml
cp vars/containers.yml.sample vars/containers.yml
cp vars/linode_vars.yml.sample vars/linode_vars.yml
```
Open each variable file and revise or fill in values as needed for each variable.

6. Copy the proper Vagrantfile to its operational name:
```
cp Vagrantfile.linode Vagrantfile
```
7. Register an account at Linode.com if you don't currently have one. (First seven days are free, but a credit card is required.)
8. Log into your Linode account and create an API key to use with the Vagrant file below:
	* After logging in, click the ***my profile*** link
    * Enter your account password again to re-authorize access
    * Click the ***API Keys*** tab
    * In the ***Label*** field, enter a distinctive name, such as *SimplyE Circman Test*
    * There's no need to select an expiration period
    * Click the ***Create API Key*** button
    * Select and copy from the green highlight bar the text of the API key.
9. Paste the resulting Linode API key text to the appropriate variable value in `vars/linode_vars.yml`.
10. Create an SSH key pair for use in connecting the the virtual server as the admin user; create the user .ssh directory, if needed. When prompted for a password (twice), press <ENTER> key to create a passphraseless key--handy if you need programmatic access to the server as we're doing here.
```
mkdir ~/.ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/scm_linode_test1
```
11. If you wish to access the Linode API from the command line and installed the optional utilities above, you will need to create a configuration file at `~/.linodecli/config`. The CLI utility comes with a simple configuration script that creates this file (along with an API key for this specific access method). Start the configuration by issuing the command: `linode configure` and enter appropriate defaults.
12. Generate a crypted password for your admin user password:
    `python -c 'import crypt,getpass; print(crypt.crypt(getpass.getpass(), crypt.mksalt(crypt.METHOD_SHA512)))'`
13. Copy the printed crypted value from the output of #17 into the appropriate variable value in `vars/linode_vars.yml`.
14. Once you have the variable values all configured and have established the `Vagrantfile`, you are ready create and start the virtual server. Because there are two potential servers represented in the Vagrantfile, you need to issue the Vagrant command and specify the Circulation Manager machine to create and provision the server:
```
vagrant up circmgr
```

### Accessing the Server Console
There are two methods of accessing the new server's console (beside the web-based LISH console in the Linode Manager screen):
1. Using Vagrant, where you will be logged in as the root user: `vagrant ssh circmgr`
2. Using an SSH client, where you will be logged in as the admin user configured from your variable settings
	* You will need the admin_username and the admin_ssh_keyname values you set in `vars/linode_vars.yml`
	* You will also need the IP address of the new server (displayed in the Vagrant output or in the Linode Manager panel)
	* Connecting via the command line SSH utility: `ssh <admin_username>@<ip-address> -i ~/.ssh/<admin_ssh_keyname>`

### Remove the Virtual Server
To remove the virtual server you've created at Linode:

1. `cd` to the project directory, if needed
2. Shut down the server: `vagrant halt`
3. Destroy the server resources: `vagrant destroy circmgr`

At this point, you can make whatever changes you may need to the source/configuration files. To re-deploy another server, simply re-issue the `vagrant up circmgr` command.


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
5. Open a terminal and `cd` into the repository root directory.
6. Make Bash scripts executable:
```
chmod +x ./aws-destroy
chmod +x ./get-latest-ami-image
```
7. Copy the file `group_vars/all/main.yml.sample` to `group_vars/all/main.yml` (and edit to supply your own values where needed).
```
cp group_vars/all/main.yml.sample group_vars/all/main.yml
```
8. Copy the file `roles/libsimple-aws-objects/defaults/main.yml.sample` to `roles/libsimple-aws-objects/default/main.yml` (and edit to supply your own values where needed).
```
cp roles/libsimple-aws-objects/defaults/main.yml.sample roles/libsimple-aws-objects/defaults/main.yml
```
9. ***NOTE:*** The default `ec2_image` value in the AWS defaults variables file is the latest AMI image *in the default us-east-1 region* for CentOS 7 as of the time of commiting the file. To determine the proper AMI image ID for the region and Linux distribution, use the `get-latest-ami-image` script located in the project root directory. As an example:
```
./get-latest-ami-image centos latest us-east-2
```
	Be sure to update the region and availability zone variables as needed as well.

10. Include a required Ansible role by issuing the command:
```
ansible-galaxy install -r roles.yml
```
11. Temporary tasks:
	* If you wish to use the temporary playbook included in the repository:
		- Copy the temporary variables file:
```
cp vars/temp_vars.yml.sample vars/temp_vars.yml
```
		- Open the `vars/temp_vars.yml` file and change the default values to 'no' for both the `es_local` and `pg_local` variables. In AWS, these services are configured as external services, not as containers on the local Circulation Manager host.
		- Open the `provision-temp.yml` playbook and see if there are any tasks you'd like to add or change, if desired.
    * If you wish not to run the temporary playbook, simply remove that file:
```
rm provision-temp.yml
```
12. Execute the playbook:
```
ansible-playbook -i localhost provision-aws.yml -vv
```

### Remove the AWS Services
As mentioned for the VirtualBox option above, you likely will need to remove AWS services you've created in this deployment, either to test again or because your need for them has ceased. Because the AWS Elasticsearch Service (ES) is not yet fully supported by an Ansible module, a console command is required to remove that service. Therefore, a Bash script is provided to start the process. ***Be aware that removing AWS resources will take several minutes to complete (perhaps as long as 20-30 minutes)***; some services are inter-connected, so a parent service must wait until a child service can be destroyed before the parent removal can proceed. To begin the removal process:

1. `cd` to the project directory, if needed
2. Destroy the AWS resources: `./aws-destroy`

Once the process has completed, you can make whatever changes you may need to the source/configuration files. To test again, simply re-issue the `ansible-playbook` command shown in step 7 above.
