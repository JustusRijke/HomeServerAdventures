# GPU

## Enabling SR-IOV passthrough

1. Enable IOMMU (see Proxmox notes)
1. Check if passthrough is possible (see below)
1. Set number of virtual GPUs
1. Passthrough vGPU

Links:
- https://github.com/ccpk1/Homelab-Public-Documentation/blob/main/Proxmox%20Virtual%20GPU%20Setup%20with%20Intel%20Arc%20Pro%20B50.md
- https://forum.level1techs.com/t/proxmox-9-0-intel-b50-sr-iov-finally-its-almost-here-early-adopters-guide/238107/61


### Check if passthrough is possible

To find your GPU and its ID:

```bash
lspci -nn | grep -i vga
```

This will (in my case) return:
```bash
00:02.0 VGA compatible controller [0300]: Intel Corporation Arrow Lake-S [Intel Graphics] [8086:7d67] (rev 06)
04:00.0 VGA compatible controller [0300]: Intel Corporation Battlemage G21 [Intel Graphics] [8086:e211]
80:14.5 Non-VGA unclassified device [0000]: Intel Corporation Device [8086:7f2f] (rev 10)
```

Once you have that ID (like 04:00.0), you must ensure it isn't sharing a group with another device. Use this "one-liner" to see everything in that controller's group:

```bash
ls -la /sys/bus/pci/devices/0000:04:00.0/iommu_group/devices
```

If it returns only one item, you are good to go:

```bash
total 0
drwxr-xr-x 2 root root 0 Apr 26 11:08 .
drwxr-xr-x 3 root root 0 Apr 26 11:08 ..
lrwxrwxrwx 1 root root 0 Apr 26 11:08 0000:04:00.0 -> ../../../../devices/pci0000:00/0000:00:06.0/0000:02:00.0/0000:03:01.0/0000:04:00.0
```

**NOTE** The long string of numbers is the PCIe topology. It shows exactly how the signal travels from the CPU to your card:
pci0000:00 (Root Complex) → 00:06.0 (Root Port) → 02:00.0 (Switch/Bridge) → 03:01.0 (Bridge) → 04:00.0 (Your GPU).

### Set number of virtual GPUs

```bash
root@pve:~# find /sys/devices -path "*04:00.0*sriov_numvfs"
/sys/devices/pci0000:00/0000:00:06.0/0000:02:00.0/0000:03:01.0/0000:04:00.0/sriov_numvfs

# Set number of GPUs
echo 2 > /sys/devices/pci0000:00/0000:00:06.0/0000:02:00.0/0000:03:01.0/0000:04:00.0/sriov_numvfs

# Validate
root@pve:~# lspci -nnk | grep "Battlemage"
04:00.0 VGA compatible controller [0300]: Intel Corporation Battlemage G21 [Intel Graphics] [8086:e211]
04:00.1 VGA compatible controller [0300]: Intel Corporation Battlemage G21 [Intel Graphics] [8086:e211]
04:00.2 VGA compatible controller [0300]: Intel Corporation Battlemage G21 [Intel Graphics] [8086:e211]
```

Now to make this change persistent:

```bash
echo 'SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xe211", ATTR{sriov_numvfs}="2"' > /etc/udev/rules.d/60-vgpu.rules
udevadm control --reload-rules
udevadm trigger
```

### Passthrough vGPU

For Windows 11, make sure the VirtIO drivers are installed.

1. In the Proxmox gui, under Resource Mappings, create add a PCI Device mapping for each virtual GPU
1. Add the the PCI Device to the virtual machine
1. Install Intel Arc device drivers

## Using the VM: Parsec

You can access the VM using RDP, but that will not use the GPU (beter said: not fully, even with a lot of custom registry stuff). 
To use the VM with GPU acceleration: 

- Install [Parsec](https://parsec.app/downloads)
- Turn off VM
- Set display to None

## Troubleshooting

### PCIe Bus Errors

`dmesg` showed many RxErr from the GPU (device 06):

```bash
[  340.434036] pcieport 0000:00:06.0: AER: Correctable error message received from 0000:00:06.0
[  340.434037] pcieport 0000:00:06.0: PCIe Bus Error: severity=Correctable, type=Physical Layer, (Receiver ID)
[  340.434038] pcieport 0000:00:06.0:   device [8086:ae4d] error status/mask=00000001/00002000
[  340.434038] pcieport 0000:00:06.0:    [ 0] RxErr                  (First)
``` 

Changing the PCIex16 Link Speed to gen4 in the BIOS fixed that. But Gen5 should work fine. Created a support ticket at ASRock.

### Code 43

Windows driver installation works, but device manager shows Arc pro stopped (Code 43).
Fixed by setting CPU type to "host".