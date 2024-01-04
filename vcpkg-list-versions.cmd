@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\date-time.cmd
@echo Date: %file-current-date%                                                                                            Time: %file-current-time% >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\cmake-version.cmd
@echo CMake Version [%_cmake_version%] >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\git-version.cmd
@echo Git Version [%_git_version%] >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\ninja-version.cmd
@echo Ninja Version [%_ninja_version%] >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\vcpkg-version.cmd
@echo Vcpkg Version [%_vcpkg_version%] >>%_VCPKG_LOG% 2>>&1
@call %_VCPKG_GIT_SCRIPTS_DIR%\vcpkg-scripts-version.cmd
@echo Vcpkg Scripts Version [%_VCPKG_SCRIPTS_VERSION%] >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\cpp-version.cmd
@echo %_vs_version% Version: [%VSCMD_VER%]  VS Tools Version: [%VCToolsVersion%] >>%_VCPKG_LOG% 2>>&1
@echo Microsoft (R) C/C++ Optimizing Compiler Version [%_cpp_version%] for %VSCMD_ARG_TGT_ARCH% >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\vswhere-version.cmd
@echo Visual Studio Locator (vswhere) Version [%_vswhere_version_1%] query version [%_vswhere_version_2%] >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\windows-version.cmd
@echo Windows Version [%_windows_version%] >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%

@call %_VCPKG_GIT_SCRIPTS_DIR%\winsdk-version.cmd
@echo Windows SDK Version [%_winsdk_version%] >>%_VCPKG_LOG% 2>>&1
@echo. >>%_VCPKG_LOG%