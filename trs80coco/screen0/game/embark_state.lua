local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
	display_buffer.write_line("EMBARK!", 2)

    display_buffer.write_line("THIS IS AN SAMPLE TEXT ADVENTUREGAME WITH A SMALL NUMBER OF     ROOMS IN ORDER TO PROVE OUT THE FRAMEWORK. YER GOAL IS TO       EXPLORE THE SMALL DUNGEON, FOR  LOOT AND GLORY AND WHATNOT.", 1)

    display_buffer.write_line(" ", 1)
    display_buffer.write("1)", 2)
    display_buffer.write_line(" LET'S GO!", 1)
    display_buffer.write("0)", 2)
    display_buffer.write_line(" CANCEL", 1)
end

function M.handle_command(command)
    if command == commands.ZERO then
        states.set_current(state_ids.TITLE)
    elseif command == commands.ONE then
        world.initialize()
    end
end

return M