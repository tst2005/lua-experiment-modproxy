local hacky = require "hacky"

local a = {"hello"}
local b = {"world"}
print("a", a)
print("b", b)
print("a==b", a==b)
print("a[1]", a[1])
print("b[1]", b[1])

do
local a = hacky(a)
local b = hacky(b)
b[1]="bb"
print("hacky...")
print("a", a)
print("b", b)
print("a==b", a==b)

local mta = getmetatable(a)
local mtb = getmetatable(b)
print("mt(a) mt(b)", mta, mtb)
print("mta.__modproxy", mta.__modproxy)

local aa = hacky(a)
print("aa", aa)
print("aa==a", aa==a)

print("a[1]", a[1])
print("b[1]", b[1])
end

print(a, "a[1]", a[1])
print(b, "b[1]", b[1])
--[[
a       table: 0x3ce6300
b       table: 0x3ce6350
a==b    false
a[1]    hello
b[1]    world
hacky...
a       table: 0x3cf1150
b       table: 0x3cf11a0
a==b    true
a[1]    hello
b[1]    world
]]--
