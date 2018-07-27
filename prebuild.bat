@echo off

setlocal

call:PreProcess
call:Clone luajit https://github.com/LuaJIT/LuaJIT
call:Clone moonscript https://github.com/leafo/moonscript
call:Clone argparse https://github.com/mpeterv/argparse
call:PostProcess

:Clone
  echo | set /p=Cloning %~1 from %~2...
  echo.
  mkdir .\thirdparty\%~1
  git clone %~2 .\thirdparty\%~1 --depth=1
  exit /b

:PreProcess
  mkdir .\thirdparty
  exit /b

:PostProcess
  move .\thirdparty\argparse\src\argparse.lua .\thirdparty\argparse\
  exit /b

endlocal
