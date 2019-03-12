
local table_remove = assert(table.remove)
local setmetatable = assert(_G.setmetatable)

local weakKeys = { __mode = 'k' }
local origs    = setmetatable({}, weakKeys) -- [prox] = orig

local mt = {}
function mt.__eq(p1, p2)
	return origs[p1] and origs[p2]
end
function mt.__newindex(self, k, v)
	origs[self][k] = v
end
function mt.__index(self, k)
	return origs[self][k]
end
function mt.__call(self, ...)
	local orig = origs[self]
	return orig(...)
end
function mt.__tostring(self)
	return tostring(origs[self]) -- FIXME: little dangerous about infinite stuff ...
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
M.eq = mt.__eq

setmetatable(M, {__call=function(_, o) return M.wrap(o) end})
return M

-- w = wrap(orig)
-- getmetatable(w).__modproxy == true
-- getmetatable(w).*          == nil
