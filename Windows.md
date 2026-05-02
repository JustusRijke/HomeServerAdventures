# Windows 11

How to create a Windows 11 ISO, debloated and with recent Windows updates slipstreamed. This ISO will be used whenever I need a basic Win11 VM.

## Preparing installation media

### Download ISO

Microsoft already adds updates to their ISO's (download [here](https://www.microsoft.com/en-us/software-download/windows11)) - so no need to slipstream.

### Debloat

Using [Windows-ISO-Debloater](https://github.com/itsNileshHere/Windows-ISO-Debloater). Requires a Windows 10/11 PC with enough free space to unpack the ISO.

Just follow the instructions. If you want to run `.\isoDebloaterScript.ps1` directly, you might need to relax the execution policy:

```ps
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

For my setup I selected Windows 11 Pro N (no media apps bundled), and left all other options to their default value except for:

- Edge (not removed)
- User folders (removed)
- ISO compression (enabled)

### Add (slipstream) device drivers

Not required at this stage. Might come in handy once I want to create Win11 VM's. For now, it'll only be used for testing the host / updating firmware using Windows.


## Installation (bare metal)

### Create bootable USB stick

Use [Rufus](https://rufus.ie/en/), keep all options to their defaults.
When prompted with Windows User Experience questions, disable all checkboxes (these things are already handled by the iso debloater script).

Boot PC with USB stick.

### Driver & Tools

Use [HWiNFO](https://www.hwinfo.com/download/) to get detailed specs.

Drivers used for Windows 11, in order of installation:

- Intel Chipset driver
- Intel Consumer ME driver
- Realtek RTL8125 LAN driver
- Intel Graphics Accelerator Driver

Download [here](https://www.asus.com/us/motherboards-components/motherboards/prime/prime-z890-p-wifi/helpdesk_download?model2Name=PRIME-Z890-P-WIFI).

Possible bloat:

- Intel Platform Performance Package Installer
- Intel Serial IO Software
- Intel Rapid Storage Technology Drive
- ~~Intel Innovation Platform Framework~~ supposedly already part of Intel PPP installer
- Realtek UcmCx Client Device Driver
- ~~Realtek Audio Driver~~ won't be using audio
- ~~MediaTek MT7925/7927 WiFi Driver~~ won't be using WiFi
- ~~MediaTek MT7925/7927 Bluetooth Driver~~ won't be using bluetooth

TODO: Update list after install. Disable unused devices in Device Manager.
Above drivers might be outdated when using the links on the Asus website.

TODO: Use [Intel® Driver & Support Assistant](https://www.intel.com/content/www/us/en/support/detect.html). Check which drivers were updated and use those in future installs. Low prio, VM's might not even use 'm.

## Installation (VM)

1. Download [virtio-win.iso](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/)
1. Create a VM. Options:
    - Set correct guest OS
    - Add drive for the debloated Windows ISO
    - Add additional drive vor VirtIO drivers and select the virtio iso
    - Graphic card: SPICE
    - Check Qemu Agent
    - Uncheck Add TPM (optional)
    - Disks: check Discard
    - Memory: uncheck Ballooning (optional, increases performance)
    - Memory: uncheck KSM (optional, increases performance)
1. Start the VM and finish the installation.
    - If TPM was disabled, the installation will be blocked, [bypass the TPM check](https://medium.com/@thatCleverNerd/how-to-bypass-tpm-requirements-for-windows-11-using-regedit-steam-deck-2c55b697a87b) to fix this.
    - No harddrives will be found, because the SCSI driver is not installed. When prompted, install the drivers on `D:\vioscsi\w11\amd64`
1. After install, run  `D:\virtio-win-guest-tools.exe` and install all drivers.
1. On your client (where you want to view the VM), install [virt-viewer](https://virt-manager.org/download).

You can now connect to the VM using [SPICE](https://pve.proxmox.com/wiki/SPICE).
This is a good time to shutdown the VM and make a snapshot.

## Useful links

- https://www.microsoft.com/en-us/software-download/windows11
- https://github.com/itsNileshHere/Windows-ISO-Debloater
- https://uupdump.net/
