-- ================================================================================
-- Copyright (C) 2018, Florastamine
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
-- ================================================================================

-- Note: Don't define time_t because it's 64bit in windows but 32bit in mingw: use explicit types!
-- Note: SIZE has w and h unioned to cx and cy and these are the ones used throughout.
-- Note: RECT has x1, y1, x2, y2 unioned to left, right, top, bottom and these are the ones used throughout.

export *

setfenv 1, require "winapi"
require "winapi.winuser"

ffi.cdef [[
HICON LoadIconW(
	  HINSTANCE hInstance,
	  LPCWSTR lpIconName);

BOOL DestroyIcon(HICON hIcon);

typedef struct _ICONINFO {
    BOOL    fIcon;
    DWORD   xHotspot;
    DWORD   yHotspot;
    HBITMAP hbmMask;
    HBITMAP hbmColor;
} ICONINFO;
typedef ICONINFO *PICONINFO;

HICON CreateIconIndirect(PICONINFO piconinfo);
]]

IDI_APPLICATION   = 32512
IDI_INFORMATION   = 32516
IDI_QUESTION      = 32514
IDI_WARNING       = 32515
IDI_ERROR         = 32513
IDI_WINLOGO       = 32517 -- Same as IDI_APPLICATION in XP
IDI_SHIELD        = 32518 -- Not found in XP

LoadIconFromInstance = (hInstance, name) ->
	if not name then hInstance, name = nil, hInstance
	own(checkh(C.LoadIconW(hInstance, ffi.cast('LPCWSTR', wcs(MAKEINTRESOURCE(flags name))))), DestroyIcon)

DestroyIcon = (hicon) ->
	checknz C.DestroyIcon(hicon)

ICONINFO = types.ICONINFO

CreateIconIndirect = (info) ->
	info = ICONINFO info
	checkh(C.CreateIconIndirect(info))

-- WM_SETICON flags
ICON_BIG = 1
ICON_SMALL = 0
