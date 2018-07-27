@echo off

setlocal

set _PS_LUA_PATH=%~dp0\thirdparty\luajit
set _PS_LPEG_PATH=%~dp0\modules\lpeg
set _PS_LFS_PATH=%~dp0\modules\lfs
set _PS_UUID_PATH=%~dp0\modules\uuid
set _PS_RUNTIME_PATH=%~dp0\runtime

call:Print "Building LuaJIT"
  mingw32-make --directory=%_PS_LUA_PATH% >nul 2>&1

call:Print "Building LPeg"
  gcc -O2 -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_LPEG_PATH%\lpeg.dll %_PS_LPEG_PATH%\*.c -llua51 >nul 2>&1

call:Print "Building LuaFileSystem"
  gcc -O2 -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_LFS_PATH%\lfs.dll %_PS_LFS_PATH%\*.c -llua51 >nul 2>&1

call:Print "Building UUID module"
  gcc -O2 -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_UUID_PATH%\uuid.dll %_PS_UUID_PATH%\*.c -llua51 >nul 2>&1

call:Print "Finalizing"
  rd /s /q %_PS_RUNTIME_PATH% >nul 2>&1
  mkdir %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LUA_PATH%\src\luajit.exe %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LUA_PATH%\src\lua51.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LPEG_PATH%\lpeg.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LFS_PATH%\lfs.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_UUID_PATH%\uuid.dll %_PS_RUNTIME_PATH% >nul 2>&1
  echo .\luajit.exe ..\control.lua ..\sample.ls >> %_PS_RUNTIME_PATH%\launch.bat

call:Print "Cleaning"
  del /f /s /q  %_PS_LUA_PATH%\*.o %_PS_LUA_PATH%\*.a %_PS_LUA_PATH%\*.dll %_PS_LUA_PATH%\*.exe >nul 2>&1

:Print
title %~1, please wait...
echo | set /p=%~1
echo.
exit /b

endlocal
