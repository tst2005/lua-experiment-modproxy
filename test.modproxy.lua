local modproxy = require "modproxy"
local wrap = modproxy.wrap
local eq = modproxy.eq

local m = {"m"}

local p1 = wrap(m)
local p2 = wrap(m)
print("p1 :", p1)
print("p2 :", p2)
print("p1 == p2 :", p1 == p2)

local rawmod1 = require"mod1"
do
	local mod1 = rawmod1
	print("mod1=", mod1, "hello=", mod1.hello)
end

local vmod1 = wrap(rawmod1)
do
	local mod1 = vmod1
	print("mod1=", mod1, "hello=", mod1.hello)
end

assert( eq(rawmod1, vmod1) == true)
assert( vmod1 ~= rawmod1)

assert( vmod1 == wrap(rawmod1))
assert(rawmod1.hello == vmod1.hello)

