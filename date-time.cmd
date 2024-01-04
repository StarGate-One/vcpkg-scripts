@echo off
@rem assumes %date% mm/dd/ccyy
set file-current-date=%date:~-4%-%date:~0,2%-%date:~3,2%

@rem assume %time% hh:mm:ss.tt
set file-current-time=%time%
if "%file-current-time:~0,1%" == " " (
set file-current-time=0%file-current-time:~1,1%:%file-current-time:~3,2%
) else (
set file-current-time=%file-current-time:~0,2%:%file-current-time:~3,2%
)

@rem echo.
@rem echo %file-current-date%-%file-current-time% 
@rem echo.