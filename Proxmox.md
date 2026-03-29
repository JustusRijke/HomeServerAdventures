# Proxmox

The host will be [Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview).

I am used to ESXi, but the free tier is no longer available. Proxmox is open source and has a big community.

## Installation

Download: https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started

Based on [Proxmox Beginner’s Guide: Everything You Need to Get Started](https://youtu.be/lFzWDJcRsqo) and Proxmox VE 9.1.1 (9.1.6 after the post-install script).

On the first boot, follow the wizard. When asked to select the network interface, select the NIC, not the WiFi adapter.

After reboot, login and run the [post-install script](https://community-scripts.org/scripts/post-pve-install) and use the default answers. Don't close the shell until the script finishes (updates might take a few minutes).

## Issues

### No network connection after installation

After reboot, Proxmox failed to connect.
Turned out the NIC name in `/etc/network/interfaces` was wrong: `nic1` instead of `enp0s31f6`.

Use `ip link` to find the correct network interface name (`enp...`), and replace all instances of `nic1` with the correct `enp...` identifier.

## TODO

- Check when to use [LXC (Linux Containers)](https://pve.proxmox.com/wiki/Linux_Container) or [KVM Virtual Machines](https://pve.proxmox.com/wiki/Qemu/KVM_Virtual_Machines)

## Creating VM's

### Uploading ISO images

Datacenter > pve > local (pve) > ISO images (assuming default storage, no NAS etc.)

### Post-install

#### Debian

- Install [Qemu guest agent](https://pve.proxmox.com/wiki/Qemu-guest-agent).
- 

## Useful links

- [Proxmox VE Helper-Scripts](https://community-scripts.org/)
