@echo off
@cls
@setlocal enableextensions enabledelayedexpansion

@rem %_VCPKG_TOOL_EXE% install --recurse --keep-going --dry-run "@%_VCPKG_PORTS%" >>%_VCPKG_LOG% 2>>&1
@rem %_VCPKG_TOOL_EXE% install --recurse --keep-going --debug "@%_VCPKG_PORTS%" >>%_VCPKG_LOG% 2>>&1
@rem %_VCPKG_TOOL_EXE% install --recurse --keep-going --head "@%_VCPKG_PORTS%" >>%_VCPKG_LOG% 2>>&1
@rem
@rem %_VCPKG_TOOL_EXE% install --recurse --keep-going --clean-after-build "@%_VCPKG_PORTS%" >>%_VCPKG_LOG% 2>>&1

@%_DEV_ROOT_DRV%
@cd %_DEV_ROOT_DRV%\

@if not exist %_VCPKG_ROOT_DIR% (
    @echo ERROR: Vcpkg installation required but not installed - please install
    @goto :end-script
)

@for /f "tokens=*" %%g in ('where pwsh.exe') do (@set _VCPKG_PWSH_EXE=%%g)

@if "%_VCPKG_PWSH_EXE%" equ "" (
    @echo ERROR: Powershell Core required but not installed - please install
    @goto :end-script
)

@cd  %_VCPKG_ROOT_DIR%

@if not exist %_VCPKG_TOOL_EXE% (
    @echo ERROR: Vcpkg executable binary required but not installed - please install
    @goto :end-script
)

@set _VCPKG_PORTS=%_VCPKG_GIT_SCRIPTS_DIR%\vcpkg-sdl3.txt
@set _VCPKG_LOG=%_VCPKG_GIT_LOGS_DIR%\vcpkg-sdl3.log

@if not exist %_VCPKG_PORTS% (
    @echo ERROR: Vcpkg file of ports to install %_VCPKG_PORT% is missing - please create
    @goto :end-script
)

@set PARM_1=%1
@set PARM_2=%2

@if defined PARM_1 (
    @for /f "tokens=* delims= eol= usebackq" %%a in (`pwsh -NoLogo -NoProfile -Command "'%PARM_1%'.ToLower()"`) do (set "PARM_1=%%~a")
)

@if defined PARM_1 (
    @if "%PARM_1%" equ "debug" (
        @set _VCPKG_DEBUG=--debug --debug-env --x-cmake-args=-DVCPKG_CMAKE_CONFIGURE_OPTIONS=--trace-expand
    )
    @if "%PARM_1%" equ "dry-run" (
        @set _VCPKG_DRY_RUN=--dry-run
    )
)

@if defined PARM_2 (
    @for /f "tokens=* delims= eol= usebackq" %%a in (`pwsh -NoLogo -NoProfile -Command "'%PARM_2%'.ToLower()"`) do (set "PARM_2=%%~a")
)

@if defined PARM_2 (
    @if "%PARM_2%" equ "debug" (
        @set _VCPKG_DEBUG=--debug --debug-env --x-cmake-args=-DVCPKG_CMAKE_CONFIGURE_OPTIONS=--trace-expand --cmake-args=-DPORT_DEBUG=ON
    )
    @if "%PARM_2%" equ "dry-run" (
        @set _VCPKG_DRY_RUN=--dry-run
    )
)

@rem set _VCPKG_CMD=%_VCPKG_TOOL_EXE% install --binarysource=%VCPKG_BINARY_SOURCES% --clean-buildtrees-after-build --clean-packages-after-build --no-print-usage --downloads-root=%_VCPKG_DOWNLOADS_DIR% --host-triplet=%VCPKG_DEFAULT_HOST_TRIPLET% --keep-going --overlay-ports=%_VCPKG_OVERLAY_PORTS% --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --recurse --triplet=%VCPKG_DEFAULT_TRIPLET% --vcpkg-root=%_VCPKG_ROOT_DIR% --x-asset-sources=%X_VCPKG_ASSET_SOURCES% --x-buildtrees-root=%_VCPKG_BUILDTREES_DIR% --x-install-root=%_VCPKG_INSTALLED_DIR%

@set _VCPKG_CMD=%_VCPKG_TOOL_EXE% install --classic --clean-buildtrees-after-build --clean-packages-after-build --no-print-usage --downloads-root=%VCPKG_DOWNLOADS% --host-triplet=%VCPKG_DEFAULT_HOST_TRIPLET% --keep-going --overlay-ports=%_VCPKG_OVERLAY_PORTS% --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --recurse --triplet=%VCPKG_DEFAULT_TRIPLET% --vcpkg-root=%_VCPKG_ROOT_DIR% --x-asset-sources=%X_VCPKG_ASSET_SOURCES% --x-buildtrees-root=%_VCPKG_BUILDTREES_DIR% --x-install-root=%_VCPKG_INSTALLED_DIR%

@rem set _VCPKG_CMD=%_VCPKG_TOOL_EXE% install --recurse --keep-going --no-print-usage --editable

@if defined _VCPKG_DEBUG (@set _VCPKG_CMD=%_VCPKG_CMD% %_VCPKG_DEBUG%)
@if defined _VCPKG_DRY_RUN (@set _VCPKG_CMD=%_VCPKG_CMD% %_VCPKG_DRY_RUN%)

@set _VCPKG_CMD=%_VCPKG_CMD% "@%_VCPKG_PORTS%"

@set >%_VCPKG_LOG%
@echo. >>%_VCPKG_LOG%
@echo. >>%_VCPKG_LOG%

@echo. >>%_VCPKG_LOG%
@echo ------------------- triplet: x64-windows ---------------------------------------------------- >>%_VCPKG_LOG%
@echo. >>%_VCPKG_LOG%

@echo %_VCPKG_CMD%
@echo %_VCPKG_CMD% >>%_VCPKG_LOG%

@%_VCPKG_CMD% >>%_VCPKG_LOG% 2>>&1

@rem echo %_VCPKG_TOOL_EXE% install --recurse --keep-going --clean-buildtrees-after-build --clean-packages-after-build --no-print-usage  %_VCPKG_DRY_RUN% %_VCPKG_DEBUG% --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --overlay-ports=%_VCPKG_OVERLAY_PORTS% "@%_VCPKG_PORTS%" >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@::%_VCPKG_TOOL_EXE% install --recurse --keep-going --debug --debug-env --clean-buildtrees-after-build --clean-packages-after-build --no-print-usage --x-cmake-args=-DVCPKG_CMAKE_CONFIGURE_OPTIONS=--trace-expand  --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --overlay-ports=%_VCPKG_OVERLAY_PORTS% "@%_VCPKG_PORTS%" >>%_VCPKG_LOG% 2>>&1

@rem %_VCPKG_TOOL_EXE% install --recurse --keep-going --clean-buildtrees-after-build --clean-packages-after-build --no-print-usage %_VCPKG_DRY_RUN% %_VCPKG_DEBUG% --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --overlay-ports=%_VCPKG_OVERLAY_PORTS% "@%_VCPKG_PORTS%" >>%_VCPKG_LOG% 2>>&1

::%_VCPKG_TOOL_EXE% install --recurse --keep-going --no-print-usage --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --overlay-ports=%_VCPKG_OVERLAY_PORTS% "@%_VCPKG_PORTS%" >>%_VCPKG_LOG% 2>>&1

:end-script
@endlocal