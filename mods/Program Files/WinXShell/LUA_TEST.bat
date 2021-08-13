@echo off
cd /d "%~dp0"

set WINXSHELL=WinXShell.exe
set x8664=x64
if not "x%PROCESSOR_ARCHITECTURE%"=="xAMD64" set x8664=x86
if not exist %WINXSHELL% set WINXSHELL=WinXShell_%x8664%.exe

%WINXSHELL% -code "winapi.show_message('title', 'message')"
pause
%WINXSHELL% -code "Taskbar:Pin('cmd.exe', nil, '/k echo lua_test', 'shell32.dll', 27)"
