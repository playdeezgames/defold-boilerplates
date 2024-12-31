local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
    display_buffer.write_line("YER DEAD!", 2)
    display_buffer.write_line(" ", 1)
    display_buffer.write("0)", 2)
    display_buffer.write_line(" DONE", 1)
end

function M.handle_command(command)
    if command == commands.ZERO then
        world.abandon()
        states.set_current(state_ids.TITLE)
    end
end

return M