# Benchmarks

## Linux (Debian)

Basic CPU/RAM tests (only using 1 thread).

### CPU

```bash
apt install sysbench -y
sysbench cpu --cpu-max-prime=20000 run
```

### RAM

```bash
sysbench memory --memory-block-size=1M --memory-total-size=10G run
```
## Results

Results (events per second):

| System | CPU | RAM
| - | - | -
| Intel NUC i3 (Proxmox host) | 2950 | 10240
| Intel NUC i3 (Debian 13 LXC) | 2925 | 10240
| Intel NUC i3 (Debian 13 VM) | 2930 | 10240

## Windows 11

### Passmark

| System | CPU | 2D Graphics | 3D Graphics | Memory | Disk
| - | - | - | - | - | -
| Bare metal with iGPU | 70074 | 876 | 4111 | 4092 | 56351
| Bare metal with Intel Arc Pro B60 | 69554 | 936 | 16762 | 4092 | 56241
| VM (1 socket / 4 cores / 16 GiB RAM, IDE controller) | 12727 | - | - | 3470 | 37273 (IDE)
| VM (8 GiB RAM, no KSM/ballooning, SCSI controller)) | 12765 | - | - | 3082 (because of 8 GiB?) | 52656 (SCSI)