local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
	display_buffer.write_line("STATISTICS", 2)
	local avatar = world.get_avatar()
	assert(avatar)
	display_buffer.write_line("HEALTH: "..avatar:get_health().."/"..avatar:get_maximum_health(), 1)
	display_buffer.write_line("ATTACK DICE: "..avatar:get_attack_dice().."(MAX "..avatar:get_maximum_attack()..")", 1)
	display_buffer.write_line("DEFEND DICE: "..avatar:get_defend_dice().."(MAX "..avatar:get_maximum_defend()..")", 1)
	
	display_buffer.write_line(" ", 1)
	display_buffer.write("0)", 2)
	display_buffer.write_line(" DONE", 1)
end

function M.handle_command(command)
	if command == commands.ZERO then
		states.set_current(state_ids.NEUTRAL)
	end
end

return M