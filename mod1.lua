local M = {
	hello = function() return "hello!" end
}
M._NAME = "mod1"
setmetatable(M, {__call = function(self, ...) return self._NAME end})
return M
