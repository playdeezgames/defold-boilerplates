local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
	display_buffer.write_line("GAME MENU", 2)

    display_buffer.write_line(" ", 1)
    display_buffer.write("1)", 2)
    display_buffer.write_line(" ABANDON GAME", 1)
    display_buffer.write("0)", 2)
    display_buffer.write_line(" CONTINUE GAME", 1)
end

function M.handle_command(command)
    if command == commands.ZERO then
        states.set_current(state_ids.NEUTRAL)
    elseif command == commands.ONE then
        states.set_current(state_ids.CONFIRM_ABANDON)
    end
end

return M