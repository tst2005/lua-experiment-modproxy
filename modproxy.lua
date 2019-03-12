
local table_remove = assert(table.remove)
local setmetatable = assert(_G.setmetatable)

local weakKeys = { __mode = 'k' }
local origs    = setmetatable({}, weakKeys) -- [prox] = orig

local mt = {
	__eq = function(p1, p2)
		return (origs[p1] or p1) == (origs[p2] or p2)
	end,
	__newindex = function(self, k, v)
		origs[self][k] = v
	end,
	__index = function(self, k)
		return origs[self][k]
	end,
	__call=function(self, ...)
		return assert(origs[self])(...)
	end,
}

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
--M.eq = mt.__eq

setmetatable(M, {__call=function(_, o) return M.wrap(o) end})
return M

-- w = wrap(orig)
-- getmetatable(w).__modproxy == true
-- getmetatable(w).*          == nil
