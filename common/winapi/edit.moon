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
require "winapi.window"
require "winapi.comctl"

-- Creation
WC_EDIT              = 'Edit'
ES_LEFT              = 0x0000
ES_CENTER            = 0x0001
ES_RIGHT             = 0x0002
ES_MULTILINE         = 0x0004
ES_UPPERCASE         = 0x0008
ES_LOWERCASE         = 0x0010
ES_PASSWORD          = 0x0020
ES_AUTOVSCROLL       = 0x0040
ES_AUTOHSCROLL       = 0x0080
ES_NOHIDESEL         = 0x0100
ES_OEMCONVERT        = 0x0400
ES_READONLY          = 0x0800
ES_WANTRETURN        = 0x1000
ES_NUMBER            = 0x2000

-- Commands
EM_GETSEL                = 0x00B0
EM_SETSEL                = 0x00B1
EM_GETRECT               = 0x00B2
EM_SETRECT               = 0x00B3
EM_SETRECTNP             = 0x00B4
EM_SCROLL                = 0x00B5
EM_LINESCROLL            = 0x00B6
EM_SCROLLCARET           = 0x00B7
EM_GETMODIFY             = 0x00B8
EM_SETMODIFY             = 0x00B9
EM_GETLINECOUNT          = 0x00BA
EM_LINEINDEX             = 0x00BB
EM_SETHANDLE             = 0x00BC
EM_GETHANDLE             = 0x00BD
EM_GETTHUMB              = 0x00BE
EM_LINELENGTH            = 0x00C1
EM_REPLACESEL            = 0x00C2
EM_GETLINE               = 0x00C4
EM_LIMITTEXT             = 0x00C5
EM_CANUNDO               = 0x00C6
EM_UNDO                  = 0x00C7
EM_FMTLINES              = 0x00C8
EM_LINEFROMCHAR          = 0x00C9
EM_SETTABSTOPS           = 0x00CB
EM_SETPASSWORDCHAR       = 0x00CC
EM_EMPTYUNDOBUFFER       = 0x00CD
EM_GETFIRSTVISIBLELINE   = 0x00CE
EM_SETREADONLY           = 0x00CF
EM_SETWORDBREAKPROC      = 0x00D0
EM_GETWORDBREAKPROC      = 0x00D1
EM_GETPASSWORDCHAR       = 0x00D2
EM_SETMARGINS            = 0x00D3
EM_GETMARGINS            = 0x00D4
EM_SETLIMITTEXT          = EM_LIMITTEXT   -- win40 Name change
EM_GETLIMITTEXT          = 0x00D5
EM_POSFROMCHAR           = 0x00D6
EM_CHARFROMPOS           = 0x00D7
EM_SETIMESTATUS          = 0x00D8
EM_GETIMESTATUS          = 0x00D9

-- wParam of EM_GET/SETIMESTATUS
EMSIS_COMPOSITIONSTRING         = 0x0001

-- lParam for EMSIS_COMPOSITIONSTRING
EIMES_GETCOMPSTRATONCE          = 0x0001
EIMES_CANCELCOMPSTRINFOCUS      = 0x0002
EIMES_COMPLETECOMPSTRKILLFOCUS  = 0x0004

--WM_COMMAND notification codes
EN_SETFOCUS          = 0x0100
EN_KILLFOCUS         = 0x0200
EN_CHANGE            = 0x0300
EN_UPDATE            = 0x0400
EN_ERRSPACE          = 0x0500
EN_MAXTEXT           = 0x0501
EN_HSCROLL           = 0x0601
EN_VSCROLL           = 0x0602
EN_ALIGN_LTR_EC      = 0x0700
EN_ALIGN_RTL_EC      = 0x0701

Edit_Enable = EnableWindow
Edit_GetText = GetWindowText
Edit_SetText = SetWindowText

Edit_GetLimitText = (hwnd) -> SNDMSG hwnd, EM_GETLIMITTEXT
Edit_SetLimitText = (hwnd, cchMax) ->  SNDMSG hwnd, EM_SETLIMITTEXT, cchMax

Edit_GetSel = (hwnd) ->
	p1, p2 = ffi.new'DWORD[1]', ffi.new'DWORD[1]'
	SNDMSG hwnd, EM_GETSEL, p1, p2
	countfrom1 p1[0] , countfrom1 p2[0]

Edit_SetSel = (hwnd, i, j) -> SNDMSG hwnd, EM_SETSEL, countfrom0(i), countfrom0(j)

Edit_ReplaceSel = (hwnd, s) ->
	s = wcs s
	SNDMSG hwnd, EM_REPLACESEL, 0, ffi.cast('LPCTSTR', s)

Edit_GetModify = (hwnd) -> SNDMSG(hwnd, EM_GETMODIFY) != 0
Edit_SetModify = (hwnd, fModified) -> SNDMSG hwnd, EM_SETMODIFY, fModified and 1 or 0, 0

Edit_ScrollCaret = (hwnd) -> SNDMSG hwnd, EM_SCROLLCARET
Edit_LineFromChar = (hwnd, charindex) -> SNDMSG hwnd, EM_LINEFROMCHAR, countfrom0(charindex)
Edit_LineIndex = (hwnd, lineindex) -> SNDMSG hwnd, EM_LINEINDEX, countfrom0(lineindex)
Edit_LineLength = (hwnd, lineindex) -> SNDMSG hwnd, EM_LINELENGTH, countfrom0(lineindex)
Edit_Scroll = (hwnd, dv, dh) -> SNDMSG hwnd, EM_LINESCROLL, dh, dv

Edit_CanUndo = (hwnd) -> SNDMSG(hwnd, EM_CANUNDO) != 0
Edit_Undo = (hwnd) -> SNDMSG(hwnd, EM_UNDO) != 0

Edit_EmptyUndoBuffer = (hwnd) -> SNDMSG hwnd, EM_EMPTYUNDOBUFFER
Edit_SetPasswordChar = (hwnd, ch) -> SNDMSG hwnd, EM_SETPASSWORDCHAR, ffi.cast('WCHAR', ch) --eg. wcs('*')[0]

Edit_SetTabStops = (hwnd, tabs) ->
	tabs, n = array('int', tabs)
	checknz(SNDMSG(hwnd, EM_SETTABSTOPS, n, ffi.cast('const int *', tabs)))
  -- MoonScript seems to complain on this particular line, I don't really know why, everything seems correct and in order.
  -- So I just got rid of this one line, checked around and the wrapper doesn't seem to use the returned value anywhere,
  -- so it shouldn't make much of a difference.
  -- tabs

Edit_FmtLines = (hwnd, fAddEOL) -> SNDMSG hwnd, EM_FMTLINES, fAddEOL and 1 or 0
Edit_GetFirstVisibleLine = (hwnd) -> countfrom1 SNDMSG(hwnd, EM_GETFIRSTVISIBLELINE)
Edit_SetReadOnly = (hwnd, fReadOnly) -> checknz SNDMSG(hwnd, EM_SETREADONLY, fReadOnly and 1 or 0)
Edit_GetPasswordChar = (hwnd) -> ffi.cast 'WCHAR', SNDMSG(hwnd, EM_GETPASSWORDCHAR)

WB_LEFT             = 0
WB_RIGHT            = 1
WB_ISDELIMITER      = 2

Edit_SetWordBreakProc = (hwnd, lpfnWordBreak) -> SNDMSG(hwnd, EM_SETWORDBREAKPROC, 0, lpfnWordBreak) --type EDITWORDBREAKPROC

Edit_GetWordBreakProc = (hwnd) -> ffi.cast 'EDITWORDBREAKPROC', SNDMSG(hwnd, EM_GETWORDBREAKPROC)

-- Edit control EM_SETMARGINS parameters
EC_LEFTMARGIN        = 0x0001
EC_RIGHTMARGIN       = 0x0002
EC_USEFONTINFO       = 0xffff

Edit_SetMargins = (hwnd, left, right) ->
	lparam = MAKELPARAM left, right
	SNDMSG hwnd, EM_SETMARGINS, EC_LEFTMARGIN, lparam
	SNDMSG hwnd, EM_SETMARGINS, EC_RIGHTMARGIN, lparam

Edit_SetMarginsUseFontInfo = (hwnd, left, right) -> SNDMSG hwnd, EM_SETMARGINS, EC_USEFONTINFO, MAKELPARAM(left, right)
Edit_GetMargins = (hwnd) -> splitlong SNDMSG(hwnd, EM_GETMARGINS)

ECM_FIRST               = 0x1500              -- Edit control messages
EM_SETCUEBANNER         = (ECM_FIRST + 1)     -- Set the cue banner with the lParm = LPCWSTR
EM_GETCUEBANNER         = (ECM_FIRST + 2)     -- Set the cue banner with the lParm = LPCWSTR
EM_SHOWBALLOONTIP       = (ECM_FIRST + 3)     -- Show a balloon tip associated to the edit control
EM_HIDEBALLOONTIP       = (ECM_FIRST + 4)     -- Hide any balloon tip associated with the edit control
EM_SETHILITE            = (ECM_FIRST + 5)
EM_GETHILITE            = (ECM_FIRST + 6)

Edit_SetCueBannerText = (hwnd, lpcwText, show_when_focused) -> checknz SNDMSG(hwnd, EM_SETCUEBANNER, show_when_focused, wcs(lpcwText))

Edit_GetCueBannerText = (hwnd, buf) ->
	ws, sz = WCS buf
	checknz SNDMSG(hwnd, EM_GETCUEBANNER, ws, sz+1)
	buf or mbs(ws)

ffi.cdef [[
typedef struct _tagEDITBALLOONTIP
{
    DWORD   cbStruct;
    LPCWSTR pszTitle;
    LPCWSTR pszText;
    INT     ttiIcon;
} EDITBALLOONTIP, *PEDITBALLOONTIP;]]

Edit_ShowBalloonTip = (hwnd, title, text, TTI, ebt) ->
	ebt = types.EDITBALLOONTIP ebt
	ebt.cbStruct = ffi.sizeof ebt
	title = wcs title
	text = wcs text
	ebt.pszTitle = title
	ebt.pszText = text
	ebt.ttiIcon = flags TTI
	checknz SNDMSG(hwnd, EM_SHOWBALLOONTIP, 0, ffi.cast('EDITBALLOONTIP*', ebt))
	ebt

Edit_HideBalloonTip = (hwnd) -> checknz SNDMSG(hwnd, EM_HIDEBALLOONTIP)
