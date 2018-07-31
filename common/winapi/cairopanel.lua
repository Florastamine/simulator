
--oo/controls/cairopanel: cairo pixman surface control
--Written by Cosmin Apreutesei. Public Domain.

--NOTE: this implementation doesn't rely on cairo's win32 extensions,
--so it works with a cairo binary that wasn't compiled with them.

local ffi = require'ffi'
local bit = require'bit'
local cairo = require'cairo'
setfenv(1, require'winapi')
require'winapi.bitmappanel'

CairoPanel = class(BitmapPanel)

function CairoPanel:on_bitmap_create(bitmap)
	self.__cairo_surface = cairo.image_surface(bitmap)
	self:on_cairo_create_surface(self.__cairo_surface)
	self.__cairo_context = self.__cairo_surface:context()
end

function CairoPanel:on_bitmap_free(bitmap)
	self.__cairo_context:free()
	self.__cairo_context = nil
	self:on_cairo_free_surface(self.__cairo_surface)
	self.__cairo_surface:free()
	self.__cairo_surface = nil
end

function CairoPanel:on_bitmap_paint(bitmap)
	self:on_cairo_paint(self.__cairo_context, self.__cairo_surface)
end

function CairoPanel:on_cairo_create_surface(surface) end
function CairoPanel:on_cairo_free_surface(surface) end
function CairoPanel:on_cairo_paint(context, surface) end

return CairoPanel
