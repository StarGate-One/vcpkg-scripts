@echo off 
@rem parse the CMAKE --VERSION output
set _cmake_version=EMPTY
for /f "tokens=3*" %%g in ('cmake --version') do (
	set _cmake_version=%%g
	if %_cmake_version% NEQ "EMPTY" (
		goto next
	)
)
:next
@rem echo %_cmake_version%