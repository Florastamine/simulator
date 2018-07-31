
--oo/controls/notifyiconclass: system tray icons
--Written by Cosmin Apreutesei. Public Domain.

setfenv(1, require'winapi')
require'winapi.window'
require'winapi.shellapi'
require'winapi.vobject'
require'winapi.handlelist'

NotifyIcons = HandleList'id' --id -> NotifyIcon map

NotifyIcon = class(VObject)

local last_id = 0 --autoincrement

function NotifyIcon:__init(t)
	self.__info = NOTIFYICONDATA()
	local info = self.__info

	last_id = last_id + 1
	self.id = last_id
	info.id = self.id --for tracking by NotifyIcons.

	info.message = t.message or WM_NOTIFYICON
	info.hwnd = t.window and t.window.hwnd or t.hwnd

	info.icon = t.icon
	info.tip = t.tip
	info.state_HIDDEN = t.visible == false
	info.state_SHAREDICON = t.icon_shared
	info.info = t.info
	info.info_title = t.info_title
	info.info_flags = t.info_flags or 0
	info.info_timeout = t.info_timeout or 0

	Shell_NotifyIcon(NIM_ADD, self.__info)

	NotifyIcons:add(self)
end

function NotifyIcon:free()
	NotifyIcons:remove(self)
	Shell_NotifyIcon(NIM_DELETE, self.__info)
	self.id = nil
end

NotifyIcon.__wm_handler_names = index{
	on_mouse_move = WM_MOUSEMOVE,
	on_lbutton_double_click = WM_LBUTTONDBLCLK,
	on_lbutton_down = WM_LBUTTONDOWN,
	on_lbutton_up = WM_LBUTTONUP,
	on_mbutton_double_click = WM_MBUTTONDBLCLK,
	on_mbutton_down = WM_MBUTTONDOWN,
	on_mbutton_up = WM_MBUTTONUP,
	on_rbutton_double_click = WM_RBUTTONDBLCLK,
	on_rbutton_down = WM_RBUTTONDOWN,
	on_rbutton_up = WM_RBUTTONUP,
	on_xbutton_double_click = WM_XBUTTONDBLCLK,
	on_xbutton_down = WM_XBUTTONDOWN,
	on_xbutton_up = WM_XBUTTONUP,
}

function NotifyIcon:WM_NOTIFYICON(WM)
	local wm_name = WM_NAMES[WM]
	if self[wm_name] then
		if self[wm_name](self) ~= nil then
			return
		end
	end
	local handler_name = self.__wm_handler_names[WM]
	if self[handler_name] then
		self[handler_name](self)
	end
end

function NotifyIcon:get_visible() --Vista+
	return not self.__info.state_HIDDEN
end

function NotifyIcon:set_visible(visible) --Vista+
	self.__info.state_HIDDEN = not visible
	Shell_NotifyIcon(NIM_MODIFY, self.__info)
end

function NotifyIcon.__get_vproperty(class, self, k)
	if NOTIFYICONDATA.fields[k] then --publish info fields individually
		return self.__info[k]
	else
		return NotifyIcon.__index.__get_vproperty(class, self, k)
	end
end

function NotifyIcon.__set_vproperty(class, self, k, v)
	if NOTIFYICONDATA.fields[k] then --publish info fields individually
		self.__info[k] = v
		Shell_NotifyIcon(NIM_MODIFY, self.__info)
	else
		NotifyIcon.__index.__set_vproperty(class, self, k, v)
	end
end
