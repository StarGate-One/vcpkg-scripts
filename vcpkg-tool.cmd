@echo off
@cls
@setlocal enableextensions enabledelayedexpansion

@set _VCPKG_CMAKE_EXE=EMPTY
@set _VCPKG_GIT_EXE=EMPTY

@rem Find CMake
@rem for /f "tokens=*" %%g in ('where cmake.exe') do (@set _VCPKG_CMAKE_EXE=%%g)
@for /f "tokens=* USEBACKQ" %%g in (`where cmake.exe`) do (
    @set _VCPKG_CMAKE_EXE=%%g
    @if %_VCPKG_CMAKE_EXE% NEQ "EMPTY" (@goto :cont-1)
)

@if "%_VCPKG_CMAKE_EXE%" equ "EMPTY" (
    @echo ERROR: Cmake required but not installed - please install
    @goto :end-script
)

:cont-1
@rem Find Git
@rem for /f "tokens=*" %%g in ('where git.exe') do (@set _VCPKG_GIT_EXE=%%g)
@for /f "tokens=* USEBACKQ" %%g in (`where git.exe`) do (
    @set _VCPKG_GIT_EXE=%%g
    @if %_VCPKG_GIT_EXE% NEQ "EMPTY" (@goto :cont-2)
)
@if "%_VCPKG_GIT_EXE%" equ "EMPTY" (
    @echo ERROR: Git required but not installed - please install
    @goto :end-script
)
:cont-2
@rem set _VCPKG_FMT_URL=https://github.com/fmtlib/fmt/archive/refs/tags/10.2.1.tar.gz
@set _VCPKG_FMT_URL=https://github.com/fmtlib/fmt/archive/refs/tags/11.0.2.tar.gz
@set _VCPKG_CMAKERC_URL=https://github.com/vector-of-bool/cmrc/archive/refs/tags/2.0.1.tar.gz

@call %_VCPKG_GIT_SCRIPTS_DIR%\date-time.cmd

@set _VCPKG_TOOL_CE_SHA=EMPTY
@set _VCPKG_TOOL_LATEST_TAG_REFNAME_DATE=EMPTY

@for /f "tokens=*" %%g in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.VisualStudio.Workload.NativeDesktop -property catalog_productName') do (@set _DEV_VS_PROPERTY_NAME=%%g)

@for /f "tokens=*" %%g in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.VisualStudio.Workload.NativeDesktop -property catalog_productLine') do (@set _DEV_VS_PROPERTY_LINE=%%g)

@set "_DEV_VS_PROPERTY_LINE=%_DEV_VS_PROPERTY_LINE:Dev=%

@for /f "tokens=*" %%g in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.VisualStudio.Workload.NativeDesktop -property catalog_productLineVersion') do (@set _DEV_VS_PROPERTY_LINE_VERSION=%%g)

@rem set _VCPKG_CMAKE_GEN="%_DEV_VS_PROPERTY_NAME% %_DEV_VS_PROPERTY_LINE% %_DEV_VS_PROPERTY_LINE_VERSION%"

@set _VCPKG_GIT_FORMAT="--format=%%cd"
@set _VCPKG_GIT_DATE_FORMAT="--date=format-local:%%Y-%%m-%%d"
@set TZ=UTC

@%_DEV_ROOT_DRV%
@cd %_DEV_ROOT_DRV%\

@cd %_VCPKG_TOOL_DIR%

@rem set _vcpkg-tool_ce_sha equal to sha on HEAD
@for /f "tokens=* USEBACKQ" %%g in (`"%_VCPKG_GIT_EXE%" rev-parse HEAD`) do (
    @set _VCPKG_TOOL_CE_SHA=%%g
    @if %_VCPKG_TOOL_CE_SHA% NEQ "EMPTY" (@goto :next-1)
)

:next-1
@rem get date of last commit in CCYY-MM-DD format UTC Timezone
@rem for /f "tokens=* USEBACKQ" %%g in (`'"%_VCPKG_GIT_EXE%" show --quiet HEAD %_VCPKG_GIT_FORMAT% %_VCPKG_GIT_DATE_FORMAT%'`) do (
@for /f "tokens=* USEBACKQ" %%g in (`git show --quiet HEAD %_VCPKG_GIT_FORMAT% %_VCPKG_GIT_DATE_FORMAT%`) do (
     @set _VCPKG_TOOL_LATEST_TAG_REFNAME_DATE=%%g
     @if %_VCPKG_TOOL_LATEST_TAG_REFNAME_DATE% NEQ "EMPTY" (@goto :next-2)
)
@rem get all tags and sort in reverse commit date order
@rem for /f "tokens=* USEBACKQ" %%g in (`"%_VCPKG_GIT_EXE%" tag --sort=-committerdate`) do (
     @rem set _vcpkg-tool_latest_tag-refname-date=%%g
     @rem if %_vcpkg-tool_latest_tag-refname-date% NEQ "EMPTY" (
         @rem goto next-2
     @rem ) 
@rem )

:next-2
@rem set to a legal date format if not done above 
@if %_VCPKG_TOOL_LATEST_TAG_REFNAME_DATE% == "EMPTY" (
    @set _VCPKG_TOOL_LATEST_TAG_REFNAME_DATE=%file_current-date%
)

@if exist %_VCPKG_TOOL_BUILD_DIR% (
    @rmdir /q /s %_VCPKG_TOOL_BUILD_DIR%
    @timeout /T 5 > nul
)

@if not exist %_VCPKG_TOOL_BUILD_DIR% (@mkdir %_VCPKG_TOOL_BUILD_DIR%)

@rem Build the vcpkg.exe source code
@"%_VCPKG_CMAKE_EXE%"                                           ^
   -A %VSCMD_ARG_TGT_ARCH%                                      ^
   -B "%_VCPKG_TOOL_BUILD_DIR%"                                 ^
   -S %_VCPKG_TOOL_DIR%                                         ^
   -G %_VCPKG_CMAKE_GEN%                                        ^
   -T %_VCPKG_PLATFORM_TOOLSET%                                 ^
   -DBUILD_TESTING=OFF                                          ^
   -DBUILD_TESTS=OFF                                            ^
   -DCMAKE_BUILD_TYPE=Release                                   ^
   -DCMAKE_VERBOSE_MAKEFILE=ON                                  ^
   -DCMAKE_INSTALL_PREFIX:PATH=%_VCPKG_ROOT_DIR%                ^
   -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded                   ^
   -DVCPKG_ARTIFACTS_DEVELOPMENT="OFF"                          ^
  "-DVCPKG_ARTIFACTS_SHA=%_VCPKG_TOOL_CE_SHA%"                  ^
  "-DVCPKG_BASE_VERSION=%_VCPKG_TOOL_LATEST_TAG_REFNAME_DATE%"  ^
   -DVCPKG_BUILD_FUZZING=OFF                                    ^
   -DVCPKG_BUILD_TLS12_DOWNLOADER=OFF                           ^
  "-DVCPKG_CMAKERC_URL=%_VCPKG_CMAKERC_URL%"                    ^
   -DVCPKG_DEVELOPMENT_WARNINGS=ON                              ^
   -DVCPKG_EMBED_GIT_SHA=ON                                     ^
  "-DVCPKG_FMT_URL=%_VCPKG_FMT_URL%"                            ^
   -DVCPKG_MSVC_ANALYZE=OFF                                     ^
   -DVCPKG_OFFICIAL_BUILD=ON                                    ^
  "-DVCPKG_STANDALONE_BUNDLE_SHA=%_VCPKG_TOOL_CE_SHA%"          ^
   -DVCPKG_VERSION=%_VCPKG_TOOL_CE_SHA%                         ^
   -DVCPKG_WARNINGS_AS_ERRORS=ON

@rem goto :end-script

@rem Compile/Link vcpkg.exe
@"%_VCPKG_CMAKE_EXE%"                 ^
   --build %_VCPKG_TOOL_BUILD_DIR%    ^
   --clean-first                      ^
   --config release                   ^
   --parallel %VCPKG_MAX_CONCURRENCY% ^
   --target vcpkg                     ^
   --verbose

@if exist %_VCPKG_TOOL_BUILD_EXE% (
    @rem vcpkg dynamic
    @if exist %_VCPKG_TOOL_EXE% (
        @rem %_VCPKG_TOOL_EXE% integrate remove --binarysource=%VCPKG_BINARY_SOURCES% --downloads-root=%_VCPKG_DOWNLOADS_DIR% --host-triplet=%VCPKG_DEFAULT_HOST_TRIPLET% --overlay-ports=%_VCPKG_OVERLAY_PORTS% --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --triplet=%VCPKG_DEFAULT_TRIPLET% --vcpkg-root=%_VCPKG_ROOT_DIR% --x-asset-sources=%X_VCPKG_ASSET_SOURCES% --x-buildtrees-root=%_VCPKG_BUILDTREES_DIR% --x-install-root=%_VCPKG_INSTALLED_DIR% 
        @%_VCPKG_TOOL_EXE% integrate remove --downloads-root=%_VCPKG_DOWNLOADS_DIR% --host-triplet=%VCPKG_DEFAULT_HOST_TRIPLET% --overlay-ports=%_VCPKG_OVERLAY_PORTS% --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --triplet=%VCPKG_DEFAULT_TRIPLET% --vcpkg-root=%_VCPKG_ROOT_DIR% --x-asset-sources=%X_VCPKG_ASSET_SOURCES% --x-buildtrees-root=%_VCPKG_BUILDTREES_DIR% --x-install-root=%_VCPKG_INSTALLED_DIR% 
        @rem del /F /Q %_VCPKG_TOOL_EXE%
        @timeout /T 5 > nul
    )
    @rem copy %_VCPKG_TOOL_BUILD_EXE% %_VCPKG_TOOL_EXE%
    @rem timeout /T 5 > nul
    @rem cd %_VCPKG_ROOT_DIR%
    %_VCPKG_TOOL_EXE% version
    @if not exist %_VCPKG_DISABLE_METRICS_FILE% (
        @echo. 1>%_VCPKG_DISABLE_METRICS_FILE% 2>&1
    )
    @rem %_VCPKG_TOOL_EXE% integrate install --binarysource=%VCPKG_BINARY_SOURCES% --downloads-root=%_VCPKG_DOWNLOADS_DIR% --host-triplet=%VCPKG_DEFAULT_HOST_TRIPLET% --overlay-ports=%_VCPKG_OVERLAY_PORTS% --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --triplet=%VCPKG_DEFAULT_TRIPLET% --vcpkg-root=%_VCPKG_ROOT_DIR% --x-asset-sources=%X_VCPKG_ASSET_SOURCES% --x-buildtrees-root=%_VCPKG_BUILDTREES_DIR% --x-install-root=%_VCPKG_INSTALLED_DIR%

    @%_VCPKG_TOOL_EXE% integrate install --downloads-root=%_VCPKG_DOWNLOADS_DIR% --host-triplet=%VCPKG_DEFAULT_HOST_TRIPLET% --overlay-ports=%_VCPKG_OVERLAY_PORTS% --overlay-triplets=%_VCPKG_OVERLAY_TRIPLETS% --triplet=%VCPKG_DEFAULT_TRIPLET% --vcpkg-root=%_VCPKG_ROOT_DIR% --x-asset-sources=%X_VCPKG_ASSET_SOURCES% --x-buildtrees-root=%_VCPKG_BUILDTREES_DIR% --x-install-root=%_VCPKG_INSTALLED_DIR%
)

:end-script
@endlocal