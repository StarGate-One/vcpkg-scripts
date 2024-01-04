@echo off
@rem parse the NINJA --VERSION output
for /f "tokens=* USEBACKQ" %%g in (`ninja.exe --version`) do (set "_ninja_version=%%g")
@rem set %_ninja_version%