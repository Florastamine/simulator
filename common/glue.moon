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

-- This is a partial conversion in MoonScript of the glue supplementary library, 
-- originally written by the luapower project. A few (key) differences compared to
-- the original version are noted below:
-- * table.count() no longer takes into account the upper limit, and the argument was 
--   left out for compatibility's sake.
-- * string.trim() got the original trim2() implementation from the Lua wiki.

ffi = require "ffi"

round = (x, p = 1) ->
  math.floor(x / p + .5) * p

floor = (x, p = 1) ->
	math.floor(x / p) * p

clamp = (x, x0, x1) ->
  math.min(math.max(x, x0), x1)

indexof = (v, t) ->
	for i = 1, #t
		if t[i] == v
			return i

index = (t) ->
	new = {}
	for k, v in pairs t do new[v] = k
	return new

merge = (dt, ...) ->
	for i = 1, select('#',...)
		t = select(i, ...)
		if t != nil
			for k,v in pairs t
				if rawget(dt, k) == nil then dt[k] = v
	return dt

append = (dt, ...) ->
	for i = 1, select('#',...)
		dt[#dt + 1] = select(i, ...)
	return dt

update = (dt, ...) ->
	for i = 1, select('#', ...)
		t = select(i, ...)
		if t != nil
			for k, v in pairs t do dt[k] = v
	return dt

extend = (dt, ...) ->
	for j = 1, select('#', ...)
		t = select(j, ...)
		if t != nil
			for i = 1, #t do dt[#dt + 1] = t[i]
	return dt

lerp = (x, x0, x1, y0, y1) ->
  y0 + (x-x0) * ((y1-y0) / (x1 - x0))

pack = (...) ->
  {n: select('#', ...), ...}

unpack = (t, i = 1, j) ->
  unpack(t, i, j or t.n or #t)

count = (t, _) ->
	n = 0
	for _ in pairs t do n += 1
	n

tohex = (s, upper) ->
	if type(s) == 'number'
		return (upper and '%08.8X' or '%08.8x')\format(s)

	if upper
		return s\gsub('.', (c) -> ('%02X')\format(c\byte()))
	else
		return s\gsub('.', (c) -> ('%02x')\format(c\byte()))

fromhex = (s) ->
	if #s % 2 == 1
		return fromhex('0' .. s)

	s\gsub('..', (cc) -> string.char(tonumber(cc, 16)))

keys = (t, cmp) ->
	dt = {}
	for k in pairs t
		dt[#dt+1]=k
	if cmp
		table.sort(dt)
	elseif cmp
		table.sort(dt, cmp)
	return dt

trim = (s) ->
	s\match "^%s*(.-)%s*$"

escape = (s, mode) ->
	s = s\gsub('%%','%%%%')\gsub('%z','%%z')\gsub('([%^%$%(%)%.%[%]%*%+%-%?])', '%%%1')
	if mode == '*i' s = s\gsub('[%a]', (c) -> '[%s%s]'\format(c\lower!, c\upper!))
	s

binsearch = (v, t, cmp = (a, b) -> a < b) ->
  n = #t
  return nil if n == 0
  if n == 1
    return not cmp(t[1], v) and 1 or nil
  
  lo, hi = 1, n
  while lo < hi
    mid = math.floor(lo + (hi - lo) / 2)
    if cmp t[mid], v
      lo = mid + 1
      if lo == n and cmp t[lo], v
        return nil
    else
      hi = mid
  return lo

ffi.cdef[[
	void* malloc (size_t size);
	void  free   (void*);
]]

free = (cdata) ->
	ffi.gc(cdata, nil)
	ffi.C.free(cdata)

malloc = (ctype, size) ->
	if type(ctype) == 'number'
		ctype, size = 'char', ctype

	ctype = ffi.typeof(ctype or 'char')
	ctype = size and ffi.typeof('$(&)[$]', ctype, size) or ffi.typeof('$&', ctype)
	bytes = ffi.sizeof(ctype)
	data  = ffi.cast(ctype, ffi.C.malloc(bytes))
	assert(data != nil, 'out of memory')
	ffi.gc(data, free)
	return data

autoload = (t, k, v) ->
	mt = getmetatable(t) or {}
	if not mt.__autoload
		if mt.__index
			error '__index already assigned for something else'
		submodules = {}
		mt.__autoload = submodules
		mt.__index = (t, k) ->
			if submodules[k]
				if type(submodules[k]) == 'string'
					require(submodules[k]) --module
				else
					submodules[k](k) --custom loader
				submodules[k] = nil --prevent loading twice
			return rawget(t, k)
		setmetatable(t, mt)
	if type(k) == 'table'
		update(mt.__autoload, k) --multiple key -> module associations.
	else
		mt.__autoload[k] = v --single key -> module association.
	return t

_assert = (v, err = 'assertion failed!', ...) ->
	return v if v
	if select('#', ...) > 0
		err = string.format(err, ...)
	error(err, 2)

fpcall = (f, ...) ->
	fint, errt = {}, {}
	err = (e) ->
		for i = #errt, 1, -1 do errt[i](e)
		for i = #fint, 1, -1 do fint[i]()
		tostring(e) .. '\n' .. debug.traceback()
  
	pass = (ok, ...) ->
		if ok
			for i = #fint, 1, -1 do fint[i]()
		return ok, ...
	return pass(xpcall(f, err, ((f) -> fint[#fint + 1] = f), ((f) -> errt[#errt + 1] = f), ...))

assert_fpcall = (ok, ...) ->
	if not ok then error(..., 2)
	return ...

fcall = (...) ->
	return assert_fpcall fpcall(...)

pcall = (f, ...) ->
	return xpcall(f, ((e) -> tostring(e) .. '\n' .. debug.traceback()), ...)

return {
  math: {
    round: round,
    snap: round,
    clamp: clamp,
    floor: floor
  },
  
  string: {
    tohex: tohex,
    fromhex: fromhex,
    trim: trim,
    escape: escape
  },
  
  table: {
    merge: merge,
    append: append,
    extend: extend,
    keys: keys,
    index: index,
    indexof: indexof,
    update: update,
    count: count
  },
  
  algorithm: {
    binsearch: binsearch,
  }
  
  malloc: malloc,
  free: free,
  autoload: autoload,
  assert: _assert,
  fcall: fcall,
  pcall: pcall
}
