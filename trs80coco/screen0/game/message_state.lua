local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
    local message = world.get_next_message()
    if message then
        for _, line in ipairs(message.get_lines()) do
            display_buffer.write_line(line, 1)
        end
    end
    display_buffer.write_line(" ", 1)
    display_buffer.write("0)", 2)
    display_buffer.write_line(" NEXT", 1)
end

function M.handle_command(command)
    if command == commands.ZERO then
        world.dismiss_message()
        states.set_current(state_ids.NEUTRAL)
    end
end

return M