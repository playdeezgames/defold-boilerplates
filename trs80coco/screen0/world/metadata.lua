local state_ids = require("game.state_ids")
local world = require("world.world")
local M = {}

function M.get_state()
	if world.get_avatar() == nil then
		return state_ids.EMBARK
	elseif world.get_avatar():has_enemies() then
		return state_ids.COMBAT
	else
		return state_ids.NAVIGATION
	end
end

return M