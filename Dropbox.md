# Dropbox

To have a proper sync with the NAS, we need a container or VM with a headless Dropbox client.
The client will sync with a NFS share to a NAS dataset.

## Add TrueNAS dataset to Proxmox to store containers

1. Add a dataset (default permissions)
1. Share via NFS, with user "root" and group "wheel"
1. Add to Proxmox (added it as `TrueNAS_Backup`)

## Setup up the container

First get a list of available containers on Proxmox:

```bash
pveam update
pveam available
# mail            proxmox-mail-gateway-8.2-standard_8.2-1_amd64.tar.zst
# mail            proxmox-mail-gateway-9.0-standard_9.0-1_amd64.tar.zst
# system          almalinux-10-default_20250930_amd64.tar.xz
# system          almalinux-9-default_20240911_amd64.tar.xz
# etc.
```

We'll use Ubuntu 26.04: `pveam download TrueNAS_Backup ubuntu-26.04-standard_26.04-1_amd64.tar.zst`

Start the container, and install Dropbox:

```bash
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd
````




