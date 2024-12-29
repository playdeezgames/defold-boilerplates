local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

local game_states={}
game_states[state_ids.TITLE] = require("game.title_state")
game_states[state_ids.EMBARK] = require("game.embark_state")
game_states[state_ids.NAVIGATION] = require("game.navigation_state")
game_states[state_ids.MOVE] = require("game.move_state")
game_states[state_ids.GAME_MENU] = require("game.game_menu_state")
game_states[state_ids.CONFIRM_ABANDON] = require("game.confirm_abandon_state")
game_states[state_ids.COMBAT] = require("game.combat_state")

function M.update(dt)
	game_states[states.get_current()].update(dt)
end

function M.handle_command(command)
	game_states[states.get_current()].handle_command(command)
end

return M