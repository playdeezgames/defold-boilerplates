local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

local game_states={}
game_states[state_ids.TITLE] = require("game.title_state")
game_states[state_ids.EMBARK] = require("game.embark_state")
game_states[state_ids.NAVIGATION] = require("game.navigation_state")

function M.update(dt)
	game_states[states.get_current()].update(dt)
end

function M.handle_command(command)
	game_states[states.get_current()].handle_command(command)
end

return M