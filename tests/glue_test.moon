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

testAPI = () ->
  tests = {
    {
      name: "round",
      list: {
        { desc: "glue.math.round(1.2) == 1",         value: glue.math.round(1.2),      expect: 1 },
        { desc: "glue.math.round(-1.2) == -1",       value: glue.math.round(-1.2),     expect: -1 },
        { desc: "glue.math.round(1.5) == 2",         value: glue.math.round(1.5),      expect: 2 },
        { desc: "glue.math.round(2^52+.49) == 2^52", value: glue.math.round(2^52+.49), expect: 2^52 },
      },
      method: eq
    },
    
    {
      name: "glue.math.clamp",
      list: {
        { desc: "glue.math.clamp(3, 2, 5) == 3", value: glue.math.clamp(3, 2, 5), expect: 3 },
        { desc: "glue.math.clamp(1, 2, 5) == 2", value: glue.math.clamp(1, 2, 5), expect: 2 },
        { desc: "glue.math.clamp(6, 2, 5) == 5", value: glue.math.clamp(6, 2, 5), expect: 5 }
      },
      method: eq
    },
    
    {
      name: "glue.math.snap",
      list: {
        { desc: "glue.math.snap(7, 5) == 5",     value: glue.math.snap(7, 5),    expect: 5 },
        { desc: "glue.math.snap(7.5, 5) == 10",  value: glue.math.snap(7.5, 5),  expect: 10 },
        { desc: "glue.math.snap(-7.5, 5) == -5", value: glue.math.snap(-7.5, 5), expect: -5 }
      },
      method: eq
    },
    
    {
      name: "glue.table.extend",
      list: {
        {
          desc: "glue.table.extend({5,6,8}, {1,2}, {'b','x'}) == {5,6,8,1,2,'b','x'}",
          value: glue.table.extend({5,6,8}, {1,2}, {'b','x'}),
          expect: {5,6,8,1,2,'b','x'}
        }
      },
      method: eq_array
    },
    
    {
      name: "glue.table.merge",
      list: {
        {
          desc: "glue.table.merge({a: 1,b: 2,c: 3}, {d: 'add',b: 'overwrite'}, {b: 'over2'}) == {a: 1,b: 2,c: 3,d: 'add'}",
          value: glue.table.merge({a: 1,b: 2,c: 3}, {d: 'add',b: 'overwrite'}, {b: 'over2'}),
          expect: {a: 1,b: 2,c: 3,d: 'add'}
        }
      },
      method: eq_array
    },
    
    {
      name: "glue.table.update",
      list: {
        {
          desc: "glue.table.update({a: 1,b: 2,c: 3}, {d: 'add',b: 'overwrite'}, {b:'over2'}) == {a:1,b:'over2',c:3,d:'add'}",
          value: glue.table.update({a: 1,b: 2,c: 3}, {d: 'add',b: 'overwrite'}, {b:'over2'}),
          expect: {a:1,b:'over2',c:3,d:'add'}
        },
      },
      method: eq_array
    },
    
    {
      name: "glue.table.keys",
      list: {
        {
          desc: "glue.table.keys({a: 5,b: 7,c: 3}, true) == {'a','b','c'}",
          value: glue.table.keys({a: 5,b: 7,c: 3}, true),
          expect: {'a','b','c'}
        },
        {
          desc: "glue.table.keys({'a','b','c'}, true) == {1,2,3}",
          value: glue.table.keys({'a','b','c'}, true),
          expect: {1,2,3}
        }
      },
      method: eq_array
    },
    
    {
      name: "glue.table.count",
      list: {
        {
          desc: "glue.table.count({'0': 1, 2, 3, 'a': 4}) == 4",
          value: glue.table.count {'0': 1, 2, 3, 'a': 4},
          expect: 4
        },
        {
          desc: "glue.table.count({}), 0",
          value: glue.table.count {},
          expect: 0
        }
      },
      method: eq
    },
    
    {
      name: "glue.string.tohex",
      list: {
        {
          desc: "glue.string.tohex(0xdeadbeef01) == 'deadbeef01'",
          value: glue.string.tohex(0xdeadbeef01),
          expect: 'deadbeef01'
        },
        {
          desc: "glue.string.tohex(0xdeadbeef02, true) =='DEADBEEF02'",
          value: glue.string.tohex(0xdeadbeef02, true),
          expect: 'DEADBEEF02'
        },
        {
          desc: "glue.string.tohex('\xde\xad\xbe\xef\x01') == 'deadbeef01'",
          value: glue.string.tohex('\xde\xad\xbe\xef\x01'),
          expect: 'deadbeef01'
        },
        {
          desc: "glue.string.tohex('\xde\xad\xbe\xef\x02', true) == 'DEADBEEF02'}",
          value: glue.string.tohex('\xde\xad\xbe\xef\x02', true),
          expect: 'DEADBEEF02'
        }
      },
      method: eq
    },
    
    {
      name: "glue.string.fromhex",
      list: {
        {
          desc: "glue.string.fromhex('deadbeef01') == '\xde\xad\xbe\xef\x01'",
          value: glue.string.fromhex('deadbeef01'),
          expect: '\xde\xad\xbe\xef\x01'
        },
        {
          desc: "glue.string.fromhex('DEADBEEF02') == '\xde\xad\xbe\xef\x02'",
          value: glue.string.fromhex('DEADBEEF02'),
          expect: '\xde\xad\xbe\xef\x02'
        },
        {
          desc: "glue.string.fromhex('5') == '\5'",
          value: glue.string.fromhex('5'),
          expect: '\5'
        },
        {
          desc: "glue.string.fromhex('5ff') == '\5\xff'",
          value: glue.string.fromhex('5ff'),
          expect: '\5\xff'
        }
      },
      method: eq
    },
    
    {
      name: "glue.string.trim",
      list: {
        {
          desc: "glue.string.trim('  a  d ') == 'a  d'",
          value: glue.string.trim('  a  d '),
          expect: 'a  d'
        }
      },
      method: eq
    },
    
    {
      name: "glue.table.index",
      list: {
        desc: "glue.table.index({a: 3,b: 5,c: 7}), {[3]: 'a',[5]: 'b',[7]: 'c'}",
        value: glue.table.index({a: 3,b: 5,c: 7}),
        expect: {[3]: 'a',[5]: 'b',[7]: 'c'}
      },
      method: eq_array
    },
    
    {
      name: "glue.table.indexof",
      list: {
        {
          desc: "glue.table.indexof('b', {'a', 'b', 'c'}), 2",
          value: glue.table.indexof('b', {'a', 'b', 'c'})
          expect: 2
        },
        {
          desc: "glue.table.indexof('b', {'x', 'y', 'z'}), nil",
          value: glue.table.indexof('b', {'x', 'y', 'z'}),
          expect: nil
        }
      },
      method: eq
    },
    
    {
      name: "glue.algorithm.binsearch",
      list: {
        {
          desc: "glue.algorithm.binsearch(10, {}) == nil",
          value: glue.algorithm.binsearch(10, {}),
          expect: nil
        },
        {
          desc: "glue.algorithm.binsearch(11, {11}) == 1",
          value: glue.algorithm.binsearch(11, {11}),
          expect: 1
        },
        {
          desc: "glue.algorithm.binsearch(12, {11}) == nil",
          value: glue.algorithm.binsearch(12, {11}),
          expect: nil
        },
        {
          desc: "glue.algorithm.binsearch(12, {11, 13}) == 2",
          value: glue.algorithm.binsearch(12, {11, 13}),
          expect: 2
        },
        {
          desc: "glue.algorithm.binsearch(13, {11, 13}) == 2",
          value: glue.algorithm.binsearch(13, {11, 13}),
          expect: 2
        },
        {
          desc: "glue.algorithm.binsearch(11, {11, 13}) == 1",
          value: glue.algorithm.binsearch(11, {11, 13}),
          expect: 1
        },
        {
          desc: "glue.algorithm.binsearch(14, {11, 13}) == nil",
          value: glue.algorithm.binsearch(14, {11, 13}),
          expect: nil
        },
        {
          desc: "glue.algorithm.binsearch(10, {11, 13}) == 1",
          value: glue.algorithm.binsearch(10, {11, 13}),
          expect: 1
        },
        {
          desc: "glue.algorithm.binsearch(14, {11, 13, 15}) == 3",
          value: glue.algorithm.binsearch(14, {11, 13, 15}),
          expect: 3
        },
        {
          desc: "glue.algorithm.binsearch(12, {11, 13, 15}) == 2",
          value: glue.algorithm.binsearch(12, {11, 13, 15}),
          expect: 2
        },
        {
          desc: "glue.algorithm.binsearch(10, {11, 13, 15}) == 1",
          value: glue.algorithm.binsearch(10, {11, 13, 15}),
          expect: 1
        },
        {
          desc: "glue.algorithm.binsearch(16, {11, 13, 15}) == nil",
          value: glue.algorithm.binsearch(16, {11, 13, 15}),
          expect: nil
        }
      },
      method: eq
    },
    
    {
      name: "glue.table.append",
      list: {
        {
          desc: "glue.table.append({1,2,3}, 5,6) == {1,2,3,5,6}",
          value: glue.table.append({1,2,3}, 5,6),
          expect: {1,2,3,5,6}
        }
      },
      method: eq_array
    },
    
    {
      name: "glue.string.escape",
      list: {
        {
          desc: "glue.string.escape('^{(.-)}$') == '%^{%(%.%-%)}%$'",
          value: glue.string.escape('^{(.-)}$'),
          expect: '%^{%(%.%-%)}%$'
        },
        {
          desc: "glue.string.escape('%\0%') == '%%%z%%'",
          value: glue.string.escape('%\0%'),
          expect: '%%%z%%'
        }
      },
      method: eq
    }
  }

  term.info "Performing library API tests"
  for k, v in pairs tests
    print "Test #{k} (#{v.name})"
    for q, w in ipairs v.list
      io.stdout\write "\t#{q} (#{w.desc}): "
      if v.method(w.value, w.expect, true) == true
        term.info "success"
      else
        term.panic "failed"

testFFI = () ->
  term.info "Performing FFI tests (malloc()/free())"
  
  tests = {
    { bytes: 400, ctype: 'int32_t', size: 100 },
    { bytes: 4, ctype: 'int32_t', size: 1 },
    { bytes: 200, ctype: 'int16_t', size: 100 },
    { bytes: 100, ctype: nil, size: 100 }
  }
  
  for _, v in pairs tests
    io.stdout\write "------------------------------------------\n"
    v.data = glue.malloc(v.ctype, v.size)
    size, bytes = ffi.sizeof(v.data), v.bytes
    io.stdout\write "\teq #{size} #{v.bytes}: "
    if eq size, v.bytes
      term.info "success"
    else
      term.panic "failed"
    
    io.stdout\write "\tsize: #{v.size}\n"
    
    if v.size
      io.stdout\write "\teq(ffi.typeof(#{v.data}), ffi.typeof('$(&)[$]', ffi.typeof(#{v.ctype}), #{v.size})): "
      if eq(ffi.typeof(v.data), ffi.typeof('$(&)[$]', ffi.typeof(v.ctype or 'char'), v.size))
        term.info "success"
      else
        term.panic "failed"
    else
      io.stdout\write "\teq(ffi.typeof(#{v.data}), ffi.typeof('$&', ffi.typeof(#{v.ctype})))"
      if eq(ffi.typeof(v.data), ffi.typeof('$&', ffi.typeof(v.ctype or 'char')))
        term.info "success"
      else
        term.panic "failed"

    glue.free(v.data)
    io.stdout\write "------------------------------------------\n"

testAutoload = () ->
  term.info "Testing glue.autoload()"
  
  M, x, y, z, t = {}, 0, 0, 0, 0
  glue.autoload(M, 'x', () -> x += 1)
  glue.autoload(M, 'y', () -> y += 1)
  glue.autoload(M, {'z': () -> z += 1, 'p': () -> t += 1})
  M.x, M.x, M.y, M.y, M.z, M.z, M.p, M.p
  
  if eq(x, 1, true) and eq(y, 1, true) and eq(z, 1, true) and eq(t, 1, true)
    term.info "success" 
  else
    term.panic "failed"

testAPI!
testFFI!
testAutoload!