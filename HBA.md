# Supermicro HBA

The HBA controller chip needs cooling (its a server board, expecting high air flow).
To reduce the chip temperature, I added a server fan I had laying around ([Delta PFB0412EHN](https://www.delta-fan.com/pfb0412ehn-tp06.html)). It is connected to `CHA_FAN2`, and mounted on a 3D printed bracket. The fan blows directly at the HBA heatsink.

## Reading fan status

```bash
apt install lm_sensors
sensors-detect --auto
sensors
```

Which should return something like:

```text
coretemp-isa-0000
Adapter: ISA adapter
Package id 0:  +33.0°C  (high = +85.0°C, crit = +105.0°C)
Core 0:        +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 4:        +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 8:        +32.0°C  (high = +85.0°C, crit = +105.0°C)
Core 9:        +32.0°C  (high = +85.0°C, crit = +105.0°C)
Core 10:       +32.0°C  (high = +85.0°C, crit = +105.0°C)
Core 11:       +32.0°C  (high = +85.0°C, crit = +105.0°C)
Core 12:       +28.0°C  (high = +85.0°C, crit = +105.0°C)
Core 13:       +28.0°C  (high = +85.0°C, crit = +105.0°C)
Core 14:       +28.0°C  (high = +85.0°C, crit = +105.0°C)
Core 15:       +28.0°C  (high = +85.0°C, crit = +105.0°C)
Core 16:       +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 20:       +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 24:       +32.0°C  (high = +85.0°C, crit = +105.0°C)
Core 28:       +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 32:       +28.0°C  (high = +85.0°C, crit = +105.0°C)
Core 33:       +28.0°C  (high = +85.0°C, crit = +105.0°C)
Core 34:       +28.0°C  (high = +85.0°C, crit = +105.0°C)
Core 35:       +28.0°C  (high = +85.0°C, crit = +105.0°C)
Core 36:       +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 37:       +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 38:       +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 39:       +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 40:       +30.0°C  (high = +85.0°C, crit = +105.0°C)
Core 44:       +30.0°C  (high = +85.0°C, crit = +105.0°C)

nvme-pci-0100
Adapter: PCI adapter
Composite:    +29.9°C  (low  = -40.1°C, high = +89.8°C)
                       (crit = +93.8°C)
Sensor 1:     +44.9°C  (low  = -273.1°C, high = +65261.8°C)
Sensor 2:     +30.9°C  (low  = -273.1°C, high = +65261.8°C)

acpitz-acpi-0
Adapter: ACPI interface
temp1:        +27.8°C

mt7925_phy0-pci-8300
Adapter: PCI adapter
temp1:        +31.0°C

r8169_0_8400:00-mdio-0
Adapter: MDIO adapter
temp1:        +36.0°C  (high = +120.0°C)

```

The motherboard has a NCT6799 chip that controls the fans and reads their RPM. We need to probe it to show its I/O.
We can probe it manually by executing `modprobe nct6775` (yes, a different chip name, but the same family). Now the `sensors` command should output more data, for example:

```text
nct6799-isa-0290
Adapter: ISA adapter
in0:                            1.25 V  (min =  +0.00 V, max =  +1.74 V)
in1:                          1000.00 mV (min =  +0.00 V, max =  +0.00 V)  ALARM
in2:                            3.39 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in3:                            3.34 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in4:                            1.02 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in5:                          832.00 mV (min =  +0.00 V, max =  +0.00 V)
in6:                            1.05 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in7:                            3.39 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in8:                            3.14 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in9:                            1.25 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in10:                           1.01 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in11:                         688.00 mV (min =  +0.00 V, max =  +0.00 V)  ALARM
in12:                           1.02 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in13:                           1.13 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in14:                         616.00 mV (min =  +0.00 V, max =  +0.00 V)  ALARM
in15:                         992.00 mV (min =  +0.00 V, max =  +0.00 V)  ALARM
in16:                           1.79 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
in17:                           1.08 V  (min =  +0.00 V, max =  +0.00 V)
fan1:                          702 RPM  (min =    0 RPM)
fan2:                          456 RPM  (min =    0 RPM)
fan3:                         2323 RPM  (min =    0 RPM)
fan4:                            0 RPM  (min =    0 RPM)
fan5:                          644 RPM  (min =    0 RPM)
fan6:                            0 RPM  (min =    0 RPM)
fan7:                            0 RPM  (min =    0 RPM)
SYSTIN:                        +26.0°C  (high = +80.0°C, hyst = +75.0°C)
                                        (crit = +125.0°C)  sensor = thermistor
CPUTIN:                        +25.5°C  (high = +80.0°C, hyst = +75.0°C)
                                        (crit = +125.0°C)  sensor = thermistor
AUXTIN0:                       +23.0°C  (high = +80.0°C, hyst = +75.0°C)
                                        (crit = +125.0°C)  sensor = thermistor
AUXTIN1:                       +25.0°C  (high = +80.0°C, hyst = +75.0°C)
                                        (crit = +125.0°C)  sensor = thermistor
AUXTIN2:                       +43.0°C  (high = +80.0°C, hyst = +75.0°C)
                                        (crit = +125.0°C)  sensor = thermistor
AUXTIN3:                       +49.0°C  (high = +80.0°C, hyst = +75.0°C)
                                        (crit = +127.0°C)  sensor = thermistor
AUXTIN4:                       +35.0°C  (high = +80.0°C, hyst = +75.0°C)
                                        (crit = +100.0°C)
PECI/TSI Agent 0 Calibration:  +26.0°C  (high = +80.0°C, hyst = +75.0°C)
AUXTIN5:                       +21.0°C
PCH_CHIP_CPU_MAX_TEMP:          +0.0°C
PCH_CHIP_TEMP:                  +0.0°C
PCH_CPU_TEMP:                   +0.0°C
pwm1:                              78%  (mode = pwm)
pwm2:                              30%  (mode = pwm)
pwm3:                              30%  (mode = pwm)
pwm4:                              78%  (mode = pwm)
pwm5:                              78%  (mode = pwm)
pwm7:                             128%  (mode = pwm)
intrusion0:                   ALARM
intrusion1:                   ALARM
beep_enable:                  disabled
```

Note the unexpected pwm percentage on pwm7: 128 is actually 50% (the scale is 0-255).

## Changing fan speeds

### BIOS

Change the CHA_FAN2 profile in the Q-Fan Control screen.

Settings:

- Manual mode
- Source: MotherBoard (ambient temperature in the case?)
- Profile:
  - Duty Cycle at 0°C: 25%
  - Duty Cycle at 30°C: 33%
  - Duty Cycle at 45°C: 100%

### Terminal

To control fan speed, we need to check on which port the chip is connected. First check which hardware monitor devices are available:

```bash
ls /sys/class/hwmon
hwmon0  hwmon1  hwmon2  hwmon3  hwmon4  hwmon5  hwmon6
```

Then, find the NCT chip:

```bash
cat /sys/class/hwmon/hwmon*/name
acpitz # 0
r8169_0_8400:00 # 1
nvme # 2
asus # 3
coretemp # 4
mt7925_phy0 # 5
nct6799 # number 6!
```

**NOTE:** The order (and therefore the number) can be different after reboot.

Chassis fan 2 is on pwm3. We can change the fan speed by first changing the PWM mode to MANUAL:

`echo 1 > /sys/class/hwmon/hwmon6/pwm3_enable`

And then writing a new PWM value (0-255) to the PWM port:

`echo 128 | tee /sys/class/hwmon/hwmon6/pwm3`

**NOTE:** Changes are lost after reboot.

## Supermicro HBA chip temperature

Use [StorCLI].

1. Download `https://docs.broadcom.com/docs/1232743397`
1. Extract `storcli64` from the archive. It can be found at `007.2705.0000.0000_storcli_rel.zip\storcli_rel\Unified_storcli_all_os.zip\Unified_storcli_all_os\Linux\storcli-007.2705.0000.0000-1.noarch.rpm\storcli-007.2705.0000.0000-1.noarch.cpio\.\opt\MegaRAID\storcli\`
1. Upload it to Proxmox, for instance by using [WinSCP](https://winscp.net/eng/index.php)
1. Make executable: `chmod +x storcli64`

Find the controller:

```bash
storcli64 show
CLI Version = 007.2705.0000.0000 August 24, 2023
Operating system = Linux 6.17.13-2-pve
Status Code = 0
Status = Success
Description = None

Number of Controllers = 1
Host Name = pve
Operating System  = Linux 6.17.13-2-pve
StoreLib IT Version = 07.2703.0200.0000
StoreLib IR3 Version = 16.14-0

IT System Overview :
==================

-------------------------------------------------------------------------
Ctl Model      AdapterType   VendId DevId SubVendId SubDevId PCI Address
-------------------------------------------------------------------------
  0 SAS9300-8i   SAS3008(C0) 0x1000  0x97    0x15D9    0x808 00:85:00:00
-------------------------------------------------------------------------
```

Get basic controller info:

```bash
 ./storcli64 /c0 show
CLI Version = 007.2705.0000.0000 August 24, 2023
Operating system = Linux 6.17.13-2-pve
Controller = 0
Status = Success
Description = None

Product Name = SAS9300-8i
Serial Number = 500304801a516902
SAS Address =  500304801a516902
PCI Address = 00:85:00:00
System Time = 04/22/2026 21:49:30
FW Package Build = 00.00.00.00
FW Version = 16.00.12.00
BIOS Version = 08.37.00.00_18.00.00.00
NVDATA Version = 14.01.00.07
Driver Name = mpt3sas
Driver Version = 52.100.00.00
Bus Number = 133
Device Number = 0
Function Number = 0
Domain ID = 0
Vendor Id = 0x1000
Device Id = 0x97
SubVendor Id = 0x15D9
SubDevice Id = 0x808
Board Name = SAS9300-8i
Board Assembly = N/A
Board Tracer Number = N/A
Security Protocol = None
```

Read chip temperature with the [temperature command](https://techdocs.broadcom.com/us/en/storage-and-ethernet-connectivity/enterprise-storage-solutions/storcli-12gbs-megaraid-tri-mode/1-0/v11869215/v11673749/v11673787/StorCLI_Temp_CMD.html):

```bash
./storcli64 /c0 show temperature
CLI Version = 007.2705.0000.0000 August 24, 2023
Operating system = Linux 6.17.13-2-pve
Controller = 0
Status = Success
Description = None


Controller Properties :
=====================

--------------------------------------
Ctrl_Prop                       Value
--------------------------------------
ROC temperature(Degree Celsius) 46
--------------------------------------
```

ROC = "RAID on Chip".

**TODO:** enabling/disabling the fan has no effect on temperature. Slow polling? Wrong info? stress test the controller and see if temp increases.

Solution based on: https://forums.unraid.net/topic/155951-parse-temperature-of-hba-9300-16i-lsi-sas3008-controller/

## SASIRCU

Not useful as yet, but keeping this info for when the tool is needed.

Use [SAS3IRCU](https://docs.broadcom.com/doc/12353382) to get info on the SAS controller and its disk.

1. Download `https://docs.broadcom.com/docs/SAS3IRCU_P16.zip`
1. Upload it to Proxmox, for instance by using [WinSCP](https://winscp.net/eng/index.php)
1. Extract  `sas3ircu` and make it executable:

    ```bash
    # apt install unzip
    unzip -q SAS3IRCU_P16.zip -d /tmp/sas3ircu
    cp /tmp/sas3ircu/SAS3IRCU_P16/sas3ircu_rel/sas3ircu/sas3ircu_linux_x64_rel/sas3ircu .
    chmod +x sas3ircu
    ```

Check if the adapter is reachable:

```bash
./sas3ircu list
Avago Technologies SAS3 IR Configuration Utility.
Version 17.00.00.00 (2018.04.02)
Copyright (c) 2009-2018 Avago Technologies. All rights reserved.


        Adapter      Vendor  Device                       SubSys  SubSys
Index    Type          ID      ID    Pci Address          Ven ID  Dev ID
-----  ------------  ------  ------  -----------------    ------  ------
0     SAS3008       1000h   97h    00h:85h:00h:00h      15d9h   0808h
SAS3IRCU: Utility Completed Successfully.
```

To get some basic info:

```bash
./sas3ircu 0 display
Avago Technologies SAS3 IR Configuration Utility.
Version 17.00.00.00 (2018.04.02)
Copyright (c) 2009-2018 Avago Technologies. All rights reserved.

Read configuration has been initiated for controller 0
------------------------------------------------------------------------
Controller information
------------------------------------------------------------------------
  Controller type                         : SAS3008
  BIOS version                            : 8.37.00.00
  Firmware version                        : 16.00.12.00
  Channel description                     : 1 Serial Attached SCSI
  Initiator ID                            : 0
  Maximum physical devices                : 1023
  Concurrent commands supported           : 9856
  Slot                                    : 5
  Segment                                 : 0
  Bus                                     : 133
  Device                                  : 0
  Function                                : 0
  RAID Support                            : No
------------------------------------------------------------------------
IR Volume information
------------------------------------------------------------------------
------------------------------------------------------------------------
Physical device information
------------------------------------------------------------------------
------------------------------------------------------------------------
Enclosure information
------------------------------------------------------------------------
  Enclosure#                              : 1
  Logical ID                              : 50030480:1a516902
  Numslots                                : 8
  StartSlot                               : 0
------------------------------------------------------------------------
SAS3IRCU: Command DISPLAY Completed Successfully.
SAS3IRCU: Utility Completed Successfully.
```
