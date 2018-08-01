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

set ROOT=.\thirdparty

call:PreProcess
call:Clone luajit http://github.com/LuaJIT/LuaJIT
call:Clone moonscript http://github.com/leafo/moonscript
call:Clone argparse http://github.com/mpeterv/argparse
call:Clone lpeg http://github.com/Florastamine/LPeg-mirror
call:Clone lfs http://github.com/keplerproject/luafilesystem
call:Clone lua-cjson http://github.com/mpx/lua-cjson
call:Clone pdcurses https://github.com/wmcbrine/PDCurses
call:Clone SDL http://github.com/spurious/SDL-mirror
call:Clone luasdl2 http://github.com/Tangent128/luasdl2
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
  
  move %ROOT%\lfs\src\lfs.* %ROOT%\lfs\
  
  del %ROOT%\lua-cjson\dtoa*.*
  del %ROOT%\lua-cjson\g_fmt*.*
  
  move %ROOT%\luasdl2\README.md %ROOT%\luasdl2\README
  
  copy .\patches\CMakeLists_SDL.patch %ROOT%\luasdl2\
  pushd %ROOT%\luasdl2\
  patch CMakeLists.txt CMakeLists_SDL.patch
  popd
  
  copy .\patches\CMakeLists_SDL_image.patch %ROOT%\luasdl2\sdl-image
  pushd %ROOT%\luasdl2\sdl-image
  patch CMakeLists.txt CMakeLists_SDL_image.patch
  popd
  
  copy .\patches\CMakeLists_SDL_ttf.patch %ROOT%\luasdl2\sdl-ttf
  pushd %ROOT%\luasdl2\sdl-ttf
  patch CMakeLists.txt CMakeLists_SDL_ttf.patch
  popd
  
  exit /b

:FetchSDL2
  mkdir %ROOT%\SDL_binaries
  
  if not exist %ROOT%\SDL2_image-2.0.3-win32-x86.zip (
    curl --output %ROOT%\SDL2_image-2.0.3-win32-x86.zip http://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.3-win32-x86.zip
  )
  
  if not exist %ROOT%\SDL2_ttf-2.0.14-win32-x86.zip (
    curl --output %ROOT%\SDL2_ttf-2.0.14-win32-x86.zip http://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14-win32-x86.zip
  )
  
  if not exist %ROOT%\SDL2-2.0.8-win32-x86.zip (
    curl --output %ROOT%\SDL2-2.0.8-win32-x86.zip http://www.libsdl.org/release/SDL2-2.0.8-win32-x86.zip
  )
  
  unzip -o %ROOT%\SDL2_image-2.0.3-win32-x86.zip -d %ROOT%\SDL_binaries
  unzip -o %ROOT%\SDL2_ttf-2.0.14-win32-x86.zip -d %ROOT%\SDL_binaries
  unzip -o %ROOT%\SDL2-2.0.8-win32-x86.zip -d %ROOT%\SDL_binaries
  
  if not exist %ROOT%\SDL2_image-2.0.3.zip (
    curl --output %ROOT%\SDL2_image-2.0.3.zip http://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.3.zip
  )
  
  if not exist %ROOT%\SDL2_ttf-2.0.14.zip (
    curl --output %ROOT%\SDL2_ttf-2.0.14.zip http://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.zip
  )
  
  if not exist %ROOT%\SDL2_image-2.0.3\version.rc (
    unzip %ROOT%\SDL2_image-2.0.3.zip -d %ROOT%
  )
  
  if not exist %ROOT%\SDL2_ttf-2.0.14\version.rc (
    unzip %ROOT%\SDL2_ttf-2.0.14.zip -d %ROOT%
  )
  
  exit /b

endlocal
