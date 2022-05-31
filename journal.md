# Journal on using Ansible for Cardano

Based on [moaipool/ansible-cardano-node](https://github.com/moaipool/ansible-cardano-node) and [Mark Kerry's Ansible instructions](https://markkerry.github.io/posts/2022/04/ansible-part-1/)


## Create & Configure Ansible Admin VM

### Create Admin VM

- Created _AnsibleAdmin.lan_ VM w/2 networks following [Ubuntu Server VBox lab](https://markkerry.github.io/posts/2022/02/ubuntu-server-lab/) based on Ubuntu Server 22.04 LTS, minimal
- Installed OpenSSH Server
- Added my public key using ssh-copy-id
- Shutdown and took snapshot of VM

### Configure AnsibleAdmin

- Following Ansible-Cardano-Node
    - Install pip

    `sudo apt install python3-pip`

    - Install netaddr (req'd for Jinja2)

    `sudo pip install netaddr`

## Ansible

Directory structure fron https://github.com/GranaryTree/ansible-cardano-node#organization

### Inventory

Following https://github.com/GranaryTree/ansible-cardano-node#inventory-setup

- Added inventories for relay and producers
    - GTIOAda[P|R]1

### User for Deployments

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


## TODO
- Create relay and producer VMs?
    - give deply user sudo access to each
    - Long-term: auto-provision VMs w/appr users, keys
