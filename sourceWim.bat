@Echo off

REM
REM Sets the PROCESSOR_ARCHITECTURE according to native platform for x86 and x64. 
REM
IF /I %PROCESSOR_ARCHITECTURE%==x86 (
    IF NOT "%PROCESSOR_ARCHITEW6432%"=="" (
        SET PROCESSOR_ARCHITECTURE=%PROCESSOR_ARCHITEW6432%
    )
) ELSE IF /I NOT %PROCESSOR_ARCHITECTURE%==amd64 (
    @echo Not implemented for PROCESSOR_ARCHITECTURE of %PROCESSOR_ARCHITECTURE%.
    @echo Using "%ProgramFiles%"
    
    SET NewPath="%ProgramFiles%"

    goto SetPath
)

REM
REM Query the 32-bit and 64-bit Registry hive for KitsRoot
REM

SET regKeyPathFound=1
SET wowRegKeyPathFound=1
SET KitsRootRegValueName=KitsRoot10

REG QUERY "HKLM\Software\Wow6432Node\Microsoft\Windows Kits\Installed Roots" /v %KitsRootRegValueName% 1>NUL 2>NUL || SET wowRegKeyPathFound=0
REG QUERY "HKLM\Software\Microsoft\Windows Kits\Installed Roots" /v %KitsRootRegValueName% 1>NUL 2>NUL || SET regKeyPathFound=0

if %wowRegKeyPathFound% EQU 0 (
  if %regKeyPathFound% EQU 0 (
    @echo KitsRoot not found, can't set common path for Deployment Tools
    goto :EOF 
  ) else (
    SET regKeyPath=HKLM\Software\Microsoft\Windows Kits\Installed Roots
  )
) else (
    SET regKeyPath=HKLM\Software\Wow6432Node\Microsoft\Windows Kits\Installed Roots
)


  
FOR /F "skip=2 tokens=2*" %%i IN ('REG QUERY "%regKeyPath%" /v %KitsRootRegValueName%') DO (SET KitsRoot=%%j)

REM
REM Build the D&I Root from the queried KitsRoot
REM
SET DandIRoot=%KitsRoot%Assessment and Deployment Kit\Deployment Tools

REM
REM Construct the path to WinPE directory, architecture-independent
REM
SET WinPERoot=%KitsRoot%Assessment and Deployment Kit\Windows Preinstallation Environment
SET WinPERootNoArch=%KitsRoot%Assessment and Deployment Kit\Windows Preinstallation Environment

REM
REM Construct the path to DISM, Setup and USMT, architecture-independent
REM
SET WindowsSetupRootNoArch=%KitsRoot%Assessment and Deployment Kit\Windows Setup
SET USMTRootNoArch=%KitsRoot%Assessment and Deployment Kit\User State Migration Tool

REM 
REM Constructing tools paths relevant to the current Processor Architecture 
REM
SET DISMRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\DISM
SET BCDBootRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\BCDBoot
SET ImagingRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\Imaging
SET OSCDImgRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\Oscdimg
SET WdsmcastRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\Wdsmcast

REM
REM Now do the paths that apply to all architectures...
REM
REM Note that the last one in this list should not have a
REM trailing semi-colon to avoid duplicate semi-colons
REM on the last entry when the final path is assembled.
REM
SET HelpIndexerRoot=%DandIRoot%\HelpIndexer
SET WSIMRoot=%DandIRoot%\WSIM

REM
REM Set ICDRoot. ICD is X86 only
REM
SET ICDRoot=%KitsRoot%Assessment and Deployment Kit\Imaging and Configuration Designer\x86

REM
REM Now buld the master path from the various tool root folders...
REM
REM Note that each fragment above should have any required trailing 
REM semi-colon as a delimiter so we do not put any here.
REM
REM Note the last one appended to NewPath should be the last one
REM set above in the arch. neutral section which also should not
REM have a trailing semi-colon.
REM
SET NewPath=%DISMRoot%;%ImagingRoot%;%BCDBootRoot%;%OSCDImgRoot%;%WdsmcastRoot%;%HelpIndexerRoot%;%WSIMRoot%;%WinPERoot%;%ICDRoot%

:SetPath
SET PATH=%NewPath:"=%;%PATH%

copype amd64 .\tmp
