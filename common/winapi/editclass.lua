
--oo/controls/edit: standard edit control
--Written by Cosmin Apreutesei. Public Domain.

setfenv(1, require'winapi')
require'winapi.controlclass'
require'winapi.edit'
require'winapi.gdi'

Edit = subclass({
	__style_bitmask = bitmask{
		tabstop = WS_TABSTOP,
		border = WS_BORDER,
		readonly = ES_READONLY,
		multiline = ES_MULTILINE,
		password = ES_PASSWORD,
		autovscroll = ES_AUTOVSCROLL,
		autohscroll = ES_AUTOHSCROLL,
		number = ES_NUMBER,
		dont_hide_selection = ES_NOHIDESEL,
		want_return = ES_WANTRETURN,
		align = {
			left = ES_LEFT,
			right = ES_RIGHT,
			center = ES_CENTER,
		},
		case = {
			normal = 0,
			upper = ES_UPPERCASE,
			lower = ES_LOWERCASE,
		},
	},
	__style_ex_bitmask = bitmask{
		client_edge = WS_EX_CLIENTEDGE,
	},
	__defaults = {
		text = '',
		w = 100, h = 21,
		readonly = false,
		client_edge = true,
		tabstop = true,
		align = 'left',
		case = 'normal',
	},
	__init_properties = {
		'text', 'limit', 'password_char', 'tabstops', 'margins', 'cue',
	},
	__wm_command_handler_names = index{
		on_setfocus = EN_SETFOCUS,
		on_killfocus = EN_KILLFOCUS,
		on_change = EN_CHANGE,
		on_update = EN_UPDATE,
		on_errspace = EN_ERRSPACE,
		on_maxtext = EN_MAXTEXT,
		on_hscroll = EN_HSCROLL,
		on_vscroll = EN_VSCROLL,
		on_align_ltr_ec = EN_ALIGN_LTR_EC,
		on_align_rtl_ec = EN_ALIGN_RTL_EC,
	},
}, Control)

function Edit:__before_create(info, args)
	Edit.__index.__before_create(self, info, args)
	args.class = WC_EDIT
end

function Edit:get_limit() return Edit_GetLimitText(self.hwnd) end
function Edit:set_limit(limit) Edit_SetLimitText(self.hwnd, limit) end

function Edit:get_selection_indices() return {Edit_GetSel(self.hwnd)} end
function Edit:set_selection_indices(t) Edit_SetSel(self.hwnd, unpack(t,1,2)) end
function Edit:select(i,j) Edit_SetSel(self.hwnd, i, j) end

function Edit:get_selection_text(s) return ':(' end --TODO: get_selection_text
function Edit:set_selection_text(s) Edit_ReplaceSel(self.hwnd, s) end

function Edit:get_modified() return Edit_GetModify(self.hwnd) end
function Edit:set_modified(yes) Edit_SetModify(self.hwnd, yes) end

function Edit:scroll_caret() Edit_ScrollCaret(self.hwnd) end

function Edit:get_first_visible_line() return Edit_GetFirstVisibleLine(self.hwnd) end
function Edit:line_from_char(charindex) return Edit_LineFromChar(self.hwnd, charindex) end
function Edit:line_index(lineindex) return Edit_LineIndex(self.hwnd, lineindex) end
function Edit:line_length(lineindex) return Edit_LineLength(self.hwnd, lineindex) end
function Edit:scroll(dv, dh) return Edit_Scroll(self.hwnd, dv, dh) end

function Edit:get_can_undo() return Edit_CanUndo(self.hwnd) end
function Edit:undo() return Edit_Undo(self.hwnd) end
function Edit:clear_undo() return Edit_EmptyUndoBuffer(self.hwnd) end

function Edit:set_password_char(s) Edit_SetPasswordChar(self.hwnd, wcs(s)[0]) end
function Edit:get_password_char() return mbs(ffi.new('WCHAR[1]', Edit_GetPasswordChar(self.hwnd))) end

function Edit:set_tabstops(tabs) Edit_SetTabStops(self.hwnd, tabs) end --stateful

function Edit:get_margins() return {Edit_GetMargins(self.hwnd)} end
function Edit:set_margins(t) Edit_SetMargins(self.hwnd, unpack(t)) end

function Edit:get_cue() return '' or Edit_GetCueBannerText(self.hwnd) end --TODO: returns FALSE
function Edit:set_cue(s, show_when_focused) Edit_SetCueBannerText(self.hwnd, s, show_when_focused) end

function Edit:show_balloon(title, text, TTI) Edit_ShowBalloonTip(self.hwnd, title, text, TTI) end
function Edit:hide_balloon() Edit_HideBalloonTip(self.hwnd) end
