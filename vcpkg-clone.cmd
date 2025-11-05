@echo off
@cls
@setlocal enableextensions enabledelayedexpansion

@%_DEV_ROOT_DRV%
@cd %_DEV_ROOT_DRV%\

@rem Find Git
@for /f "tokens=*" %%g in ('where git.exe') do (@set _VCPKG_GIT_EXE=%%g)

@if "%_VCPKG_GIT_EXE%" equ "" (
    @echo ERROR: Git required but not installed - please install
    @goto :end-script
)

@rem Find icacls
@for /f "tokens=*" %%g in ('where icacls.exe') do (@set _VCPKG_ICACLS_EXE=%%g)

@if "%_VCPKG_ICACLS_EXE%" equ "" (
    @echo ERROR: Icacls required but not installed - please install
    @goto :end-script
)

@rem set ICACLS_CMD=/grant everyone:(OI)(CI)(F) /C /Q /T
@set ICACLS_CMD_1=/grant everyone:(OI)(CI)(F) /C /Q
@set ICACLS_CMD_2=/grant %USERNAME%:(OI)(CI)(F) /C /Q

@rem Find xcopy
@for /f "tokens=*" %%g in ('where xcopy.exe') do (@set _VCPKG_XCOPY_EXE=%%g)

@if "%_VCPKG_XCOPY_EXE%" equ "" (
    @echo ERROR: Xcopy required but not installed - please install
    @goto :end-script
)

@rem vcpkg temp directory
@if exist %_VCPKG_TEMP_DIR% (
    @rmdir /q /s %_VCPKG_TEMP_DIR%
    @timeout /T 5 > nul
)
@if not exist %_VCPKG_TEMP_DIR% (@mkdir %_VCPKG_TEMP_DIR%)

@if not exist %_VCPKG_ARCHIVES_DIR% (@mkdir %_VCPKG_ARCHIVES_DIR%)
@if not exist %_VCPKG_TEMP_DIR%\temp (@mkdir %_VCPKG_TEMP_DIR%\temp)
@if not exist %_VCPKG_TEMP_DIR%\tmp (@mkdir %_VCPKG_TEMP_DIR%\tmp)
@if not exist %_VCPKG_TOOL_BUILD_DIR% (@mkdir %_VCPKG_TOOL_BUILD_DIR%)
@if not exist %PSHOME% (@mkdir %PSHOME%)
@set TEMP=%_VCPKG_TEMP_DIR%\temp
@set TMP=%_VCPKG_TEMP_DIR%\tmp

@if not exist %PSHOME%\%_VCPKG_PWSH_JSON_FILE% (
    @if exist %PSHOME% (
        @if exist %_VCPKG_GIT_SCRIPTS_DIR%\%_VCPKG_PWSH_JSON_FILE% (
            @copy %_VCPKG_GIT_SCRIPTS_DIR%\%_VCPKG_PWSH_JSON_FILE% %PSHOME%\%_VCPKG_PWSH_JSON_FILE%
        )
    )
)

@"%_VCPKG_ICACLS_EXE%" %_VCPKG_TEMP_DIR% %ICACLS_CMD_1%
@"%_VCPKG_ICACLS_EXE%" %_VCPKG_TEMP_DIR% %ICACLS_CMD_2%

@rem physical downloads directory
@if not exist %VCPKG_DOWNLOADS% (@mkdir %VCPKG_DOWNLOADS%)
@"%_VCPKG_ICACLS_EXE%" %VCPKG_DOWNLOADS% %ICACLS_CMD_1%
@"%_VCPKG_ICACLS_EXE%" %VCPKG_DOWNLOADS% %ICACLS_CMD_2%

@rem vcpkg repo
@set _VCPKG_GIT_REPO=vcpkg
@set _VCPKG_GIT_BRANCH=master
@set _VCPKG_GIT_CLONE=clone -b %_VCPKG_GIT_BRANCH% -c core.symlinks=false -j%VCPKG_MAX_CONCURRENCY% --verbose --progress --recurse-submodules --single-branch git@github.com:StarGate-One
@set _VCPKG_GIT_REMOTE_ADD=remote add upstream git@github.com:microsoft
@set _VCPKG_GIT_PULL=pull upstream %_VCPKG_GIT_BRANCH% -a -f
@set _VCPKG_GIT_PUSH=push --all -f

@if exist %_VCPKG_ROOT_DIR% (
    @rmdir /q /s %_VCPKG_ROOT_DIR%
    @timeout /T 5 > nul
)

@if not exist %_VCPKG_ROOT_DIR% (
    @"%_VCPKG_GIT_EXE%" %_VCPKG_GIT_CLONE%/%_VCPKG_GIT_REPO%.git %_VCPKG_ROOT_DIR%
) else (
    @echo ERROR: Git %_VCPKG_GIT_REPO% exists - cannot clone over existing repo - please investigate
    @goto :end-script
)

@if not exist %_VCPKG_ROOT_DIR% (
    @echo ERROR: Git %_VCPKG_GIT_REPO% required but does not exist - please investigate
    @goto :end-script
)

@cd %_VCPKG_ROOT_DIR%

@"%_VCPKG_GIT_EXE%" %_VCPKG_GIT_REMOTE_ADD%/%_VCPKG_GIT_REPO%.git

@"%_VCPKG_GIT_EXE%" %_VCPKG_GIT_PULL%

@"%_VCPKG_GIT_EXE%" %_VCPKG_GIT_PUSH%

@if not exist %_VCPKG_DISABLE_METRICS_FILE% (
   @echo. >%_VCPKG_DISABLE_METRICS_FILE%
)

@if not exist %_VCPKG_BUILDTREES_DIR% (
    @mkdir %_VCPKG_BUILDTREES_DIR%
)

@rem if not exist %_VCPKG_DOWNLOADS_DIR% (
   @rem if exist %VCPKG_DOWNLOADS% (
   @rem mklink /j %_VCPKG_DOWNLOADS_DIR% %VCPKG_DOWNLOADS%
   @rem )
@rem )

@if not exist %_VCPKG_INSTALLED_DIR% (
   @mkdir %_VCPKG_INSTALLED_DIR%
)

@if not exist %_VCPKG_PACKAGES_DIR% (
   @mkdir %_VCPKG_PACKAGES_DIR%
)

@if exist %_VCPKG_GIT_LOCAL_OVERLAY_DIR% (
    @if exist %_VCPKG_OVERLAY_DIR% (
        @rmdir /q /s %_VCPKG_OVERLAY_DIR%
        @timeout /T 5 > nul
        @mkdir %_VCPKG_OVERLAY_DIR%
        @timeout /T 5 > nul
    )
    @if not exist %_VCPKG_OVERLAY_PORTS% (
        @mkdir %_VCPKG_OVERLAY_PORTS%
        @timeout /T 5 > nul
    )
    @"%_VCPKG_XCOPY_EXE%" %_VCPKG_GIT_LOCAL_OVERLAY_PORTS% %_VCPKG_OVERLAY_PORTS% %XCOPY_CMD%
    @if not exist %_VCPKG_OVERLAY_TRIPLETS% (
        @mkdir %_VCPKG_OVERLAY_TRIPLETS%
        @timeout /T 5 > nul
    )
    @"%_VCPKG_XCOPY_EXE%" %_VCPKG_GIT_LOCAL_OVERLAY_TRIPLETS% %_VCPKG_OVERLAY_TRIPLETS% %XCOPY_CMD%
)

@cd %_DEV_ROOT_DRV%\

@"%_VCPKG_ICACLS_EXE%" %_VCPKG_ROOT_DIR% %ICACLS_CMD_1%
@"%_VCPKG_ICACLS_EXE%" %_VCPKG_OVERLAY_DIR% %ICACLS_CMD_1%

@"%_VCPKG_ICACLS_EXE%" %_VCPKG_ROOT_DIR% %ICACLS_CMD_2%
@"%_VCPKG_ICACLS_EXE%" %_VCPKG_OVERLAY_DIR% %ICACLS_CMD_2%

@rem vcpkg-tool repo
@set _VCPKG_GIT_REPO=vcpkg-tool
@set _VCPKG_GIT_BRANCH=main
@set _VCPKG_GIT_CLONE=clone -b %_VCPKG_GIT_BRANCH% -c core.symlinks=false -j%VCPKG_MAX_CONCURRENCY% --verbose --progress --recurse-submodules --single-branch git@github.com:StarGate-One
@set _VCPKG_GIT_PULL=pull upstream %_VCPKG_GIT_BRANCH% -a -f

@if exist %_VCPKG_TOOL_DIR% (
    @rmdir /q /s %_VCPKG_TOOL_DIR%
    @timeout /T 5 > nul
)

@if not exist %_VCPKG_TOOL_DIR% (
    @"%_VCPKG_GIT_EXE%" %_VCPKG_GIT_CLONE%/%_VCPKG_GIT_REPO%.git %_VCPKG_TOOL_DIR%
) else (
    @echo ERROR: Git %_VCPKG_GIT_REPO% exists - cannot clone over existing repo - please investigate
    @goto :end-script
)

@if not exist %_VCPKG_TOOL_DIR% (
    @echo ERROR: Git %_VCPKG_GIT_REPO% required but does not exist - please investigate
    @goto :end-script
)

@cd %_VCPKG_TOOL_DIR%

@"%_VCPKG_GIT_EXE%" %_VCPKG_GIT_REMOTE_ADD%/%_VCPKG_GIT_REPO%.git

@"%_VCPKG_GIT_EXE%" %_VCPKG_GIT_PULL%

@"%_VCPKG_GIT_EXE%" %_VCPKG_GIT_PUSH%

@cd %_DEV_ROOT_DRV%\

@"%_VCPKG_ICACLS_EXE%" %_VCPKG_TOOL_DIR% %ICACLS_CMD_1%
@"%_VCPKG_ICACLS_EXE%" %_VCPKG_TOOL_DIR% %ICACLS_CMD_2%

:end-script
@endlocal