@echo off
@setlocal enableextensions enabledelayedexpansion

@%_DEV_ROOT_DRV%
@cd %_DEV_ROOT_DRV%\

@if not exist %_VCPKG_ROOT_DIR% (
    @echo ERROR: Vcpkg installation required but not installed - please install
    @goto :end-script
)

@cd  %_VCPKG_ROOT_DIR%

@if not exist %_VCPKG_TOOL_EXE% (
    @echo ERROR: Vcpkg executable binary required but not installed - please install
    @goto :end-script
)

@set _VCPKG_LOG=%_VCPKG_GIT_LOGS_DIR%\vcpkg-search.log

@echo. >%_VCPKG_LOG%
@echo                                                   Vcpkg >>%_VCPKG_LOG%
@echo                                         Search of Available ports >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\vcpkg-list-versions.cmd

@echo  Port Name/Feature(s)       Version                                       Description >>%_VCPKG_LOG%
@echo -----------------------  ---------------  ----------------------------------------------------------------------------- >>%_VCPKG_LOG%

rem
@%_VCPKG_TOOL_EXE% search >>%_VCPKG_LOG% 2>>&1

:end-script
@endlocal