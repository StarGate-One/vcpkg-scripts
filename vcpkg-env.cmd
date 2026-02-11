@echo off

@cls

@rem set __VSCMD_ARG_NO_LOGO=1
@for /f "tokens=*" %%g in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.VisualStudio.Workload.NativeDesktop -property installationPath') do (@set _DEV_VS_DIR=%%g)

@if "%_DEV_VS_DIR%" equ "" (
    @echo ERROR: Visual Studio required but not installed - please install
    @goto :end-script
)

@rem C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat %PROCESSOR_ARCHITECTURE%  -vcvars_spectre_libs=spectre
@rem call "%_DEV_VS_DIR%\VC\Auxiliary\Build\vcvarsall.bat" %PROCESSOR_ARCHITECTURE% -vcvars_spectre_libs=spectre

@rem set __VCVARSALL_SPECTRE=spectre

@rem if defined ProgramFiles(x86) (@set _DEV_ARCH=x64) else (@set _DEV_ARCH=x86)

@rem call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -arch=x86 -host_arch=x86
@rem call "%_DEV_VS_DIR%\Common7\Tools\VsDevCmd.bat" -arch=%_DEV_ARCH%

@rem "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
@call "%_DEV_VS_DIR%\VC\Auxiliary\Build\vcvars64.bat"

@set _DEV_ROOT_DRV=D:
@set _DEV_TEMP_DIR=%_DEV_ROOT_DRV%\vcpkg-work
@set _VCPKG_GIT_DIR=%_DEV_ROOT_DRV%\Projects\Git
@set _VCPKG_ROOT_DIR=%_DEV_ROOT_DRV%\vcpkg
@set _VCPKG_TEMP_DIR=%_DEV_TEMP_DIR%
@set _VCPKG_OVERLAY_DIR=%_DEV_ROOT_DRV%\vcpkg-overlays
@set _VCPKG_TOOL_DIR=%_DEV_ROOT_DRV%\vcpkg-tool

@set _VCPKG_ARCHIVES_DIR=%_VCPKG_TEMP_DIR%\archives
@set _VCPKG_BUILDTREES_DIR=%_VCPKG_ROOT_DIR%\buildtrees
@set _VCPKG_DOWNLOADS_DIR=%_VCPKG_ROOT_DIR%\downloads
@set _VCPKG_INSTALLED_DIR=%_VCPKG_ROOT_DIR%\installed
@set _VCPKG_OVERLAY_PORTS=%_VCPKG_OVERLAY_DIR%\ports
@set _VCPKG_OVERLAY_TRIPLETS=%_VCPKG_OVERLAY_DIR%\triplets
@set _VCPKG_PACKAGES_DIR=%_VCPKG_ROOT_DIR%\packages
@set _VCPKG_PORTS_DIR=%_VCPKG_ROOT_DIR%\ports
@set _VCPKG_SCRIPTS_DIR=%_VCPKG_ROOT_DIR%\scripts
@set _VCPKG_TOOL_BUILD_DIR=%_VCPKG_TEMP_DIR%\build
@set _VCPKG_TOOLSRC_DIR=%_VCPKG_ROOT_DIR%\toolsrc
@set _VCPKG_TRIPLETS_DIR=%_VCPKG_ROOT_DIR%\triplets
@set _VCPKG_VERSIONS_DIR=%_VCPKG_ROOT_DIR%\versions

@set _VCPKG_CMAKE_GEN="Visual Studio 18 2026"
@set _VCPKG_PLATFORM_TOOLSET=v145
@set _VCPKG_DISABLE_METRICS_FILE=%_VCPKG_ROOT_DIR%\vcpkg.disable-metrics
@set _VCPKG_EXE=vcpkg.exe
@rem set _VCPKG_TOOL_BUILD_EXE=%_VCPKG_TOOL_BUILD_DIR%\Release\%_VCPKG_EXE%
@rem set _VCPKG_TOOL_EXE=%_VCPKG_ROOT_DIR%\%_VCPKG_EXE%

@set _VCPKG_TOOL_EXE=%_VCPKG_TOOL_BUILD_DIR%\Release\%_VCPKG_EXE%

@set _VCPKG_GIT_LOCAL_OVERLAY_DIR=%_VCPKG_GIT_DIR%\vcpkg-overlays
@set _VCPKG_GIT_LOCAL_OVERLAY_PORTS=%_VCPKG_GIT_LOCAL_OVERLAY_DIR%\ports
@set _VCPKG_GIT_LOCAL_OVERLAY_TRIPLETS=%_VCPKG_GIT_LOCAL_OVERLAY_DIR%\triplets
@set _VCPKG_GIT_LOGS_DIR=%_VCPKG_GIT_DIR%\logs
@set _VCPKG_GIT_SCRIPTS_DIR=%_VCPKG_GIT_DIR%\vcpkg-scripts
@set _VCPKG_PWSH_JSON_FILE=powershell.config.json

@set CMAKE_TOOLCHAIN_FILE=%_VCPKG_SCRIPTS_DIR%\buildsystems\vcpkg.cmake
@set "CMAKE_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN_FILE:\=/%"

@set VCPKG_BINARY_SOURCES=clear;files,%_VCPKG_ARCHIVES_DIR%,readwrite
@set VCPKG_CHAINLOAD_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN_FILE%
@set VCPKG_CMAKE_SYSTEM_NAME=
@set VCPKG_CMAKE_SYSTEM_VERSION=
@set VCPKG_CRT_LINKAGE=dynamic
@set VCPKG_DEFAULT_BINARY_CACHE=%_VCPKG_ARCHIVES_DIR%
@set VCPKG_DEFAULT_HOST_TRIPLET=%VSCMD_ARG_HOST_ARCH%-windows
@set VCPKG_DEFAULT_TRIPLET=%VSCMD_ARG_TGT_ARCH%-windows
@set VCPKG_DEP_INFO_OVERRIDE_VARS=
@set VCPKG_DISABLE_COMPILER_TRACKING=ON
@rem set VCPKG_DISABLE_COMPILER_TRACKING=
@set VCPKG_DISABLE_METRICS=ON
@set VCPKG_DOWNLOADS=%_DEV_ROOT_DRV%\vcpkg-downloads
@set VCPKG_ENV_PASSTHROUGH=
@set VCPKG_ENV_PASSTHROUGH_UNTRACKED=CUDA_PATH;CUDA_PATH_V13_1;CUDA_TOOLKIT_ROOT;CUDA_TOOLKIT_ROOT_DIR;CUDNN_BIN_DIR;CUDNN_INCLUDE_DIR;CUDNN_LIBRARY;CUDNN_PATH;CUDNN_ROOT_DIR;DevDivCodeAnalysisRunType;DOTNET_CLI_TELEMETRY_OPTOUT;DOTNET_TELEMETRY_OPTOUT;MSBUILDPRESERVETOOLTEMPFILES;POWERSHELL_CLI_TELEMETRY_OPTOUT;POWERSHELL_TELEMETRY_OPTOUT;VCPKG_ENV_PASSTHROUGH_UNTRACKED;VSCMD_SKIP_SENDTELEMETRY
@set VCPKG_FEATURE_FLAGS=-binarycaching,-compilertracking,-dependencygraph,-manifests,-registries,-versions
@rem set VCPKG_FEATURE_FLAGS=binarycaching,compilertracking,dependencygraph,manifests,registries,versions
@set VCPKG_FORCE_DOWNLOADED_BINARIES=
@set VCPKG_FORCE_SYSTEM_BINARIES=
@set VCPKG_HOST_TRIPLET=%VSCMD_ARG_HOST_ARCH%-windows
@set VCPKG_INSTALLED_DIR=%_VCPKG_INSTALLED_DIR%
@set VCPKG_KEEP_ENV_VARS=%VCPKG_ENV_PASSTHROUGH_UNTRACKED%
@set VCPKG_LIBRARY_LINKAGE=dynamic
@set VCPKG_LOAD_VCVARS_ENV=
@set /a VCPKG_MAX_CONCURRENCY=%NUMBER_OF_PROCESSORS%/4
@set VCPKG_NO_CI=1
@set VCPKG_NUGET_REPOSITORY=
@set VCPKG_OVERLAY_PORTS=%_VCPKG_OVERLAY_PORTS%
@set VCPKG_OVERLAY_TRIPLETS=%_VCPKG_OVERLAY_TRIPLETS%
@set VCPKG_PLATFORM_TOOLSET=%_VCPKG_PLATFORM_TOOLSET%
@set VCPKG_PLATFORM_TOOLSET_VERSION=
@set VCPKG_ROOT=%_VCPKG_ROOT_DIR%
@set VCPKG_TARGET_ARCHITECTURE=%Platform%
@set VCPKG_TARGET_TRIPLET=%VSCMD_ARG_TGT_ARCH%-windows
@set VCPKG_USE_NUGET_CACHE=
@set VCPKG_VISUAL_STUDIO_PATH=%VSINSTALLDIR:~0,-1%
@set VCPKG_XBOX_CONSOLE_TARGET=
@set X_VCPKG_APPINSTALL_DEPS_INSTALL=ON
@set X_VCPKG_ASSET_SOURCES=clear

@set COPYCMD=/V /Y /Z

@set DevDivCodeAnalysisRunType=Disabled

@set DOTNET_CLI_TELEMETRY_OPTOUT=1
@set DOTNET_TELEMETRY_OPTOUT=1

@rem VS Code is Default Editor for VCPKG
@rem @set EDITOR=C:\Program Files\Microsoft VS Code\Code.exe
@rem @set Editor to Notepad++
@set EDITOR=%NPP_FULL_FILE_PATH%

@set MSBUILDPRESERVETOOLTEMPFILES=0
@set POWERSHELL_CLI_TELEMETRY_OPTOUT=1
@set POWERSHELL_TELEMETRY_OPTOUT=1
@set PSHOME=%_VCPKG_TEMP_DIR%\pshome
@rem set PSModulePath=C:\Program Files\PowerShell\7\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\Program Files (x86)\Microsoft SQL Server\160\Tools\PowerShell\Modules\;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules;%PSHOME%

@set PSModulePath=%PSModulePath%;%PSHOME%

@set PreferredToolArchitecture=%Platform%

@rem set VSCMD_SKIP_SENDTELEMETRY=1

@if not exist %_VCPKG_TEMP_DIR% (
    @mkdir %_VCPKG_TEMP_DIR%
    @timeout /T 5 > nul
)

@if exist %_VCPKG_TEMP_DIR% (
    @if not exist %_VCPKG_TEMP_DIR%\temp (
        @mkdir %_VCPKG_TEMP_DIR%\temp
        @timeout /T 5 > nul
    )
    @set TEMP=%_VCPKG_TEMP_DIR%\temp

rem    @if exist %_VCPKG_TEMP_DIR%\temp (
rem        @forfiles /p %_VCPKG_TEMP_DIR%\temp /s /m TmP* /D -0 /C "cmd /c del @path" > nul 2>&1
        @rem del /f %_VCPKG_TEMP_DIR%\tmp\_CL_* > nul 2>&1
rem        @timeout /T 5 > nul
rem    )
    @if not exist %_VCPKG_TEMP_DIR%\tmp (
        @mkdir %_VCPKG_TEMP_DIR%\tmp
        @timeout /T 5 > nul
    )
    @set TMP=%_VCPKG_TEMP_DIR%\tmp

rem    @if exist %_VCPKG_TEMP_DIR%\tmp (
rem        @forfiles /p %_VCPKG_TEMP_DIR%\tmp /s /m _CL_* /D -0 /C "cmd /c del @path" > nul 2>&1
        @rem del /f %_VCPKG_TEMP_DIR%\tmp\_CL_* > nul 2>&1
rem        @timeout /T 5 > nul
rem     )
)
@rem ) else (
@rem    @set TEMP=%_DEV_TEMP_DIR%
@rem    @set TMP=%_DEV_TEMP_DIR%
@rem )

@set VSCMD_SKIP_SENDTELEMETRY=1

@set XCOPY_CMD=/I /S /V /Y /Z

@set _IsNativeEnvironment=true

@%_DEV_ROOT_DRV%

@if exist %_VCPKG_ROOT_DIR% (
    @cd %_VCPKG_ROOT_DIR%
) else (
    @cd %_DEV_ROOT_DRV%\
)

@rem "C:\Program Files\PowerShell\7\pwsh.exe" -NoLogo -NoExit -NoProfile -ExecutionPolicy Bypass -WorkingDirectory D:\vcpkg
:end-script