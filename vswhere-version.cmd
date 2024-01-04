@echo off
@rem parse the VCPKG VERSION output
set _vswhere_version_1=EMPTY
set _vswhere_version_2=EMPTY
for /f "tokens=5*" %%g in ('vswhere.exe version') do (
   set _vswhere_version_1=%%g
   if %_vswhere_version_1% NEQ "EMPTY" (
      goto continue
   )
)

:continue
for /f "tokens=8*" %%g in ('vswhere.exe version') do (
   set _vswhere_version_2=%%g
   if %_vswhere_version_2% NEQ "EMPTY" (
      goto next
   )
)

:next
set "_vswhere_version_2=%_vswhere_version_2:]=%"
@rem echo %_vswhere_version%