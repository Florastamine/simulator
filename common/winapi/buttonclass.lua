
--oo/controls/button: push-button control
--Written by Cosmin Apreutesei. Public Domain.

setfenv(1, require'winapi')
require'winapi.basebuttonclass'

Button = {
	__style_bitmask = bitmask{
		default = BS_DEFPUSHBUTTON,
	},
	__defaults = {
		text = '&OK',
		w = 100, h = 24,
		text_margin = {20,5}, --applied when autosize = true
	},
	__init_properties = {
		'text_margin', 'pushed', 'autosize'
	},
}

subclass(Button, BaseButton)

function Button:__before_create(info, args)
	Button.__index.__before_create(self, info, args)
	args.style = bit.bor(args.style, BS_PUSHBUTTON)
end

function Button:get_ideal_size(w, h) --fixing w or h work on Vista+
	local size = SIZE()
	size.w = w or 0
	size.h = h or 0
	size = Button_GetIdealSize(self.hwnd, size)
	return {w = size.w, h = size.h}
end

function Button:__checksize()
	if self.autosize then
		local size = self.ideal_size
		self:resize(size.w, size.h)
	end
end

function Button:set_autosize(yes)
	self:__checksize()
end

function Button:set_text_margin(margin) --only works when autosize = true
	local rect = RECT()
	rect.x1 = margin.w or margin[1]
	rect.y1 = margin.h or margin[2]
	Button_SetTextMargin(self.hwnd, rect)
	self:__checksize()
end
function Button:get_text_margin()
	local rect = Button_GetTextMargin(self.hwnd)
	return {w = rect.x1, h = rect.y1}
end

function Button:set_pushed(pushed) Button_SetState(self.hwnd, pushed) end
function Button:get_pushed() return Button_GetState(self.hwnd) end
