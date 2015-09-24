
local table_remove = assert(table.remove)
local setmetatable = assert(_G.setmetatable)

local weakKeys = { __mode = 'k' }
local origs   = setmetatable({}, weakKeys) -- [prox] = orig

local mt = {}
local function eq(p1, p2)
	local a2 = origs[p1] or p1
	local b2 = origs[p2] or p2
	return a2 == b2
end
mt.__eq = eq

mt.__newindex = function(self, k, v)
	origs[self][k] = v
end
mt.__index = function(self, k)
	return origs[self][k]
end
mt.__call=function(self, ...)
	local orig = origs[self]
	return orig(...)
end

local content = {__modproxy = true}
mt.__metatable = setmetatable({}, {__index=content, __metatable=false, __newindex=function() end,})

local M = {}
function M.wrap(o)
	local p = o
	if origs[p] then -- try to wrap a proxy (wrapped object)
		return p -- p == proxies[origs[p]]
	end
	local p = {}
	origs[p] = o
	return setmetatable(p, mt)
end
function M.unwrap(p)
	local o = origs[p]
	if o then
		table_remove(origs, p)
		return true
	end
	return false
end
M.eq = eq

return M

-- w = wrap(orig)
-- getmetatable(w).__modproxy == true
-- getmetatable(w).*          == nil
