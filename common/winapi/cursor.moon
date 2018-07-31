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

export *

setfenv 1, require "winapi"
require "winapi.winuser"

ffi.cdef [[
typedef struct {
  DWORD   cbSize;
  DWORD   flags;
  HCURSOR hCursor;
  POINT   ptScreenPos;
} CURSORINFO, *PCURSORINFO, *LPCURSORINFO;

HCURSOR LoadCursorW(HINSTANCE hInstance, LPCWSTR lpCursorName);
int ShowCursor(BOOL bShow);
BOOL SetCursorPos(int X, int Y);
BOOL SetPhysicalCursorPos(int X, int Y);
HCURSOR SetCursor(HCURSOR hCursor);
BOOL GetCursorPos(LPPOINT lpPoint);
BOOL GetPhysicalCursorPos(LPPOINT lpPoint);
DWORD GetMessagePos(void);
BOOL ClipCursor(const RECT *lpRect);
BOOL GetClipCursor(LPRECT lpRect);
HCURSOR GetCursor(void);
BOOL GetCursorInfo(PCURSORINFO pci);
UINT GetCaretBlinkTime();
]]

IDC_ARROW       = 32512
IDC_IBEAM       = 32513
IDC_WAIT        = 32514
IDC_CROSS       = 32515
IDC_UPARROW     = 32516
IDC_SIZE        = 32640
IDC_ICON        = 32641
IDC_SIZENWSE    = 32642
IDC_SIZENESW    = 32643
IDC_SIZEWE      = 32644
IDC_SIZENS      = 32645
IDC_SIZEALL     = 32646
IDC_NO          = 32648
IDC_HAND        = 32649
IDC_APPSTARTING = 32650
IDC_HELP        = 32651

LoadCursor = (hInstance, name) ->
  if not name
    hInstance, name = nil, hInstance
  checkh C.LoadCursorW(hInstance, ffi.cast('LPCWSTR', wcs(MAKEINTRESOURCE name)))

SetCursor = (cursor) ->
	ptr C.SetCursor(cursor)

GetMessagePos = () ->
	splitsigned C.GetMessagePos!

CURSOR_SHOWING     = 1
CURSOR_SUPPRESSED  = 2 -- Windows 8 & higher

CURSORINFO = struct {ctype: 'CURSORINFO', size: 'cbSize'}

GetCursorInfo = (pci) ->
	pci = CURSORINFO pci
	checknz C.GetCursorInfo(pci)
	pci

-- Note: GetCursorPos() must be passed in the form of a POINT * in the lower 2GB memory space, otherwise it will fail.
-- LuaJIT 2.x doesn't suffer but just to make sure, we emulate GetCursorPos() with GetCursorInfo() as a workaround.
GetCursorPos = (p, pci) ->
	pci = GetCursorInfo(pci)
	if p
		p.x = pci.ptScreenPos.x
		p.y = pci.ptScreenPos.y
	else
		p = POINT pci.ptScreenPos
	p, pci

SetCursorPos = C.SetCursorPos

GetCaretBlinkTime = () ->
	t = checknz C.GetCaretBlinkTime!
	t != 0xffffffff and t

WM.WM_SETCURSOR = (wParam, lParam) ->
	HT, id = splitlong lParam
	ffi.cast('HWND', wParam), HT, id --HT codes are in winapi.mouse
