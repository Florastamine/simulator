
--oo/controls/radiobutton: radio button control
--Written by Cosmin Apreutesei. Public Domain.

setfenv(1, require'winapi')
require'winapi.basebuttonclass'

RadioButton = subclass({
	__style_bitmask = bitmask{
		box_align = {
			left = 0,
			right = BS_LEFTTEXT,
		},
		pushlike = BS_PUSHLIKE,
		autocheck = {
			[false] = BS_RADIOBUTTON,
			[true] = BS_AUTORADIOBUTTON,
		},
	},
	__defaults = {
		autocheck = true,
		text = 'Option',
		w = 100, h = 24,
	},
	__init_properties = {
		'checked'
	},
}, BaseButton)

function RadioButton:set_dontclick(dontclick) --Vista+
	Button_SetDontClick(self.hwnd, dontclick)
end

local button_states = {
	[false] = BST_UNCHECKED,
	[true] = BST_CHECKED,
}
local button_state_names = index(button_states)
function RadioButton:set_checked(checked)
	Button_SetCheck(self.hwnd, button_states[checked])
end
function RadioButton:get_checked()
	return button_state_names[bit.band(Button_GetCheck(self.hwnd), 3)]
end
