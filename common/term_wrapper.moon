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

term = require "term"

assert term != nil

term.black       = 0
term.blue        = 1
term.green       = 2
term.cyan        = 3
term.red         = 4
term.purple      = 5
term.brown       = 6
term.lightGray   = 7
term.gray        = 8
term.lightBlue   = 9
term.lightGreen  = 10
term.lightCyan   = 11
term.lightRed    = 12
term.magenta     = 13
term.yellow      = 14
term.white       = 15
term.old         = 0

_print = (message, color = term.lightGreen, action = () ->) ->
  term.old = term.getTextColor()
  term.setTextColor(color)
  io.stdout\write(message)
  term.setTextColor(term.old)
  action!

return {
  panic: (message) ->
    _print(string.format("[%s] %s\n", os.date(), message), term.red, os.exit)
  
  info: (message) ->
    _print(string.format("[%s] %s\n", os.date(), message))
}
