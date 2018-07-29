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

SDL = require "SDL"
SDL_image = package.loadlib("image", "luaopen_SDL_image")!
SDL_ttf = package.loadlib("ttf", "luaopen_SDL_ttf")!

assert SDL != nil
assert SDL_image != nil
assert SDL_ttf != nil

return {
  "SDL": SDL,
  "SDL_image": SDL_image,
  "SDL_ttf": SDL_ttf
}
