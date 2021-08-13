# rTS_WinPE build script
# PipeItToDevNull
#Requires -RunAsAdministrator

Write-Host "Sourcing our clean environment to ./tmp..." -ForegroundColor Green
& .\sourceWim.bat

Write-Host "Mounting WIM..." -ForegroundColor Green
dism /mount-image /imagefile:tmp\media\sources\boot.wim /index:1 /mountdir:tmp\mount

Write-Host "Adding packages..." -ForegroundColor Green
$packagePath = 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs'
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-WMI.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-NetFX.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-Scripting.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-PowerShell.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-SecureBootCmdlets.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-SecureStartup.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-StorageWMI.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-DismCmdlets.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-EnhancedStorage.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-FMAPI.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-WiFi-Package.cab"
dism /add-package /image:tmp\mount /packagepath:"$packagePath\WinPE-PlatformID.cab"

Write-Host "Setting scratch..." -ForegroundColor Green
dism /set-scratchspace:512 /image:tmp\mount

Write-Host "Putting our files in place..." -ForegroundColor Green
$sourceFiles = ".\mods\*"
$destDir = ".\tmp\mount\"
Copy-Item -Force -Recurse -Path $sourceFiles -Destination $destDir

Write-Host "Unmounting our WIM..." -ForegroundColor Green
dism /unmount-image /mountdir:tmp\mount /commit

Write-Host "Making an ISO..." -ForegroundColor Green
& .\makeISO.bat

Write-Host "Cleanup..." -ForegroundColor Green
Remove-Item -Recurse .\tmp