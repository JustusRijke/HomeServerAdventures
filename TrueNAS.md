# TrueNAS

To allows TrueNAS to get full access to the HDDs (SMART info), the hard disk controller must be passed through. 

## Check if passthrough is possible

### SATA

To find your SATA controller and its ID:

```bash
lspci -nn | grep -i sata
```

This will (in my case) return:
```bash
80:17.0 SATA controller [0106]: Intel Corporation Device [8086:7f62] (rev 10)
```

Once you have that ID (like 80:17.0), you must ensure it isn't sharing a group with your NVMe drive. Use this "one-liner" to see everything in that controller's group:

```bash
# Replace 80:17.0 with your actual SATA ID from the step above
ls -la /sys/bus/pci/devices/0000:80:17.0/iommu_group/devices
```

If it returns only the actual SATA device, you are good to go:

```bash
total 0
drwxr-xr-x 2 root root 0 Apr 13 21:05 .
drwxr-xr-x 3 root root 0 Apr 13 21:05 ..
lrwxrwxrwx 1 root root 0 Apr 13 21:05 0000:80:17.0 -> ../../../../devices/pci0000:80/0000:80:17.0
```

You can now add the raw PCI device to a VM. Check the box for All Functions (to ensure the VM gets everything on that controller) and PCI-Express (at least when passing through to Windows, unsure if required for Linux).

### SAS

However, the server contains SAS drives, which are not supported by the motherboard (SATA controller). A [Supermicro AOC-S3008L-L8E](https://www.supermicro.com/en/products/accessories/addon/aoc-s3008l-l8e.php) is used to connect the HDDs.

The procedure is identical:

```bash
lspci -nn | grep -i sas
# 85:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS3008 PCI-Express Fusion-MPT SAS-3 [1000:0097] (rev 02)
ls -la /sys/bus/pci/devices/0000:85:00.0/iommu_group/devices
# total 0
# drwxr-xr-x 2 root root 0 Apr 16 15:33 .
# drwxr-xr-x 3 root root 0 Apr 16 15:33 ..
# lrwxrwxrwx 1 root root 0 Apr 16 15:33 0000:85:00.0 -> ../../../../d # # devices/pci0000:80/0000:80:1c.4/0000:85:00.0
```


## TODO

- Check if passthrough is possible, depends on IOMMU isolation, many ways to crash Proxmox host.

## File system

ZFS RaidZ2. Uses 4 HDDs. 4x8TB will leave approx. 12TB usable storage space but with high redundancy. Why? drives have been running nearly 7 years.