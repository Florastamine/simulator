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
WC_BUTTON            = 'Button'

BS_PUSHBUTTON        = 0x00000000
BS_DEFPUSHBUTTON     = 0x00000001
BS_CHECKBOX          = 0x00000002
BS_AUTOCHECKBOX      = 0x00000003
BS_RADIOBUTTON       = 0x00000004
BS_3STATE            = 0x00000005
BS_AUTO3STATE        = 0x00000006
BS_GROUPBOX          = 0x00000007
BS_AUTORADIOBUTTON   = 0x00000009
BS_PUSHBOX           = 0x0000000A --does not display a button face or frame; only the text appears
BS_OWNERDRAW         = 0x0000000B
BS_LEFTTEXT          = 0x00000020
BS_TEXT              = 0x00000000
BS_ICON              = 0x00000040
BS_BITMAP            = 0x00000080
BS_LEFT              = 0x00000100
BS_RIGHT             = 0x00000200
BS_CENTER            = 0x00000300
BS_TOP               = 0x00000400
BS_BOTTOM            = 0x00000800
BS_VCENTER           = 0x00000C00
BS_PUSHLIKE          = 0x00001000
BS_MULTILINE         = 0x00002000
BS_NOTIFY            = 0x00004000
BS_FLAT              = 0x00008000
BS_SPLITBUTTON       = 0x0000000C --vista+
BS_DEFSPLITBUTTON    = 0x0000000D --vista+
BS_COMMANDLINK       = 0x0000000E --vista+
BS_DEFCOMMANDLINK    = 0x0000000F --vista+

-- Commands
BM_GETCHECK         = 0x00F0
BM_SETCHECK         = 0x00F1
BM_GETSTATE         = 0x00F2
BM_SETSTATE         = 0x00F3
BM_SETSTYLE         = 0x00F4
BM_CLICK            = 0x00F5
BM_GETIMAGE         = 0x00F6
BM_SETIMAGE         = 0x00F7
BM_SETDONTCLICK     = 0x00F8 --vista+

Button_Enable = EnableWindow
Button_GetText = GetWindowText
Button_SetText = SetWindowText

BST_UNCHECKED       = 0x0000
BST_CHECKED         = 0x0001
BST_INDETERMINATE   = 0x0002
BST_PUSHED          = 0x0004
BST_FOCUS           = 0x0008

Button_GetCheck = (hwndCtl) -> SNDMSG hwndCtl, BM_GETCHECK
Button_SetCheck = (hwndCtl, check) -> SNDMSG hwndCtl, BM_SETCHECK, flags(check)

Button_GetState = (hwndCtl) -> SNDMSG(hwndCtl, BM_GETSTATE) != 0
Button_SetState = (hwndCtl, state) -> checkz SNDMSG(hwndCtl, BM_SETSTATE, state)

Button_SetStyle = (hwndCtl, style, fRedraw) -> checknz SNDMSG(hwndCtl, BM_SETSTYLE, flags(style), MAKELPARAM(fRedraw and 1 or 0, 0))

Button_Click = (hwndCtl) -> SNDMSG hwndCtl, BM_CLICK

Button_GetBitmap = (hwndCtl) -> ptr ffi.cast('HBITMAP', SNDMSG(hwndCtl, BM_GETIMAGE, IMAGE_BITMAP))
Button_SetBitmap = (hwndCtl, bitmap) -> ptr ffi.cast('HBITMAP', SNDMSG(hwndCtl, BM_SETIMAGE, IMAGE_BITMAP, bitmap))

Button_GetIcon = (hwndCtl) -> ptr ffi.cast('HICON', SNDMSG(hwndCtl, BM_GETIMAGE, IMAGE_ICON))
Button_SetIcon = (hwndCtl, icon) -> ptr ffi.cast('HICON', SNDMSG(hwndCtl, BM_SETIMAGE, IMAGE_ICON, icon))

Button_SetDontClick = (hwndCtl, dontclick) -> SNDMSG hwndCtl, BM_SETDONTCLICK, dontclick

BCM_FIRST               = 0x1600
BCM_GETIDEALSIZE        = (BCM_FIRST + 0x0001)
BCM_SETIMAGELIST        = (BCM_FIRST + 0x0002)
BCM_GETIMAGELIST        = (BCM_FIRST + 0x0003)
BCM_SETTEXTMARGIN       = (BCM_FIRST + 0x0004)
BCM_GETTEXTMARGIN       = (BCM_FIRST + 0x0005)
BCM_SETDROPDOWNSTATE    = (BCM_FIRST + 0x0006)
BCM_SETSPLITINFO        = (BCM_FIRST + 0x0007)
BCM_GETSPLITINFO        = (BCM_FIRST + 0x0008)
BCM_SETNOTE             = (BCM_FIRST + 0x0009)
BCM_GETNOTE             = (BCM_FIRST + 0x000A)
BCM_GETNOTELENGTH       = (BCM_FIRST + 0x000B)
BCM_SETSHIELD           = (BCM_FIRST + 0x000C)

Button_GetIdealSize = (hwnd, size) -> SIZE size

BUTTON_IMAGELIST_ALIGN_LEFT     = 0
BUTTON_IMAGELIST_ALIGN_RIGHT    = 1
BUTTON_IMAGELIST_ALIGN_TOP      = 2
BUTTON_IMAGELIST_ALIGN_BOTTOM   = 3
BUTTON_IMAGELIST_ALIGN_CENTER   = 4

ffi.cdef [[
enum PUSHBUTTONSTATES {
	PBS_NORMAL = 1,
	PBS_HOT = 2,
	PBS_PRESSED = 3,
	PBS_DISABLED = 4,
	PBS_DEFAULTED = 5,
	PBS_DEFAULTED_ANIMATING = 6,
};

typedef struct
{
	 HIMAGELIST  imagelist;
	 RECT        margin;
	 UINT        uAlign;
} BUTTON_IMAGELIST, *PBUTTON_IMAGELIST;]]

BUTTON_IMAGELIST = struct{
	ctype: 'BUTTON_IMAGELIST',
	fields: sfields{
		'align', 'uAlign', flags,
	}
}

BCCL_NOGLYPH = ffi.cast 'HIMAGELIST', -1 -- Flag to indicate no glyph to SetImageList

Button_SetImageList = (hwnd, bimlist) ->
	bimlist = BUTTON_IMAGELIST bimlist
	checknz SNDMSG(hwnd, BCM_SETIMAGELIST, 0, ffi.cast('PBUTTON_IMAGELIST', bimlist))

Button_GetImageList = (hwnd, bimlist) ->
	bimlist = BUTTON_IMAGELIST bimlist
	checknz SNDMSG(hwnd, BCM_GETIMAGELIST, 0, ffi.cast('PBUTTON_IMAGELIST', bimlist))
	bimlist

Button_SetTextMargin = (hwnd, margin) ->
	margin = RECT margin
	checknz SNDMSG(hwnd, BCM_SETTEXTMARGIN, 0, ffi.cast('RECT*', margin))

Button_GetTextMargin = (hwnd, margin) ->
	margin = RECT margin
	checknz SNDMSG(hwnd, BCM_GETTEXTMARGIN, 0, ffi.cast('RECT*', margin))
	margin

Button_SetDropDownState = (hwnd, fDropDown) -> checknz SNDMSG(hwnd, BCM_SETDROPDOWNSTATE, fDropDown)

Button_SetSplitInfo = (hwnd, pInfo) -> checknz SNDMSG(hwnd, BCM_SETSPLITINFO, 0, pInfo)
Button_GetSplitInfo = (hwnd, pInfo) -> checknz SNDMSG(hwnd, BCM_GETSPLITINFO, 0, pInfo)

Button_SetNote = (hwnd, psz) -> checknz SNDMSG(hwnd, BCM_SETNOTE, 0, ffi.cast('LPCWSTR', wcs(psz)))
Button_GetNote = (hwnd, buf) -> 
	ws, sz = WCS(buf or checkpoz(SNDMSG(hwnd, BCM_GETNOTELENGTH)))
	checknz SNDMSG(hwnd, BCM_GETNOTE, ws, ffi.cast('LPCWSTR', sz))
  -- This also seems to be another case where MoonScript would complain although the code is perfectly fine.
  -- No one reuses the returned value so this can be commented out safely.
  -- buf or mbs(ws)

-- Macro to use on a button or command link to display an elevated icon
Button_SetElevationRequiredState = (hwnd, fRequired) -> checkpoz SNDMSG(hwnd, BCM_SETSHIELD, 0, fRequired)

-- Notifications

BN_CLICKED           = 0
BN_DOUBLECLICKED     = 5 --only if BS_NOTIFY
BN_SETFOCUS          = 6 --only if BS_NOTIFY damn it
BN_KILLFOCUS         = 7 --only if BS_NOTIFY damn it

ffi.cdef[[
typedef struct tagNMBCDROPDOWN
{
	 NMHDR   hdr;
	 RECT    rcButton;
} NMBCDROPDOWN, *LPNMBCDROPDOWN;]]

BCN_FIRST            = ffi.cast('UINT', -1250)
BCN_HOTITEMCHANGE    = (BCN_FIRST + 0x0001)
BCN_DROPDOWN         = (BCN_FIRST + 0x0002)
