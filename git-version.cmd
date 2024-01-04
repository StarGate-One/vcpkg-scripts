@echo off 
@rem parse the GIT --VERSION output
for /f "tokens=3*" %%g in ('git --version') do set _git_version=%%g 
@rem echo %_git_version%
for /f "tokens=1*" %%h in ("%_git_version%") do set _git_version=%%h
rem echo %_git_version%Hello