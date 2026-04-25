# GPU

`dmesg` showed many RxErr from the GPU (device 06):

```bash
[  340.434036] pcieport 0000:00:06.0: AER: Correctable error message received from 0000:00:06.0
[  340.434037] pcieport 0000:00:06.0: PCIe Bus Error: severity=Correctable, type=Physical Layer, (Receiver ID)
[  340.434038] pcieport 0000:00:06.0:   device [8086:ae4d] error status/mask=00000001/00002000
[  340.434038] pcieport 0000:00:06.0:    [ 0] RxErr                  (First)
``` 

System Agent (SA) -> PCI Express Configuration -> PCIEX16(G5) Link Speed

Changing the PCIex16 Link Speed to gen4 in the BIOS fixed that.
