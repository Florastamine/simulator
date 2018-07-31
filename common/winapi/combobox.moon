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

-- TODO
-- WM_COMPAREITEM
-- WM_DRAWITEM
-- WM_MEASUREITEM

export *

setfenv 1, require "winapi"
require "winapi.window"

-- Creation
CB_OKAY             = 0
CB_ERR              = -1
CB_ERRSPACE         = -2

CBS_SIMPLE             = 0x0001
CBS_DROPDOWN           = 0x0002
CBS_DROPDOWNLIST       = 0x0003
CBS_OWNERDRAWFIXED     = 0x0010
CBS_OWNERDRAWVARIABLE  = 0x0020
CBS_AUTOHSCROLL        = 0x0040
CBS_OEMCONVERT         = 0x0080
CBS_SORT               = 0x0100
CBS_HASSTRINGS         = 0x0200
CBS_NOINTEGRALHEIGHT   = 0x0400
CBS_DISABLENOSCROLL    = 0x0800
CBS_UPPERCASE          = 0x2000
CBS_LOWERCASE          = 0x4000

-- Notifications
CBN_ERRSPACE         = -1
CBN_SELCHANGE        = 1
CBN_DBLCLK           = 2
CBN_SETFOCUS         = 3
CBN_KILLFOCUS        = 4
CBN_EDITCHANGE       = 5
CBN_EDITUPDATE       = 6
CBN_DROPDOWN         = 7
CBN_CLOSEUP          = 8
CBN_SELOK            = 9
CBN_SELCANCEL        = 10

-- Commands
CB_GETEDITSEL                = 0x0140
CB_LIMITTEXT                 = 0x0141
CB_SETEDITSEL                = 0x0142
CB_ADDSTRING                 = 0x0143
CB_DELETESTRING              = 0x0144
CB_DIR                       = 0x0145
CB_GETCOUNT                  = 0x0146
CB_GETCURSEL                 = 0x0147
CB_GETLBTEXT                 = 0x0148
CB_GETLBTEXTLEN              = 0x0149
CB_INSERTSTRING              = 0x014A
CB_RESETCONTENT              = 0x014B
CB_FINDSTRING                = 0x014C
CB_SELECTSTRING              = 0x014D
CB_SETCURSEL                 = 0x014E
CB_SHOWDROPDOWN              = 0x014F
CB_GETITEMDATA               = 0x0150
CB_SETITEMDATA               = 0x0151
CB_GETDROPPEDCONTROLRECT     = 0x0152
CB_SETITEMHEIGHT             = 0x0153
CB_GETITEMHEIGHT             = 0x0154
CB_SETEXTEDUI                = 0x0155
CB_GETEXTEDUI                = 0x0156
CB_GETDROPPEDSTATE           = 0x0157
CB_FINDSTRINGEXACT           = 0x0158
CB_SETLOCALE                 = 0x0159
CB_GETLOCALE                 = 0x015A
CB_GETTOPINDEX               = 0x015b
CB_SETTOPINDEX               = 0x015c
CB_GETHORIZONTALEXTENT       = 0x015d
CB_SETHORIZONTALEXTENT       = 0x015e
CB_GETDROPPEDWIDTH           = 0x015f
CB_SETDROPPEDWIDTH           = 0x0160
CB_INITSTORAGE               = 0x0161
CB_MULTIPLEADDSTRING         = 0x0163
CB_GETCOMBOBOXINFO           = 0x0164
CB_MSGMAX                    = 0x0165

ComboBox_AddString = (hwnd, s) ->
	countfrom1(checkpoz(SNDMSG(hwnd, CB_ADDSTRING, 0, wcs(s))))

ComboBox_InsertString = (hwnd, i, s) ->
	countfrom1(checkpoz(SNDMSG(hwnd, CB_INSERTSTRING, countfrom0(i), wcs(s))))

ComboBox_DeleteString = (hwnd, i) ->
	checkpoz(SNDMSG(hwnd, CB_DELETESTRING, countfrom0(i)))

ComboBox_GetString = (hwnd, i, buf) ->
	ws = WCS(buf or checkpoz(SNDMSG(hwnd, CB_GETLBTEXTLEN, countfrom0(i))))
	checkpoz(SNDMSG(hwnd, CB_GETLBTEXT, countfrom0(i), ws))
	buf or mbs(ws)

ComboBox_GetCount = (hwnd) ->
	checkpoz(SNDMSG(hwnd, CB_GETCOUNT))

ComboBox_Reset = (hwnd) ->
	checkz(SNDMSG(hwnd, CB_RESETCONTENT))

ComboBox_SetCurSel = (hwnd, i) ->
	countfrom1(checkpoz(SNDMSG(hwnd, CB_SETCURSEL, countfrom0(i))))

ComboBox_GetCurSel = (hwnd) ->
	countfrom1(SNDMSG(hwnd, CB_GETCURSEL))

ComboBox_SetExtedUI = (hwnd, exted) ->
	checkz(SNDMSG(hwnd, CB_SETEXTEDUI, exted))

ComboBox_LimitText = (hwnd, cchMax) ->
	checktrue(SNDMSG(hwnd, CB_LIMITTEXT, cchMax))

ComboBox_SetItemHeight = (hwnd, item, height) ->
	item = (item == 'edit' and -1)  or (item == 'list' and 0) or countfrom0(item)
	checkpoz(SNDMSG(hwnd, CB_SETITEMHEIGHT, item, height))

ComboBox_GetItemHeight = (hwnd, item) ->
	item = (item == 'edit' and -1)  or (item == 'list' and 0) or countfrom0(item)
	checkpoz(SNDMSG(hwnd, CB_GETITEMHEIGHT, item))

ComboBox_GetEditSel = (hwnd) ->
	p1, p2 = ffi.new'DWORD[1]', ffi.new'DWORD[1]'
	SNDMSG(hwnd, CB_GETEDITSEL, p1, p2)
	countfrom1(p1[0]), countfrom1(p2[0])

CheckBox_SetEditSel = (hwnd, i, j) ->
	checktrue(SNDMSG(hwnd, CB_SETEDITSEL, 0, MAKELPARAM(countfrom0(i), countfrom0(j))))

ComboBox_ShowDropdown = (hwnd, show) ->
	checktrue(SNDMSG(hwnd, CB_SHOWDROPDOWN, show))

ComboBox_DroppedDown = (hwnd) ->
	SNDMSG(hwnd, CB_GETDROPPEDSTATE) == 1

ComboBox_SetDroppedWidth = (hwnd, w) ->
	checkpoz(SNDMSG(hwnd, CB_SETDROPPEDWIDTH, w))

ComboBox_GetDroppedWidth = (hwnd) ->
	checkpoz(SNDMSG(hwnd, CB_GETDROPPEDWIDTH))
