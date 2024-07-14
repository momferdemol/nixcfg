# Jellyfin

How To install Jellyfin on LXC Proxmox (container)

# Hardware

iKOOLCORE with i3-N300 (Alder Lake)

# Installation

[Installing Jellyfin on Proxmox](https://www.wundertech.net/installing-jellyfin-on-proxmox/)
Install on Proxmox with [Hardware Transcode](https://www.youtube.com/watch?v=tWumbDlbzLY)

## Commands

```sh
ls -l /dev/dri
```

```sh
getent group
```

```sh
id [USERNAME]
```

```sh
usermod -a -G [GROUP] [USER]
```

## Proxmox steps


```sh
apt update && sudo install -y intel-gpu-tools
```

```sh
apt install vainfo -y
```

```sh
apt install software-properties-common -y
add-apt-repository -y non-free
apt install intel-media-va-driver-non-free -y
```

```sh
nano /etc/pve/lxc/[ID].config
```

```
lxc.cgroup2.devices.allow: c 226:0 rwm
lxc.cgroup2.devices.allow: c 226:128 rwm
lxc.mount.entry: /dev/dri/card0 dev/dri/card0 none bind,optional,create=file
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
```

## LXC Container steps

```sh
apt update && apt upgrade -y
```

```sh
apt install vainfo -y
```

```sh
apt install curl -y
curl https://repo.jellyfin.org/install-debuntu.sh | bash
```

```sh
usermod -a -G video jellyfin
usermod -a -G ssl-cert jellyfin
```

```sh
apt install cifs-utils -y
nano /etc/.smb-secrets          # create credentials file
mkdir /mnt/Media
```

```sh
nano /etc/fstab                 # create mount rule
```

```
//192.168.10.26/Media/ /mnt/Media   cifs    credentials=/etc/.smb-secrets,rw,noperm,uid=100000  0   0
```
