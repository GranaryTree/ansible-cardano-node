# Steps for Using This Repo

## Stage 0 - Create NixOS VagrantBox

- Using AmtNix VM on AmtU2
    - Login as root
    - Create NixOS VagrantBox
        - Change to script dir

        `pushd /media/sf_ansible_cardano_node/Stage0/NixOS/`

        - Run script to create Vagrantbox

        `./generate-vagrantbox.sh`

    - Prep to copy file to AmtNas downloads
        - Create mount point 

        `mkdir -p /media/amtnas/downloads`

        - Mount 

        `mount -t nfs -o nolock amtnas.lan:/volume1/downloads /media/amtnas/downloads`

    - Copy new VagrantBox to AmtNas downloads

        `cp /nix/store/<vagrantbox file info> /media/amtnas/downloads/vagrant-boxes/`

    - Shutdown AmtNix

- Using AmtU2
    - Prepare to use new Vagrantbox
        - [Re]Create symlink to new

        `ln -s /mnt/amtnas/downloads/vagrant-boxes/<new file>-virtualbox-vagrant.box /mnt/amtnas/downloads/vagrant-boxes/nixos-virtualbox-vagrant.box`

    - Create new VM
        - Using vagrant in ansible-cardano-node dir

        `vagrant up --provision`

    
