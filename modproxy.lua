
local proxies = {} -- set as weak table ?

local mt = {}
local function eq(a, b)
	local a2 = proxies[a] or a
	local b2 = proxies[b] or b
	return a2 == b2
end
mt.__eq = eq

mt.__newindex = function(self, k, v)
	proxies[self][k] = v
end
mt.__index = function(self, k)
	return proxies[self][k]
end
local content = {__modproxy = true}
mt.__metatable = setmetatable({}, {__index=content, __metatable=false, __newindex=function() end, })


--local mt2mt = {__metatable = false, __index = mt, __newindex = function() end}
--local mt2 = setmetatable({}, mtmt)

local M = {}
function M.wrap(o)
	local n = {}
	proxies[n] = o
	return setmetatable(n, mt)
end
function M.unwrap(o)
	for k,v in pairs(proxies) do
		if k == o then
			proxies[k] = nil -- table.remove ?
			return true
		end
	end
	return false
end
M.eq = eq

return M
