# Motherboard

## BIOS update

Link to [BIOS Manual](https://dlcdnta.asus.com/pub/ASUS/mb/13MANUAL/E26236_Intel_800_Series_BIOS_manual_EM_WEB.pdf?model=PRIME%20Z890-P%20WIFI&Signature=hKKzAnHsCbR948LaCHx~nEkbjeZT3K5-LS~s2b-LOYJzUjD9DeQa-Ael7kr20Vk78Xtd~ur17o3SxP7JgvUSYM4rW83uOrx-Y3rpdp1c6XVMjpzOZvWZpI8WIo2hIEcIsgFfJrsWfujnXgFwoRVsgjCksxfqe8OCYOn0WOTUstCM2e6JyoDw~HQJe3MYkBoqe-FWK22yKsRnwtWIVYhVcVbzZorK0JME2lIyWHakxw~RChSzCnwUunsrCt0WZgfPAgmMqZm6rGsZO5Lq9S9j-AyP39-VPiyQswES3bH76NRUuvDJ0FKSOIBVYpDKI1pJcuqU6h044y1dLNM-gA~9Dw__&Expires=1774705761&Key-Pair-Id=K2ITB7O97XKKCX)

TODO: first check current version, maybe update not required. Latest version can be found [here](https://www.asus.com/us/motherboards-components/motherboards/prime/prime-z890-p-wifi/helpdesk_bios?model2Name=PRIME-Z890-P-WIFI).

### Settings

Suggested changes (non-defaults). Skip for now, first benchmark with defaults.

| Section | Setting | Value | Description |
| - | - | - | - |
| Advanced Mode | AURA | Off | RGB LED lighting, bloat |
| Advanced Mode | ReSize BAR | t.b.d. | Maybe needed for Intel Arc sharing |
| PCI Subsystem | SR-IOV Support | Enabled | Maybe needed for Intel Arc sharing / disk controler passthru |
| System Agent | VT-d | Enabled | Allows VMs to run |
| Boot | Fast Boot | Disabled | Do not skip checks |
| Boot | Secure Boot | Disabled | Maybe needed when isntalling Win11 on host |
| CPU | Intel (VMX) Virtualization Technology | Enabled | Allows VMs to run |
| CPU | CPU C-states | Disabled | CPU Power Management, known to cause Proxmox instability |
| Thunderbolt | Integrated Thunderbolt(TM) | Disabled | Not used. [Free up PCIe resources](https://forum.level1techs.com/t/intel-arc-pro-b60-sr-iov-not-working-with-asrock-b760-pro-rs/246317/16). |
| Trusted Computing | Security Device Support | Disabled | Bloat, but required for Win11 |
