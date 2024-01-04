@echo off 
@rem parse the VER command output
for /f "tokens=4*" %%g in ('ver') do set _windows_version=%%g 
@rem echo %_windows_version%
set "_windows_version=%_windows_version:]=%"
for /f "tokens=1*" %%h in ("%_windows_version%") do set _windows_version=%%h