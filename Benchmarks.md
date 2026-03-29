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
