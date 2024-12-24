local state_ids = require("game.state_ids")
local M = {}
local metadata = require("world.metadata")
local current_state = state_ids.TITLE
function M.get_current()
	if current_state == state_ids.NEUTRAL then
		return metadata.get_state()
	else
		return current_state
	end
end
function M.set_current(state)
	current_state = state
end
return M