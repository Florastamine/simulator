
--proc/controls/treeview: standard treeview control
--Written by Cosmin Apreutesei. Public Domain.

setfenv(1, require'winapi')
require'winapi.window'
require'winapi.comctl'

do return end -- TODO: make this work again with the new struct spec

InitCommonControlsEx(ICC_TREEVIEW_CLASSES)

--creation

WC_TREEVIEW = "SysTreeView32"

TVS_HASBUTTONS           = 0x0001
TVS_HASLINES             = 0x0002
TVS_LINESATROOT          = 0x0004
TVS_EDITLABELS           = 0x0008
TVS_DISABLEDRAGDROP      = 0x0010
TVS_SHOWSELALWAYS        = 0x0020
TVS_RTLREADING           = 0x0040
TVS_NOTOOLTIPS           = 0x0080
TVS_CHECKBOXES           = 0x0100
TVS_TRACKSELECT          = 0x0200
TVS_SINGLEEXPAND         = 0x0400
TVS_INFOTIP              = 0x0800
TVS_FULLROWSELECT        = 0x1000
TVS_NOSCROLL             = 0x2000
TVS_NONEVENHEIGHT        = 0x4000
TVS_NOHSCROLL            = 0x8000  -- TVS_NOSCROLL overrides this

TVS_EX_MULTISELECT           = 0x0002
TVS_EX_DOUBLEBUFFER          = 0x0004
TVS_EX_NOINDENTSTATE         = 0x0008
TVS_EX_RICHTOOLTIP           = 0x0010
TVS_EX_AUTOHSCROLL           = 0x0020
TVS_EX_FADEINOUTEXPANDOS     = 0x0040
TVS_EX_PARTIALCHECKBOXES     = 0x0080
TVS_EX_EXCLUSIONCHECKBOXES   = 0x0100
TVS_EX_DIMMEDCHECKBOXES      = 0x0200
TVS_EX_DRAWIMAGEASYNC        = 0x0400

TREEVIEW_DEFAULTS = {
	class = WC_TREEVIEW,
	style = bit.bor(WS_CHILD, WS_VISIBLE, TVS_HASBUTTONS, TVS_HASLINES, TVS_LINESATROOT),
	style_ex = bit.bor(WS_EX_CLIENTEDGE),
	x = 10, y = 10,
	w = 200, h = 100,
}

function CreateTreeView(info)
	info = update({}, TREEVIEW_DEFAULTS, info)
	return CreateWindow(info)
end

--commands

TVIF_TEXT                = 0x0001
TVIF_IMAGE               = 0x0002
TVIF_PARAM               = 0x0004
TVIF_STATE               = 0x0008
TVIF_HANDLE              = 0x0010
TVIF_SELECTEDIMAGE       = 0x0020
TVIF_CHILDREN            = 0x0040
TVIF_INTEGRAL            = 0x0080
TVIF_STATEEX             = 0x0100
TVIF_EXPANDEDIMAGE       = 0x0200

TVIS_SELECTED            = 0x0002
TVIS_CUT                 = 0x0004
TVIS_DROPHILITED         = 0x0008
TVIS_BOLD                = 0x0010
TVIS_EXPANDED            = 0x0020
TVIS_EXPANDEDONCE        = 0x0040
TVIS_EXPANDPARTIAL       = 0x0080
TVIS_OVERLAYMASK         = 0x0F00
TVIS_STATEIMAGEMASK      = 0xF000
TVIS_USERMASK            = 0xF000

TVIS_EX_FLAT             = 0x0001
TVIS_EX_DISABLED         = 0x0002
TVIS_EX_ALL              = 0x0002

TVI_ROOT                 = ffi.cast('UINT', -0x10000)
TVI_FIRST                = ffi.cast('UINT', -0x0FFFF)
TVI_LAST                 = ffi.cast('UINT', -0x0FFFE)
TVI_SORT                 = ffi.cast('UINT', -0x0FFFD)

TV_FIRST = 0x1100

ffi.cdef[[
struct _TREEITEM;
typedef struct _TREEITEM *HTREEITEM;

typedef struct tagTVITEMEXW {
	 UINT      mask;
	 HTREEITEM hItem;
	 UINT      _state;
	 UINT      _stateMask;
	 LPWSTR    pszText;
	 int       cchTextMax;
	 int       iImage;
	 int       iSelectedImage;
	 int       cChildren;
	 LPARAM    lParam;
	 int       iIntegral;
	 UINT      uStateEx;
	 HWND      hwnd;
	 int       iExpandedImage;
	 int       iReserved;
} TVITEMEXW, *LPTVITEMEXW;

typedef struct tagTVINSERTSTRUCTW {
	 HTREEITEM hParent;
	 HTREEITEM hInsertAfter;
	 TVITEMEXW itemex;
} TVINSERTSTRUCTW, *LPTVINSERTSTRUCTW;
]]

TVITEMEXW = struct{
	ctype = 'TVITEMEXW', mask = 'mask',
	fields = mfields{
		'item', 'hItem', 0, pass,
		'__state', '_state', TVIF_STATE, flags,
		'__stateMask', '_stateMask', TVIF_STATE, flags,
		'text', 'pszText', TVIF_TEXT, wcs,
		'image', 'iImage', TVIF_IMAGE, pass,
		'selected_image', 'iSelectedImage', TVIF_SELECTEDIMAGE, pass,
		'children_count', 'cChildren', TVIF_CHILDREN, pass,
		'integral', 'iIntegral', TVIF_INTEGRAL, pass,
		'state_ex', 'uStateEx', TVIF_STATEEX, pass,
		'handle', 'hwnd', TVIF_HANDLE, pass,
		'expanded_image', 'iExpandedImage', TVIF_EXPANDEDIMAGE, pass,
	},
	bitfields = {
		state = {'__state', '__stateMask', 'TVIS'},
	}
}

TVINSERTSTRUCTW = struct{
	ctype = 'TVINSERTSTRUCTW',
	fields = sfields{
		'parent', 'hParent', 'HTREEITEM',
		'insert_after', 'hInsertAfter', 'HTREEITEM',
		'item', 'itemex', TVITEMEXW,
	}
}

TVM_INSERTITEMW          = (TV_FIRST + 50)
TVM_GETITEMW             = (TV_FIRST + 62)
TVM_SETITEMW             = (TV_FIRST + 63)
TVM_DELETEITEM           = (TV_FIRST + 1)
TVM_EXPAND               = (TV_FIRST + 2)
TVM_GETIMAGELIST         = (TV_FIRST + 8)
TVM_SETIMAGELIST         = (TV_FIRST + 9)

function TreeView_InsertItem(tv, item)
	 item = TVINSERTSTRUCTW(item)
	 return ffi.cast('HTREEITEM', checkh(SNDMSG(tv, TVM_INSERTITEMW, 0,
							ffi.cast('LPTVINSERTSTRUCTW', item))))
end

function TreeView_GetItem(tv, item)
	item = TVITEMEXW(item)
	checknz(SNDMSG(TVM_GETITEM, 0, ffi.cast('LPTVITEMEXW', item)))
	return item
end

function TreeView_SetItem(hwnd, item)
	checknz(SNDMSG(TVM_SETITEM, 0, ffi.cast('LPTVITEMEXW', TVITEMEXW(item))))
end

function TreeView_DeleteItem(tv, item)
	return checkpoz(SNDMSG(tv, TVM_DELETEITEM, 0, item))
end

function TreeView_DeleteAllItems(tv)
	return TreeView_DeleteItem(tv, TVI_ROOT)
end

TVE_COLLAPSE             = 0x0001
TVE_EXPAND               = 0x0002
TVE_TOGGLE               = 0x0003
TVE_EXPANDPARTIAL        = 0x4000
TVE_COLLAPSERESET        = 0x8000

function TreeView_Expand(tv, item, code)
	return checkpoz(SNDMSG(tv, TVM_EXPAND, code, item))
end

TVSIL_NORMAL = 0
TVSIL_STATE  = 2

function TreeView_GetImageList(tv, TVSIL)
	return checkpoz(SNDMSG(tv, TVM_GETIMAGELIST, TVSIL))
end

function TreeView_SetImageList(tv, TVSIL, iml)
	return checkh(SNDMSG(tv, TVM_SETIMAGELIST, TVSIL, iml))
end
