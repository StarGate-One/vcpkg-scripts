@echo off
@set _VCPKG_GIT_FORMAT="--format=%%cd"
@set _VCPKG_GIT_DATE_FORMAT="--date=format-local:%%Y-%%m-%%d"
@set TZ=UTC
@set _VCPKG_LAST_SHA=EMPTY
@set _VCPKG_LATEST_TAG_REFNAME_DATE=EMPTY

@%_DEV_ROOT_DRV%
@cd %_DEV_ROOT_DRV%\

@cd %_VCPKG_ROOT_DIR%

@rem set _vcpkg_sha equal to sha on HEAD
@for /f "tokens=* USEBACKQ" %%g in (`git rev-parse HEAD`) do (
    @set _VCPKG_LAST_SHA=%%g
    @if %_VCPKG_LAST_SHA% NEQ "EMPTY" (@goto :next-1)
)

:next-1
@rem get date of last commit in CCYY-MM-DD format UTC Timezone
@rem for /f "tokens=* USEBACKQ" %%g in (`'"%_VCPKG_GIT_EXE%" show --quiet HEAD %_VCPKG_GIT_FORMAT% %_VCPKG_GIT_DATE_FORMAT%'`) do (
@for /f "tokens=* USEBACKQ" %%g in (`git show --quiet HEAD %_VCPKG_GIT_FORMAT% %_VCPKG_GIT_DATE_FORMAT%`) do (
     @set _VCPKG_LATEST_TAG_REFNAME_DATE=%%g
     @if %_VCPKG_LATEST_TAG_REFNAME_DATE% NEQ "EMPTY" (@goto :next-2)
)

:next-2
@set _VCPKG_SCRIPTS_VERSION=%_VCPKG_LATEST_TAG_REFNAME_DATE%-%_VCPKG_LAST_SHA%