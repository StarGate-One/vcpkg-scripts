@setlocal enableextensions enabledelayedexpansion

@set _vcpkg_debug_dir=D:\Projects\Git\_vcpkg\Debug
@set _vcpkg_release_dir=D:\Projects\Git\_vcpkg\Release

@set _vcpkg_installed_rel_dir=D:\vcpkg\installed\x64-windows
@set _vcpkg_installed_dbg_dir=%_vcpkg_installed_rel_dir%\debug

@set _vcpkg_release_bin=%_vcpkg_release_dir%\bin
@set _vcpkg_release_etc=%_vcpkg_release_dir%\etc
@set _vcpkg_release_include=%_vcpkg_release_dir%\include
@set _vcpkg_release_lib=%_vcpkg_release_dir%\lib
@set _vcpkg_release_media=%_vcpkg_release_dir%\media
@set _vcpkg_release_share=%_vcpkg_release_dir%\share
@set _vcpkg_release_tools=%_vcpkg_release_dir%\tools

@set _vcpkg_rel_bin=%_vcpkg_installed_rel_dir%\bin
@set _vcpkg_rel_etc=%_vcpkg_installed_rel_dir%\etc
@set _vcpkg_rel_include=%_vcpkg_installed_rel_dir%\include
@set _vcpkg_rel_lib=%_vcpkg_installed_rel_dir%\lib
@set _vcpkg_rel_media=%_vcpkg_installed_rel_dir%\media
@set _vcpkg_rel_share=%_vcpkg_installed_rel_dir%\share
@set _vcpkg_rel_tools=%_vcpkg_installed_rel_dir%\tools

@set _vcpkg_debug_bin=%_vcpkg_debug_dir%\bin
@set _vcpkg_debug_etc=%_vcpkg_debug_dir%\etc
@set _vcpkg_debug_include=%_vcpkg_debug_dir%\include
@set _vcpkg_debug_lib=%_vcpkg_debug_dir%\lib
@set _vcpkg_debug_media=%_vcpkg_debug_dir%\media
@set _vcpkg_debug_share=%_vcpkg_debug_dir%\share
@set _vcpkg_debug_tools=%_vcpkg_debug_dir%\tools

@set _vcpkg_dbg_bin=%_vcpkg_installed_dbg_dir%\bin
@set _vcpkg_dbg_etc=%_vcpkg_installed_dbg_dir%\etc
@set _vcpkg_dbg_include=%_vcpkg_rel_include%
@set _vcpkg_dbg_lib=%_vcpkg_installed_dbg_dir%\lib
@set _vcpkg_dbg_media=%_vcpkg_installed_dbg_dir%\media
@set _vcpkg_dbg_share=%_vcpkg_rel_share%
@set _vcpkg_dbg_tools=%_vcpkg_installed_dbg_dir%\tools

@rem goto end

@rem Release
@if not exist %_vcpkg_release_bin% (
    @mklink /j %_vcpkg_release_bin% %_vcpkg_rel_bin%
)

@if not exist %_vcpkg_release_etc% (
    @mklink /j %_vcpkg_release_etc% %_vcpkg_rel_etc%
)

@if not exist %_vcpkg_release_include% (
    @mklink /j %_vcpkg_release_include% %_vcpkg_rel_include%
)

@if not exist %_vcpkg_release_lib% (
    @mklink /j %_vcpkg_release_lib% %_vcpkg_rel_lib%
)

@if not exist %_vcpkg_release_media% (
    @mklink /j %_vcpkg_release_media% %_vcpkg_rel_media%
)

@if not exist %_vcpkg_release_share% (
    @mklink /j %_vcpkg_release_share% %_vcpkg_rel_share%
)

@if not exist %_vcpkg_release_tools% (
    @mklink /j %_vcpkg_release_tools% %_vcpkg_rel_tools%
)

@rem Debug
@if not exist %_vcpkg_debug_bin% (
    @mklink /j %_vcpkg_debug_bin% %_vcpkg_dbg_bin%
)

@if not exist %_vcpkg_debug_etc% (
    @mklink /j %_vcpkg_debug_etc% %_vcpkg_dbg_etc%
)

@if not exist %_vcpkg_debug_include% (
    @mklink /j %_vcpkg_debug_include% %_vcpkg_dbg_include%
)

@if not exist %_vcpkg_debug_lib% (
    @mklink /j %_vcpkg_debug_lib% %_vcpkg_dbg_lib%
)

@if not exist %_vcpkg_debug_media% (
    @mklink /j %_vcpkg_debug_media% %_vcpkg_dbg_media%
)

@if not exist %_vcpkg_debug_share% (
    @mklink /j %_vcpkg_debug_share% %_vcpkg_dbg_share%
)

@if not exist %_vcpkg_debug_tools% (
    @mklink /j %_vcpkg_debug_tools% %_vcpkg_dbg_tools%
)

:end
@endlocal

