@echo off 

set _temp_file=%TEMP%\cl_version.txt
set _cpp_version=EMPTY
cl > NUL 2> %_temp_file%

@rem parse the C/C++ output
for /f "tokens=7 usebackq" %%g in ("%_temp_file%") do (
	set _cpp_version=%%g
	if %_cpp_version% NEQ "EMPTY" (
		goto continue
	)
)
:continue
@rem echo %_CPP_Version%
del /q %_temp_file%
set _temp_file=

set _vs_version=EMPTY
for /f "tokens=1* delims=." %%g in ('vswhere -version 16 -property displayName') do (
	set _vs_version=%%g
	if %_vs_version% NEQ "EMPTY" (
		goto next
	)
)
:next