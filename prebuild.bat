@echo off

call vars.bat

setlocal

set ROOT=.\thirdparty

call:PreProcess
call:Clone luajit https://github.com/LuaJIT/LuaJIT
call:Clone moonscript https://github.com/leafo/moonscript
call:Clone argparse https://github.com/mpeterv/argparse
call:Clone lua-cjson https://github.com/mpx/lua-cjson
call:Clone SDL https://github.com/spurious/SDL-mirror
call:Clone luasdl2 https://github.com/Tangent128/luasdl2
call:FetchSDL2
call:PostProcess

:Clone
  echo | set /p=Cloning %~1 from %~2...
  echo.
  mkdir %ROOT%\%~1
  git clone %~2 %ROOT%\%~1 --depth=1
  exit /b

:PreProcess
  mkdir %ROOT%
  exit /b

:PostProcess
  move %ROOT%\argparse\src\argparse.lua %ROOT%\argparse\
  
  del %ROOT%\lua-cjson\dtoa*.*
  del %ROOT%\lua-cjson\g_fmt*.*
  exit /b

:FetchSDL2
  mkdir %ROOT%\SDL_binaries
  curl --output %ROOT%\SDL2_image-2.0.3-win32-x86.zip http://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.3-win32-x86.zip
  curl --output %ROOT%\SDL2_ttf-2.0.14-win32-x86.zip http://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14-win32-x86.zip
  unzip -o %ROOT%\SDL2_image-2.0.3-win32-x86.zip -d %ROOT%\SDL_binaries
  unzip -o %ROOT%\SDL2_ttf-2.0.14-win32-x86.zip -d %ROOT%\SDL_binaries
  
  curl --output %ROOT%\SDL2_image-2.0.3.zip http://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.3.zip
  curl --output %ROOT%\SDL2_ttf-2.0.14.zip http://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.zip
  
  unzip %ROOT%\SDL2_image-2.0.3.zip -d %ROOT%
  unzip %ROOT%\SDL2_ttf-2.0.14.zip -d %ROOT%
  
  exit /b

endlocal
