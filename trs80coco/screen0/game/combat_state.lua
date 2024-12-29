local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
	display_buffer.write_line("COMBAT!", 2)
	local avatar = world.get_avatar()
	assert(avatar)
	display_buffer.write("Enemies: ", 1)
	local enemies = avatar:get_enemies()
	local is_first = true
	for _,enemy in ipairs(enemies) do
		if not is_first then
			display_buffer.write(", ", 1)
		end
		is_first = false
		display_buffer.write("#"..enemy.character_id, 1)
	end
	display_buffer.write_line(" ", 1)
	display_buffer.write("1)", 2)
	display_buffer.write_line(" FIGHT!", 1)
	display_buffer.write("0)", 2)
	display_buffer.write_line(" RUN!", 1)
end

function M.handle_command(command)
end

return M