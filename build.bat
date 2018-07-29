@echo off

call vars.bat

setlocal

if not exist .\thirdparty\luajit\Makefile (
  call .\prebuild.bat
)

set _PS_LUA_PATH=%~dp0\thirdparty\luajit
set _PS_LUASDL2_PATH=%~dp0\thirdparty\luasdl2
set _PS_CJSON_PATH=%~dp0\thirdparty\lua-cjson
set _PS_LPEG_PATH=%~dp0\modules\lpeg
set _PS_LFS_PATH=%~dp0\modules\lfs
set _PS_ZIP_PATH=%~dp0\modules\zip
set _PS_UUID_PATH=%~dp0\modules\uuid
set _PS_BEEP_PATH=%~dp0\modules\beep
set _PS_TERM_PATH=%~dp0\modules\term
set _PS_RUNTIME_PATH=%~dp0\runtime

call:Print "Building LuaJIT"
  %_MAKE% --directory=%_PS_LUA_PATH% -j%_MAKE_PARALLEL% >nul 2>&1

call:Print "Building LPeg"
  %_CC% %_CFLAGS% -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_LPEG_PATH%\lpeg.dll %_PS_LPEG_PATH%\*.c -llua51 >nul 2>&1

call:Print "Building LuaFileSystem"
  %_CC% %_CFLAGS% -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_LFS_PATH%\lfs.dll %_PS_LFS_PATH%\*.c -llua51 >nul 2>&1

call:Print "Building beep module"
  %_CC% %_CFLAGS% -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_BEEP_PATH%\beep.dll %_PS_BEEP_PATH%\*.c -llua51 >nul 2>&1

call:Print "Building UUID module"
  %_CC% %_CFLAGS% -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_UUID_PATH%\uuid.dll %_PS_UUID_PATH%\*.c -llua51 -lole32 >nul 2>&1

call:Print "Building ZIP module"
  %_CC% %_CFLAGS% -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_ZIP_PATH%\zip.dll %_PS_ZIP_PATH%\*.c -llua51 -lzip >nul 2>&1

call:Print "Building terminal supplementary module"
  %_CC% %_CFLAGS% -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_TERM_PATH%\term.dll %_PS_TERM_PATH%\*.c -llua51 >nul 2>&1

call:Print "Building Lua CJSON"
  %_CC% %_CFLAGS% -shared -s -I%_PS_LUA_PATH%\src -L%_PS_LUA_PATH%\src -L. -o %_PS_CJSON_PATH%\cjson.dll %_PS_CJSON_PATH%\*.c -llua51 >nul 2>&1

call:Print "Building SDL2"
  rmdir /s /q %_PS_LUASDL2_PATH%\build >nul 2>&1
  mkdir %_PS_LUASDL2_PATH%\build >nul 2>&1
  
  set SDLDIR=%~dp0\thirdparty\SDL_binaries
  set SDLTTFDIR=%~dp0\thirdparty\SDL_binaries
  set SDLIMAGEDIR=%~dp0\thirdparty\SDL_binaries
  
  set SDL_INCLUDE_DIR=%~dp0\thirdparty\SDL\include
  set SDL_IMAGE_INCLUDE_DIR=%~dp0\thirdparty\SDL2_image-2.0.3
  set SDL_TTF_INCLUDE_DIR=%~dp0\thirdparty\SDL2_ttf-2.0.14
  
  pushd %_PS_LUASDL2_PATH%\build
  %_CMAKE% .. -G "MinGW Makefiles" -DWITH_MIXER=Off -DWITH_NET=Off -DWITH_DOCS=Off -DWITH_TTF=On -DWITH_IMAGE=On -DWITH_LUAVER=JIT -DSDL2_INCLUDE_DIR=%SDL_INCLUDE_DIR% -DSDL2_IMAGE_INCLUDE_DIR=%SDL_IMAGE_INCLUDE_DIR% -DSDL2_TTF_INCLUDE_DIR=%SDL_TTF_INCLUDE_DIR%
  popd
  %_MAKE% --directory=%_PS_LUASDL2_PATH%\build -j%_MAKE_PARALLEL%

call:Print "Finalizing"
  rd /s /q %_PS_RUNTIME_PATH% >nul 2>&1
  mkdir %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LUA_PATH%\src\luajit.exe %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LUA_PATH%\src\lua51.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LPEG_PATH%\lpeg.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LFS_PATH%\lfs.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_UUID_PATH%\uuid.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_CJSON_PATH%\cjson.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_ZIP_PATH%\zip.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_TERM_PATH%\term.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_BEEP_PATH%\beep.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LUASDL2_PATH%\build\SDL.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LUASDL2_PATH%\build\sdl-image\image.dll %_PS_RUNTIME_PATH% >nul 2>&1
  move %_PS_LUASDL2_PATH%\build\sdl-ttf\ttf.dll %_PS_RUNTIME_PATH% >nul 2>&1
  copy %_PS_LUASDL2_PATH%\..\SDL_binaries\*.dll %_PS_RUNTIME_PATH% >nul 2>&1
  echo .\luajit.exe ..\control.lua ..\vm\vm.moon >> %_PS_RUNTIME_PATH%\launch.bat

call:Print "Cleaning"
  del /f /s /q  %_PS_LUA_PATH%\*.o %_PS_LUA_PATH%\*.a %_PS_LUA_PATH%\*.dll %_PS_LUA_PATH%\*.exe >nul 2>&1

:Print
title %~1, please wait...
echo | set /p=%~1
echo.
exit /b

endlocal
