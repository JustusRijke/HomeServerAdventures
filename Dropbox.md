# Dropbox

To have a proper sync with the NAS, we need a container or VM with a headless Dropbox client.
The client will sync with a NFS share to a NAS dataset.

## Add TrueNAS dataset for dropbox files

1. Add a dataset (default permissions). Added it as `Dropbox`.
1. Share via NFS. Default, except for maproot user (advanced settings). Set it to "root".
1. Mount on the Proxmox host (so the container can access it)
    ```bash
    mkdir /mnt/nfs/Dropbox
    echo "192.168.178.151:/mnt/tank/Dropbox /mnt/nfs/Dropbox nfs defaults,_netdev,x-systemd.automount 0 0" >> /etc/fstab
    mount -a
    ```
### About the fstab arguments

* `defaults` — Use the standard NFS mount options:
  `rw,suid,dev,exec,auto,nouser,async`
* `_netdev` — Marks this as a network filesystem.
  Systemd waits for networking before mounting it and handles shutdown ordering properly.
* `x-systemd.automount` — Creates an automount unit.
  The share is mounted automatically on first access to `/mnt/nfs/Dropbox` instead of during boot, which speeds boot and avoids hangs if the server is unavailable.

## Setup up the container

First get a list of available containers on Proxmox:

```bash
pveam update
pveam available --section system
# mail            proxmox-mail-gateway-8.2-standard_8.2-1_amd64.tar.zst
# mail            proxmox-mail-gateway-9.0-standard_9.0-1_amd64.tar.zst
# system          almalinux-10-default_20250930_amd64.tar.xz
# system          almalinux-9-default_20240911_amd64.tar.xz
# etc.
```

We'll use Ubuntu 26.04: `pveam download local ubuntu-26.04-standard_26.04-1_amd64.tar.zst`

1. Create a container with 4GB disc and 1GB RAM/swap. Set a fixed IP, and start it.
1. Via the Proxmox shell, bind the mount point to the container's home folder:
    ```bash
    pct set 102 -mp0 /mnt/nfs/Dropbox,mp=/root/Dropbox
    # 102 = container ID
    ```
1. To allow the container root user to access the folder, set ownership to uid 100000 (100000 + uid of container root, which is 0):
    ```bash
    # Proxmox shell
    chown -R 100000:100000 /mnt/nfs/Dropbox
    ```
1. Start the container, check if the mount point is available.
1. Install Dropbox:
    ```bash
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    ./.dropbox-dist/dropboxd
    # Open the link and login
    ```
1. **Optional:** Allow access via SSH as root user:
    ```bash
    nano /etc/ssh/sshd_config 
    # set "PermitRootLogin yes"
    reboot now
    ```

