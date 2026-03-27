# TrueNAS

If possible, the integrated SATA will be put in passthrough mode. Why? This allows the NAS to get full access to the HDDs (SMART info).

## TODO

- Check if passthrough is possible, depends on IOMMU isolation, many ways to crash Proxmox host.

## File system

ZFS RaidZ2. Uses 4 HDDs. 4x8TB will leave approx. 12TB usable storage space but with high redundancy. Why? drives have been running nearly 7 years.