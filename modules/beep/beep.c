/*
  ================================================================================
  Copyright (C) 2018, Florastamine
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  ================================================================================
*/

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include "beep.h"

#if _WIN32
#include <windows.h>
#endif

int os_beep(lua_State* L)
{
#if _WIN32
	Beep((DWORD) luaL_optinteger(L, 1, -1), (DWORD) luaL_optinteger(L, 2, -1));
#endif
	return 0;
}

static const struct luaL_Reg core_beep[] = {
  {"beep", os_beep},
  {NULL, NULL},
};

EXPORT int luaopen_beep(lua_State *L)
{
  luaL_openlib(L, "os", core_beep, 0);
  return 0;
}
