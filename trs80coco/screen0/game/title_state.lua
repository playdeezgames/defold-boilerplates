local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
	display_buffer.write_line("SAMPLE DUNGEON OF SPLORR!!", 2)
	display_buffer.write_line("A PRODUCTION OF THEGRUMPYGAMEDEV", 1)
	display_buffer.write_line(" ", 1)
	--TODO: depending on whether there is an avatar, CONTINUE or EMBARK.
	display_buffer.write("1)", 2)
	display_buffer.write_line(" EMBARK!", 1)
	--2: scum load
	--3: load
	--4: options
	--5: about
end

function M.handle_command(command)
	if command == commands.ONE then
		states.set_current(state_ids.NEUTRAL)
	end
end

return M