local state_ids = require("game.state_ids")
local world = require("world.world")
local M = {}

function M.get_state()
	if world.get_avatar() == nil then
		return state_ids.EMBARK
	else
		return state_ids.NAVIGATION
	end
end

return M