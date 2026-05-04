# TrueNAS

To allows TrueNAS to get full access to the HDDs (SMART info), the hard disk controller must be passed through. See [HBA.md](HBA.md)

**Important:** Deselect Rombar, otherwise the VM will try to boot from the HBA.

## Installation
1. Download the [TrueNAS Core ISO](https://www.truenas.com/download-truenas-legacy/). I am using version 13.3-U1.2. Why not [TrueNAS Community Edition (Scale)](https://www.truenas.com/truenas-community-edition/)? See section "Reading HBA chip temp".
1. Create the VM:
    - Machine: q35
    - CPU type: Host
    - Cores: 2
    - RAM: 16GB
    - Disk: 16GB
    - Add HBA PCI device (disable Rombar, enable PCI-Express)

Follow the installation wizard.

Optional: enable SSH access via Services > SSH.

## File system

ZFS RaidZ2. Uses 4 HDDs. 4x8TB will leave approx. 12TB usable storage space but with high redundancy. Why? drives have been running nearly 7 years.

## Reading HBA chip temp

Not possible with TrueNAS Scale (Community Editon). Tried everything, but storcli won't detect the HBA. All drives work fine, but it's just not able to read the chip temp.

TrueNAS Core is older (deprecated, but still receiving security updates), it's FreeBSD based. It's able to read chip temperature by using `mprutil show adapter`:

```bash
root@truenas[~]# mprutil show adapter
mpr0 Adapter:
       Board Name: SAS9300-8i
   Board Assembly:
        Chip Name: LSISAS3008
    Chip Revision: ALL
    BIOS Revision: 18.00.00.00
Firmware Revision: 16.00.12.00
  Integrated RAID: no
         SATA NCQ: ENABLED
 PCIe Width/Speed: x4 (8.0 GB/sec)
        IOC Speed: Full
      Temperature: 44 C

PhyNum  CtlrHandle  DevHandle  Disabled  Speed   Min    Max    Device
0                              N                 3.0    12     SAS Initiator
1                              N                 3.0    12     SAS Initiator
```

Validated the temperature readout by using `storcli` on the host.

## Sending temperature info to host

### Add serial port
Shutdown the VM and add a serial port:

```bash
qm set 101 -serial0 socket
# replace 101 with VM id
```

Start the VM, and validate the serial port is available:

```bash
dmesg | grep uart
# Note that FreeBSD uses uart, not tty
uart0: <16550 or compatible> port 0x3f8-0x3ff irq 4 flags 0x10 on acpi0 
``` 

### Test serial connection VM -> Host

On Proxmox end: 
```bash
qm terminal 101
```

At TrueNAS:
```bash
echo "Hello from TrueNAS" > /dev/cuau0
# Note: In FreeBSD, /dev/cuauX is the call-out device used for sending data
```

### Send temperature data to serial port

1. Create [/usr/bin/local/hba_monitor.sh](hba_monitor.sh)
1. Create [/usr/local/etc/rc.d/hba_monitor](hba_monitor.rc.d)
1. Make the files executable and enable the service:
    ```bash
    chmod +x /usr/bin/local/hba_monitor.sh
    chmod +x /usr/local/etc/rc.d/hba_monitor
    # Start automatically after boot
    sysrc hba_monitor_enable="YES"
    service hba_monitor start
    ```
1. To avoid log file cancer, add `/var/log/hba_monitor.log                640  1     100  *     JC` to `/etc/newsyslog.conf`. Validate by running `newsyslog -nv`.

To control Proxmox host fan speed, enable the `hba-fan-control` service (see [HBA.md](HBA.md)).
