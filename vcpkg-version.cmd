@echo off 
@rem parse the VCPKG VERSION output
set _vcpkg_version=EMPTY
for /f "tokens=6*" %%g in ('.\vcpkg.exe version') do (
   set _vcpkg_version=%%g
   if %_vcpkg_version% NEQ "EMPTY" (
      goto next
   )
)
:next
@rem echo %_vcpkg_version%