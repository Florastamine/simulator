@echo off

rem ================================================================================
rem Copyright (C) 2018, Florastamine
rem 
rem This program is free software: you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation, either version 3 of the License, or
rem (at your option) any later version.
rem 
rem This program is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem GNU General Public License for more details.
rem 
rem You should have received a copy of the GNU General Public License
rem along with this program.  If not, see <https://www.gnu.org/licenses/>.
rem ================================================================================

call vars.bat

setlocal

set _PS_LUA_PATH=%~dp0\thirdparty\luajit
set _PS_LUASDL2_PATH=%~dp0\thirdparty\luasdl2
set _PS_CJSON_PATH=%~dp0\thirdparty\lua-cjson
set _PS_LFS_PATH=%~dp0\thirdparty\lfs
set _PS_LPEG_PATH=%~dp0\thirdparty\lpeg
set _PS_ZIP_PATH=%~dp0\modules\zip
set _PS_UUID_PATH=%~dp0\modules\uuid
set _PS_BEEP_PATH=%~dp0\modules\beep
set _PS_TERM_PATH=%~dp0\modules\term
set _PS_RUNTIME_PATH=%~dp0\runtime

call:Print "Cleaning"
  set DEL=del /f /s /q
  
  rem Runtime folder
  rd /s /q %_PS_RUNTIME_PATH% >nul 2>&1
  mkdir %_PS_RUNTIME_PATH% >nul 2>&1
  
  rem SDL2 build tree
  rmdir /s /q %_PS_LUASDL2_PATH%\build >nul 2>&1
  
  rem LuaJIT build tree
  %DEL% %_PS_LUA_PATH%\*.o >nul 2>&1
  %DEL% %_PS_LUA_PATH%\*.a >nul 2>&1
  %DEL% %_PS_LUA_PATH%\*.dll >nul 2>&1
  %DEL% %_PS_LUA_PATH%\*.exe >nul 2>&1
  
  rem Lua code generated from the mc compiler
  for %%p in (glue color combobox cursor icon sync toolbar types) do (
    %DEL% common\winapi\%%p.lua
  )
  
  for %%p in (glue) do (
    %DEL% common\%%p.lua
  )

:Print
title %~1, please wait...
echo | set /p=%~1
echo.
exit /b

endlocal
