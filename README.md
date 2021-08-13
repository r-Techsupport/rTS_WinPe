# WinPE

#### Use

You need the Windows PE ADK installed.

Run `setup.bat` to clone the WinPE environment into `/tmp` then copy those directories into the root of the project.

Remove `mount`

Mount wim
`dism /mount-image /imagefile:media\sources\boot.wim /index:1 /mountdir:mount`

Reset git to pull our changed data back into `mount`
`git reset --hard`

#### Working with WinPE

Mount wim
`dism /mount-image /imagefile:media\sources\boot.wim /index:1 /mountdir:mount`

Add package
`dism /add-package /image:mount /packagepath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-PowerShell.cab"`

Add files anywhere in `mount`

Edit startup file with commands
`mount\Windows\System32\Startnet.cmd`

Add temporary storage or scratch space. This is used by running applications
* WinPE reserves memory on the X: drive to unpack the WinPE files, plus additional temporary file storage, known as scratch space, that can be used by your applications. By default, this is 512MB for PCs with more than 1GB of RAM, otherwise the default is 32MB. Valid values are 32, 64, 128, 256, or 512.
`dism /set-scratchspace:512 /image:mount`

Umount WIM
`dism /unmount-image /mountdir:mount /commit`

Make media
`MakeWinPEMedia /ISO ./ ./WinPE.iso`

#### Important files

`Windows\System32\startnet.cmd`

`Windows\System32\Winpeshl.ini`

#### Added modules
WinPE-WMI
WinPE-NetFX
WinPE-Scripting
WinPE-PowerShell
WinPE-SecureBootCmdlets
WinPE-SecureStartup
WinPE-StorageWMI
WinPE-DismCmdlets
WinPE-EnhancedStorage
WinPE-FMAPI
WinPE-WiFi-Package
WinPE-PlatformID

#### Tools

##### File Management
* Explorer++
* 7zip
* Notepad++

##### Disk Tools
* CrystalDisk Info

##### Diagnostics
* Speccy
* OpenHardwareMonitor

##### Stress Testing
* Hwinfo
* Furmark
* Prime95

##### Sources
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/wpeinit-and-startnetcmd-using-winpe-startup-scripts 