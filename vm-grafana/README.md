# Grafana

How To install grafana on VM Proxmox (virtual machine)

# TODO

- complete configuration with nix

# Hardware

iKOOLCORE with i3-N300 (Alder Lake)

# Installation

[Installing NixOS](https://nixos.org/manual/nixos/stable/#sec-installation)

## Commands

```sh
groupadd database                       # create a new group
usermod -a -G database grafana          # add grafana user to group
mkdir /data                             # create new folder
chgrp database /data                    # link group to dir
chmod g+rwx /data                       # set permissions
usermod -a -G database admin            # add admin user to group
```

```sh
nano /etc/nixos/configuration.nix
```

```sh
nixos-rebuild switch
```

## Database

Copy database from Macbook to Virtual Machine.

```sh
scp ~/Projects/big-spender/ledger.db admin@192.168.10.33:/data
```
