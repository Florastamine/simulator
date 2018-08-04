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

TME_HOVER       = 0x00000001
TME_LEAVE       = 0x00000002
TME_NONCLIENT   = 0x00000010
TME_QUERY       = 0x40000000
TME_CANCEL      = 0x80000000
HOVER_DEFAULT   = 0xFFFFFFFF

ffi.cdef [[
typedef struct tagTRACKMOUSEEVENT {
    DWORD cbSize;
    DWORD dwFlags;
    HWND  hwnd;
    DWORD hover_time;
} TRACKMOUSEEVENT, *LPTRACKMOUSEEVENT;

BOOL TrackMouseEvent(LPTRACKMOUSEEVENT lpEventTrack);

UINT GetDoubleClickTime();
BOOL SetDoubleClickTime(UINT uInterval);

HWND GetCapture(void);
HWND SetCapture(HWND hWnd);
BOOL ReleaseCapture(void);

BOOL DragDetect(HWND hwnd, POINT pt);]]

TRACKMOUSEEVENT = struct{
	ctype: 'TRACKMOUSEEVENT', size: 'cbSize',
	fields: sfields{
		'flags', 'dwFlags', flags, pass,
	},
}

TrackMouseEvent = (event) ->
	event = TRACKMOUSEEVENT event
	checknz C.TrackMouseEvent(event)

GetDoubleClickTime = C.GetDoubleClickTime
SetDoubleClickTime = (interval) -> checknz C.SetDoubleClickTime(interval)

GetCapture = -> ptr C.GetCapture!
SetCapture = (hwnd) -> ptr C.SetCapture(hwnd)
ReleaseCapture = -> checknz C.ReleaseCapture!

DragDetect = (hwnd, point) -> C.DragDetect(hwnd, POINT(point)) != 0

-- Messages
HTERROR             = -2
HTTRANSPARENT       = -1
HTNOWHERE           = 0
HTCLIENT            = 1
HTCAPTION           = 2
HTSYSMENU           = 3
HTGROWBOX           = 4
HTSIZE              = HTGROWBOX
HTMENU              = 5
HTHSCROLL           = 6
HTVSCROLL           = 7
HTMINBUTTON         = 8
HTMAXBUTTON         = 9
HTLEFT              = 10
HTRIGHT             = 11
HTTOP               = 12
HTTOPLEFT           = 13
HTTOPRIGHT          = 14
HTBOTTOM            = 15
HTBOTTOMLEFT        = 16
HTBOTTOMRIGHT       = 17
HTBORDER            = 18
HTREDUCE            = HTMINBUTTON
HTZOOM              = HTMAXBUTTON
HTSIZEFIRST         = HTLEFT
HTSIZELAST          = HTBOTTOMRIGHT
HTOBJECT            = 19
HTCLOSE             = 20
HTHELP              = 21

WM.WM_NCHITTEST = (wParam, lParam) -> splitsigned lParam --x, y; must return HT*

MK_LBUTTON          = 0x0001
MK_RBUTTON          = 0x0002
MK_SHIFT            = 0x0004
MK_CONTROL          = 0x0008
MK_MBUTTON          = 0x0010
MK_XBUTTON1         = 0x0020
MK_XBUTTON2         = 0x0040

__buttons_bitmask__ = bitmask {
	lbutton: MK_LBUTTON,
	rbutton: MK_RBUTTON,
	shift: MK_SHIFT,
	control: MK_CONTROL,
	mbutton: MK_MBUTTON,
	xbutton1: MK_XBUTTON1,
	xbutton2: MK_XBUTTON2,
}

-- NOTE: double-click messages are only received on windows with CS_DBLCLKS style
WM.WM_LBUTTONDBLCLK = (wParam, lParam) ->
	x, y = splitsigned lParam
	x, y, __buttons_bitmask__\get tonumber(wParam)

WM.WM_LBUTTONDOWN = WM.WM_LBUTTONDBLCLK
WM.WM_LBUTTONUP = WM.WM_LBUTTONDBLCLK
WM.WM_MBUTTONDBLCLK = WM.WM_LBUTTONDBLCLK
WM.WM_MBUTTONDOWN = WM.WM_LBUTTONDBLCLK
WM.WM_MBUTTONUP = WM.WM_LBUTTONDBLCLK
WM.WM_MOUSEHOVER = WM.WM_LBUTTONDBLCLK
WM.WM_MOUSEMOVE = WM.WM_LBUTTONDBLCLK
WM.WM_RBUTTONDBLCLK = WM.WM_LBUTTONDBLCLK
WM.WM_RBUTTONDOWN = WM.WM_LBUTTONDBLCLK
WM.WM_RBUTTONUP = WM.WM_LBUTTONDBLCLK

WM.WM_MOUSEWHEEL = (wParam, lParam) ->
	x, y = splitsigned lParam
	buttons, delta = splitsigned ffi.cast('int32_t', wParam)
	x, y, __buttons_bitmask__\get(buttons), delta

WM.WM_MOUSEHWHEEL = WM.WM_MOUSEWHEEL

XBUTTON1 = 0x0001
XBUTTON2 = 0x0002

__buttons_bitmask__ = bitmask{
	xbutton1: XBUTTON1,
	xbutton2: XBUTTON2,
}

WM.WM_XBUTTONDBLCLK = (wParam, lParam) ->
	x, y = splitsigned lParam
	MK, XBUTTON = splitlong wParam
	x, y, __buttons_bitmask__\get(MK), __buttons_bitmask__\get(XBUTTON)

WM.WM_XBUTTONDOWN = WM.WM_XBUTTONDBLCLK
WM.WM_XBUTTONUP = WM.WM_XBUTTONDBLCLK

WM.WM_NCLBUTTONDBLCLK = (wParam, lParam) ->
	x, y = splitsigned lParam
	x, y, tonumber wParam --x, y, HT*

WM.WM_NCLBUTTONDOWN = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCLBUTTONUP = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCMBUTTONDBLCLK = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCMBUTTONDOWN = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCMBUTTONUP = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCMOUSEHOVER = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCMOUSEMOVE = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCRBUTTONDBLCLK = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCRBUTTONDOWN = WM.WM_NCLBUTTONDBLCLK
WM.WM_NCRBUTTONUP = WM.WM_NCLBUTTONDBLCLK

WM.WM_NCXBUTTONDBLCLK = WM.WM_XBUTTONDBLCLK --HT*, XBUTTON*, x, y
WM.WM_NCXBUTTONDOWN = WM.WM_NCXBUTTONDBLCLK
WM.WM_NCXBUTTONUP = WM.WM_NCXBUTTONDBLCLK

MA_ACTIVATE         = 1
MA_ACTIVATEANDEAT   = 2
MA_NOACTIVATE       = 3
MA_NOACTIVATEANDEAT = 4

WM.WM_MOUSEACTIVATE = (wParam, lParam) ->
	HT, MK = splitlong lParam
	ffi.cast('HWND', wParam), HT, __buttons_bitmask__\get MK --must return MA_*
