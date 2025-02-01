# Unbound

Unbound is a validating, recursive, caching DNS resolver. It is designed to be fast and lean and incorporates modern features based on open standards. Unbound is created by NLnet Labs.

[User documentation & Guides](https://unbound.docs.nlnetlabs.nl/en/latest/)

# DNS servers

```yaml
1.1.1.1           # Cloudflare
208.67.222.222    # OpenDNS
9.9.9.9           # Quad9
```

# Installation

## Proxmox CLI

Use the following commands (steps) to create the container.

```sh
TEMPLATE_STORAGE='local'
TEMPLATE_FILE='nixos-24.05-system-x86_64-linux.tar.xz'
CONTAINER_HOSTNAME='lxc-unbound'
CONTAINER_STORAGE='local-lvm'
CONTAINER_RAM_IN_MB='1024'
CONTAINER_CPU_CORES='1'
CONTAINER_DISK_SIZE_IN_GB='12'
```

```sh
pct create "$(pvesh get /cluster/nextid)" \
  --arch amd64 \
  "${TEMPLATE_STORAGE}:vztmpl/${TEMPLATE_FILE}" \
  --ostype unmanaged \
  --description nixos \
  --hostname "${CONTAINER_HOSTNAME}" \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp,firewall=1 \
  --storage "${CONTAINER_STORAGE}" \
  --memory "${CONTAINER_RAM_IN_MB}" \
  --cores "${CONTAINER_CPU_CORES}" \
  --rootfs ${CONTAINER_STORAGE}:${CONTAINER_DISK_SIZE_IN_GB} \
  --unprivileged 1 \
  --features nesting=1 \
  --cmode console \
  --onboot 1 \
  --start 0
  ```

```sh
rm /etc/nixos/configuration.nix && \
curl https://raw.githubusercontent.com/momferdemol/nixcfg/refs/heads/main/lxc-unbound/configuration.nix \
> /etc/nixos/configuration.nix
```

```sh
nix-channel --update
```

```sh
nixos-rebuild switch --upgrade && \
poweroff --reboot
```
