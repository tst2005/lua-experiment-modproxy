local modproxy = require "modproxy"
local wrap = modproxy
local unwrap = modproxy.unwrap
--local eq = modproxy.eq

local m = {"m"}

local p1 = wrap(m)
local p2 = wrap(m)
print("p1 :", p1)
print("p2 :", p2)
print("p1 == p2 :", p1 == p2)

local rawmod1 = require"mod1"
do
	local mod1 = rawmod1
	assert( mod1() == "mod1")
	print("mod1=", mod1, "hello=", mod1.hello)
end

local vmod1 = wrap(rawmod1)
do
	local mod1 = vmod1
	assert( mod1() == "mod1")
	print("mod1=", mod1, "hello=", mod1.hello)
end

--assert( eq(rawmod1, vmod1) == true)
assert( vmod1 ~= rawmod1)

assert( vmod1 == wrap(rawmod1))
assert(rawmod1.hello == vmod1.hello)


do
local tmp = {}
local t1 = wrap(tmp)
local t2 = wrap(tmp)
local t3 = wrap(wrap(tmp))
local t4 = wrap(wrap(tmp))

print(t1, t2, t3, t4)

assert( tostring(t1) ~= tostring(t2) )
assert( tostring(t1) ~= tostring(t3) )
assert( tostring(t1) ~= tostring(t4) )

assert( t1 == t2 )
assert( t1 == t3 )
assert( t3 == t4 )

end

