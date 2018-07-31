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

-- Note: Don't define time_t because it's 64bit in windows but 32bit in mingw: use explicit types!
-- Note: SIZE has w and h unioned to cx and cy and these are the ones used throughout.
-- Note: RECT has x1, y1, x2, y2 unioned to left, right, top, bottom and these are the ones used throughout.

export CreateMutex

setfenv 1, require "winapi"
require "winapi.winbase"

ffi.cdef [[
HANDLE CreateMutexW(
	LPSECURITY_ATTRIBUTES lpMutexAttributes,
	BOOL                  bInitialOwner,
	LPCWSTR               lpName
);]]

ERROR_ACCESS_DENIED = 0x5
ERROR_ALREADY_EXISTS = 0xB7
errors = {
	[ERROR_ACCESS_DENIED]: 'access_denied',
	[ERROR_ALREADY_EXISTS]: 'already_exists',
}

CreateMutex = (sec, initial_owner, name) ->
	h = checkh(C.CreateMutexW(sec, initial_owner, wcs name))
	err = GetLastError!
	return h if err == 0
	return h, errors[err] or err
