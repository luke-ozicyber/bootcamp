## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![](https://github.com/luke-ozicyber/bootcamp/blob/main/diagrams/Azure%20Cloud%20Project%20-%20Week%2013%20Diagram.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

#### Playbook 1: pentest.yml
```
---
- name: Config Web VM with Docker
  hosts: webservers
  become: true
  tasks:
  - name: docker.io
    apt:
      force_apt_get: yes
      update_cache: yes
      name: docker.io
      state: present

  - name: Install pip3
    apt:
      force_apt_get: yes
      name: python3-pip
      state: present

  - name: Install Docker python module
    pip:
      name: docker
      state: present

  - name: download and launch a docker web container
    docker_container:
      name: dvwa
      image: cyberxsecurity/dvwa
      state: started
      published_ports: 80:80

  - name: Enable docker service
    systemd:
      name: docker
      enabled: yes
```
 
       
#### Playbook 2: install-elk.yml
```
---
- name: Configure Elk VM with Docker
  hosts: elkservers
  remote_user: elk
  become: true
  tasks:
    # Use apt module
    - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present
    
    # Use apt module
    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present
      
    # Use pip module (It will default to pip3)
    - name: Install Docker module
      pip:
        name: docker
        state: present
    
    # Use command module
    - name: Increase virtual memory
      command: sysctl -w vm.max_map_count=262144
      
    # Use sysctl module
    - name: Use more memory
      sysctl:
        name: vm.max_map_count
        value: 262144
        state: present
        reload: yes
      
    # Use docker_container module
    - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        # Please list the ports that ELK runs on
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044
```

#### Playbook 3: filebeat-playbook.yml
```
---
- name: installing and launching filebeat
  hosts: webservers
  become: yes
  tasks:
  
  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb 
 
  - name: install filebeat deb
    command: dpkg -i filebeat-7.4.0-amd64.deb 
  
  - name: drop in filebeat.yml 
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml
  
  - name: enable and configure system module
    command: filebeat modules enable system
  
  - name: setup filebeat
    command: filebeat setup
  
  - name: Start filebeat service
    command: service filebeat start
```
    

### This document contains the following details:

* Description of the Topology
* Access Policies
* ELK Configuration
* Beats in Use
* Machines Being Monitored
* How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- Load balancers protect application availability, allowing client requests to be shared across a number of servers 
- The advantage of a Jump Box is that it minimises the attack surface by ensuring remote connections to the cloud network come through a single VM.  Additionally, remote connections to the Jump Box can be monitored easily to identify unusual remote connections.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the configuration and system files.
- Filebeat is used to monitor logs files
- Metricbeat is used to collect operating system and service statistics from monitored VMs

The configuration details of each machine may be found below.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.7   | Linux            |
| Web-1    | DVWA     | 10.0.0.4   | Linux            |
| Web-2    | DVWA     | 10.0.0.5   | Linux            |
| Web-3    | DVWA     | 10.0.0.6   | Linux            |
| Elk-1    | ELK      | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box machine can accept SSH connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- 120.154.110.138

Machines within the network can only be accessed by the Jump Box.
- The Jump Box can access the ELK VM Elk-1 using SSH.  The Jump Box's IP address is 10.0.0.7

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses | Allowed Ports |
|----------|---------------------|----------------------|---------------|
| Jump Box | Yes (SSH)           | 120.154.110.138      | 22            |
| Web-1    | Yes (HTTP)          | 120.154.110.138      | 80            |
| Web-2    | Yes (HTTP)          | 120.154.110.138      | 80            |
| Web-3    | Yes (HTTP)          | 120.154.110.138      | 80            |
| Elk-1    | Yes (HTTP)          | 120.154.110.138      | 5601          |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because:

- Build and deployment is performed automatically, consistently and quickly
- Consistent, rapid configuration and depoloyment of virtual machines ensure all prescribed security meaures can be scripted to minimise attack surfaces while enabling horizontal and elastic scaling by deployment to more or fewer virtual machines in a cluster as required to meet capacity demand.
- Facilitates OS and software updates

### Playbooks

The three playbooks above implement the following tasks:

#### Playbook 1: pentest.yml
pentest.yml is used to set up DMWA servers running in a Docker container on each of the web servies show in the diagram above.  It implements the following tasks:

- Installs Docker
- Installs Python
- Installs Docker's Python Module
- Downloads and launches the DVWA Docker container
- Enables the Docker service

#### Playbook 2: install-elk.yml
install-elk.yml is used to set up and launch the ELK repository server in a Docker Container on the ELK server.  It implements the following tasks:

- Installs Docker
- Installs Python
- Installs Docker's Python Module
- Increase virtual memory to support the ELK stack
- Increase memory to support the ELK stack
- Download and launch the Docker ELK container

#### Playbook 3: filebeat-playbook.yml
filebeat-playbook.yml is used to deploy Filebeat on each of the web servers so they can be monitored centrally using ELK services running on Elk-1.  It implements the following tasks:

- Downloads and installs Filebeat
- Enables and congigures the system module
- Configures and launches Filebeat

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![](https://github.com/luke-ozicyber/bootcamp/blob/main/diagrams/elk_docker_container.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1: 10.0.0.4
- Web-2: 10.0.0.5
- Web-3: 10.0.0.6

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:

- Filebeat collects and ships (sends to ELK for collation, persistence and reporting) logs from VMs running the Filebeat agent
- Metricbeat collects and ships system metrics from the operating system and services of VMs running the Metricbeat

### Using the Playbooks
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the playbook files to Ansible Docker Container.
- Update the Ansible hosts file `/etc/ansible/hosts` to include the following: 

```
[webservers]
10.0.0.4 ansible_python_interpreter=/usr/bin/python3
10.0.0.5 ansible_python_interpreter=/usr/bin/python3
10.0.0.6 ansible_python_interpreter=/usr/bin/python3

[elkservers]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3
```

- Update the Ansible configuration file `/etc/ansible/ansible.cfg` and set the remote_user parameter to the admin user of the web servers.

#### Running the Playbooks
1. Start an ssh session with the Jump Box `~$ ssh sysadmin@<Jump Box Public IP>`
2. Start the Ansible Docker container `~$ sudo docker start <Ansible Container>`
3. Attach a shell to the Ansible Docker container with the command `~$ sudo docker attach <Ansible Container>
4. Run the playbooks with the following commands:
	* `ansible-playbook /etc/ansible/pentest.yml`
	* `ansible-playbook /etc/ansible/install-elk.yml`
	* `ansible-playbook /etc/ansible/roles/filebeat-playbook.yml`

- Note that the Playbook 2 - `install_elk.yml` configures only the server(s) listed as `[elkservers]` in `/etc/ansible/hosts`
- Similarly Playbook 3 - `filebeat-playbook.yml` configures the servers listed as `[webservers]` in `/etc/ansible/hosts`

- After running the playbooks and observing no errors in the output, navigate to Kibana to check that the installation worked as expected by viewing Filebeat and Metricbeat data and reports in the Kibana Dashboard
- Kibana can be accessed at [http://\<elk-server-ip\>:5601/app/kibana]()
