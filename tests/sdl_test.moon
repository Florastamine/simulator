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

term = require "term_wrapper"
glue = require "glue"
ffi  = require "ffi"

eq       = require("test").eq
eq_array = require("test").eq_array

for _, v in pairs {
  {name: "SDL", value: require "SDL"},
  {name: "SDL_image", value: package.loadlib("image", "luaopen_SDL_image")!},
  {name: "SDL_ttf", value: package.loadlib("ttf", "luaopen_SDL_ttf")! },
}
  if eq(type(v.value), "table", true)
    term.info "success: #{v.name}" 
