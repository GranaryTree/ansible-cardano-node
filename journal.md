# Journal on using Ansible for Cardano

## 05/31/2022

Based on [moaipool/ansible-cardano-node](https://github.com/moaipool/ansible-cardano-node) and [Mark Kerry's Ansible instructions](https://markkerry.github.io/posts/2022/04/ansible-part-1/)

### Create & Configure Ansible Admin VM

#### Create Admin VM

- Created _AnsibleAdmin.lan_ VM w/2 networks following [Ubuntu Server VBox lab](https://markkerry.github.io/posts/2022/02/ubuntu-server-lab/) based on Ubuntu Server 22.04 LTS, minimal
- Installed OpenSSH Server
- Added my public key using ssh-copy-id
- Shutdown and took snapshot of VM

#### Configure AnsibleAdmin

- Following Ansible-Cardano-Node
    - Install pip

        `sudo apt install python3-pip`

    - Install netaddr (req'd for Jinja2)

        `sudo pip install netaddr`

- Configure Git
    - Copy J's ssh from AmtUbu (or AmtU2)

        `scp ~/.ssh/id_rsa* jb@ansibleadmin.lan:~/.ssh/`

    - Set git config

        `git config --global user.name jburnett`
        `git config --global user.email jburnett@altamodatech.com`

- Get GTIO repo
    - Create hierarchy

        `mkdir -p ~/src/github.com/granarytree`
    
    - Clone GTIO branch of repo

        `git clone -b gtio git@github.com:granarytree/ansible-cardano-node`

### Ansible

Directory structure fron https://github.com/GranaryTree/ansible-cardano-node#organization

#### Inventory

Following https://github.com/GranaryTree/ansible-cardano-node#inventory-setup

- Added inventories for relay and producers
    - GTIOAda[P|R]1

#### User for Deployments

Following [User Setup](https://github.com/GranaryTree/ansible-cardano-node#user-setup)

- Create & config user _deploy_

    `useradd deploy
    mkdir /home/deploy
    mkdir /home/deploy/.ssh
    chmod 700 /home/deploy/.ssh
    chown -R deploy:deploy /home/deploy`

- Set _deploy's_ password
    - domain naut 1

- Copy J's ssh key to _deploy_ user on _AnsibleAdmin.lan_.
    - TODO: Review: Is this the right thing to do?  Seems to be what the instructions say.

- Using _visudo_, allow _deploy_ and sudo with no password.

## 06/01/2022

### Ansible Guest Base VM

VM
- name: AnsibleGuest
- RAM: 2 GB
- CPU: 2
- Stg: 160 GB, dynamic

Install Ubuntu Server 22.04 from live iso
- minimized
- user: deploy, pswd: domain naut 1
- OpenSSH Server

After rebooting, log in as deploy & upgrade.
Install
- nano, ufw, git
Config
- ssh-copy-id id_rsa pub to deploy's .ssh
- visudo
    - add deploy user (cp root + NOPASSWD:ALL)
    - chg %sudo to NOPASSWD:ALL

Reboot again & autoremove (0 removed).
Shutdown.
Export as OVA

Import as GTIOAdaR1
Boot
Set IP to .10 in /etc/netplan/00-installer-config.yaml

```yaml
network:
    ethernets:
    enp0s3:
        addresses:
        - 10.0.2.10/24
        routes:
        - to: default
        via: 10.0.2.2
        nameservers:
        addresses: [ 8.8.8.8, 8.8.4.4 ]
        dhcp4: false

    enp0s8:
        dhcp4: true
```

Import as GTIOAdaP1
Boot
Set IP to .12

### Attempt Ansible Caradaon Playbook

- Check playbook

    `ansible-playbook --check provision.yml`


## TODO
- Create relay and producer VMs?
    - give deply user sudo access to each
    - Long-term: auto-provision VMs w/appr users, keys
