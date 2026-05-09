# TrueNAS

To allows TrueNAS to get full access to the HDDs (SMART info), the hard disk controller must be passed through. See [HBA.md](HBA.md), section _On-board SATA_.

## Installation
1. Download the [TrueNAS Community Edition (Scale)](https://www.truenas.com/download/). I am using version `25.10.3`
1. Create the VM:
    - Machine: q35
    - CPU type: Host
    - Cores: 2
    - RAM: 16GB
    - Disk: 16GB
    - Add HBA PCI device
1. Start the VM, follow the installation wizard. Select "No" when asked for UEFI boot.
1. Browse to the TrueNAS GUI (IP address is shown in the console)
1. Set a fixed IP address, e.g., 192.168.178.151/24
1. Update TrueNAS if available

## Adding datasets

1. Create a pool, e.g. "tank". All default settings.
1. Add a dataset for Dropbox, preset SMB share. This will enable the SMB service.
1. Follow instructions: https://www.truenas.com/docs/scale/25.10/scaletutorials/shares/smb/

## Snapshots / Windows Previous Versions

When snapshots are enabled, SMB shares show "previous versions" on Windows (r.click, properties).
Snapshots can be enabled by to Tasks -> Periodic Snapshot Tasks and adding tasks there.

**Important:** enable snapshots first, then create the SMB share. 