# Home Server Adventures

This repo contains notes on how I (try to) set up my home server. Target audience: future me, and whomever interested in a similar setup.

## Hardware

| Component | Product
| - | -
| Motherboard | [Asus Prime Z890-P Wifi](https://www.asus.com/us/motherboards-components/motherboards/prime/prime-z890-p-wifi/techspec/) - link to [manual](https://dlcdnta.asus.com/pub/ASUS/mb/LGA1851/PRIME%20Z890-P%20WIFI/E24237_PRIME_Z890-P_WIFI_EM_WEB.pdf?model=PRIME%20Z890-P%20WIFI&Signature=4H5tSZgiXWc5Grpqj3lNhP4j0aJqObPNqB3B2W4mhg9-rOX19FCWFjkd1SCvugfExreEehUHnAvHvUccTuv2TPdazfADk6muArz4BRc0koim0W8pARYUgHdxPj3XFiOWkmN~sLkTkaBRFmjqZrinB7J1M~dpFh4HLGqlSNJkHuG3HXWbnoRLS0lDUMnQtXTndtJtcgTlgxb3fq~eAhO9-Thm2m3hjlF8~E0836wN3PDbbOcmbRInpujop0aPHn-x3BUEClcPUHTffLw81SBNwehaKwk3h7KZrJ8FdSR0WtdwMwc2aFP~CP02oSA8xCAEv7NtAmv8jC699GBMJ5~eCQ__&Expires=1774638465&Key-Pair-Id=K2ITB7O97XKKCX)
| CPU | [Intel Core Ultra 7 processor 270K Plus](https://www.intel.com/content/www/us/en/products/sku/245692/intel-core-ultra-7-processor-270k-plus-36m-cache-up-to-5-50-ghz/specifications.html)
| CPU cooler | [Be quiet Pure Rock 3 PRO](https://www.bequiet.com/en/cpucooler/5599)
| GPU | [ASRock Intel Arc Pro B60 Creator 24G](https://www.asrock.com/Graphics-Card/Intel/Intel%20Arc%20Pro%20B60%20Creator%2024GB/)
| RAM | [Crucial Pro CP2K48G56C46U5 (2x48GB DDR5 UDIMM 5600mt/s CL46)](https://www.crucial.com/memory/ddr5/cp2k48g56c46u5)
| SSD | [WD_Black SN7100 NVMe - 1TB](https://support-en.sandisk.com/app/products/product-detailweb/p/9371)
| HDD | 4 x [Seagate Enterprise Capacity 3.5 HDD SAS 4Kn Secure, 8TB (p/n ST8000NM0095)](https://www.seagate.com/www-content/datasheets/pdfs/exos-7-e8-data-sheet-DS1957-1-1709US-en_US.pdf)
| SAS HBA | [Supermicro AOC-S3008L-L8E](https://www.supermicro.com/en/products/accessories/addon/aoc-s3008l-l8e.php) (in IT mode)
| PSU | [Be Quiet Pure Power 13 M 850W](https://www.bequiet.com/en/powersupply/5952)
| Case | [Fractal R5 Define](https://www.fractal-design.com/products/cases/define/define-r5/)

### Future HW upgrades

- RAM (max. 256GB), once prices drop... 
  - 4800 MT/s CL40 will be enough (1R, 2DPC) when using all 4 slots. 4400 MT/s when using 2R (dual rank). More info [here](https://edc.intel.com/content/www/us/en/design/products/platforms/details/arrow-lake-s/core-ultra-200s-series-processors-datasheet-volume-1-of-2/processor-sku-support-matrix/).\
  Asus however [tested](https://edgeup.asus.com/2025/aemp-iii-gives-you-a-seamless-experience-with-the-new-kingston-64gb-ddr5-memory-modules/) Kingston ValueRAM [KVR64A52BD8-64 4x64GB CUDIMM](https://tweakers.net/pricewatch/2173764/kingston-valueram-kvr64a52bd8-64.html) (€€€!) at 5600 MT/s on Z890 boards.
  - Check memory compatibility on the [Asus support site](https://www.asus.com/us/motherboards-components/motherboards/prime/prime-z890-p-wifi/helpdesk_qvl_memory?model2Name=PRIME-Z890-P-WIFI) (tab CPU/Memory Support).

## Goals

A server capable of serving multiple Linux / Windows VMs. The VMs will either be simple, single responsibility VMs, for instance:

- NAS
- Home Assistant
- InvenTree
- PostgreSQL
- Print server

Or workspaces, e.g.:

- Win11 with Fusion 360
- Debian with KiCAD
- Generic VScode dev environment
- Embedded development (IAI, etc.)
- Web development stack (LEMP + IDE's)

This will help me keep uncluttered workspaces with minimalistic version control (snapshots).

## TODO

- Update BIOS
- Install debloated [Windows 11](Windows.md)
- Update firmware
- Update drivers
- Measure core, bare metal PC performance (mem/cpu/ssd/hdd performance tests). To validate the components perform as expected, and then to be used as a baseline to validate VM performance.
- Measure temperature: is cooling capacity enough to keep the server running at 100% continuously (at normal room temperature)
- Repeat using Debian server.

At a later stage, measure power usage.

## README per subject

- [Motherboard](Motherboard.md)
- [Proxmox](Proxmox.md)
- [Benchmarks](Benchmarks.md)
- [Windows 11](Windows.md)
- [TrueNAS](TrueNAS.md)

## Useful tools

### Windows

- https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer
- https://sddashboarddownloads.sandisk.com/wdDashboard/DashboardSetup.exe


### OS-independent

- https://www.seagate.com/support/downloads/seatools/
- https://www.memtest86.com/