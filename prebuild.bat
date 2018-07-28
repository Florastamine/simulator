@echo off

call vars.bat

setlocal

call:PreProcess
call:Clone luajit https://github.com/LuaJIT/LuaJIT
call:Clone moonscript https://github.com/leafo/moonscript
call:Clone argparse https://github.com/mpeterv/argparse
call:Clone lua-cjson https://github.com/mpx/lua-cjson
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
  
  del .\thirdparty\lua-cjson\dtoa*.*
  del .\thirdparty\lua-cjson\g_fmt*.*
  exit /b

endlocal
