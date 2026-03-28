# Windows 11

How to create a Windows 11 ISO, debloated and with recent Windows updates slipstreamed. This ISO will be used whenever I need a basic Win11 VM.

## Download ISO

Microsoft already adds updates to their ISO's (download [here](https://www.microsoft.com/en-us/software-download/windows11)) - so no need to slipstream.

## Debloat

Using [Windows-ISO-Debloater](https://github.com/itsNileshHere/Windows-ISO-Debloater). Requires a Windows 10/11 PC with enough free space to unpack the ISO.

Just follow the instructions. If you want to run `.\isoDebloaterScript.ps1` directly, you might need to relax the execution policy:

```ps
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

For my setup I selected Windows 11 Pro N (no media apps bundled), and left all other options to their default value except for:

- Edge (not removed)
- User folders (removed)
- ISO compression (enabled)

## Add (slipstream) device drivers

Not required at this stage. Might come in handy once I want to create Win11 VM's. For now, it'll only be used for testing the host / updating firmware using Windows.

## Useful links

- https://www.microsoft.com/en-us/software-download/windows11
- https://github.com/itsNileshHere/Windows-ISO-Debloater
- https://uupdump.net/
