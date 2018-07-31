
--oo/controls/checkbox: checkbox control
--Written by Cosmin Apreutesei. Public Domain.

setfenv(1, require'winapi')
require'winapi.basebuttonclass'

CheckBox = subclass({
	__style_bitmask = bitmask{
		box_align = {
			left = 0,
			right = BS_LEFTTEXT,
		},
		pushlike = BS_PUSHLIKE,
		type = { --TODO: make two orthogonal properties out of these: autocheck and allow_grayed
			twostate = BS_CHECKBOX,
			threestate = BS_3STATE,
			twostate_autocheck = BS_AUTOCHECKBOX,
			threestate_autocheck = BS_AUTO3STATE,
		},
	},
	__defaults = {
		type = 'twostate_autocheck',
		text = 'Option',
		w = 100, h = 24,
	},
	__init_properties = {
		'checked'
	},
}, BaseButton)

local button_states = {
	[false] = BST_UNCHECKED,
	[true] = BST_CHECKED,
	indeterminate = BST_INDETERMINATE,
}
local button_state_names = index(button_states)
function CheckBox:set_checked(checked)
	Button_SetCheck(self.hwnd, button_states[checked])
end
function CheckBox:get_checked()
	return button_state_names[bit.band(Button_GetCheck(self.hwnd), 3)]
end

