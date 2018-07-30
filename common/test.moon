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

eq = (expr, expect, silent = false) ->
  ok = expr == expect
  term.panic "err" if ok != true and silent == false
  
  ok

eq_array = (t1, t2, silent = false) ->
  ok = false
  for k1, v1 in pairs t1
    ok = eq t2[k1], v1, silent
  
  ok

return {
  eq: eq,
  eq_array: eq_array
}
