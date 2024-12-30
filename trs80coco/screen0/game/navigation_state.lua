local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
	display_buffer.write_line("NAVIGATION!", 2)

    local avatar = world.get_avatar()
    assert(avatar, "avatar should not be nil here")
    local room = avatar:get_room()
    display_buffer.write_line("YER IN: "..room:get_description(), 1)
    local routes = room:get_routes()
    if #routes > 0 then
        display_buffer.write_line("EXITS:", 1)
        for _,route in ipairs(routes) do
            display_buffer.write_line(route:get_direction():get_name(), 1)
        end
    end
    display_buffer.write_line(" ", 1)
    if avatar:can_move() then
        display_buffer.write("1)", 2)
        display_buffer.write_line(" MOVE", 1)
    end
    display_buffer.write("9)", 2)
    display_buffer.write_line(" STATISTICS", 1)
    display_buffer.write("0)", 2)
    display_buffer.write_line(" GAME MENU", 1)
end

function M.handle_command(command)
    if command == commands.ONE then
        states.set_current(state_ids.MOVE)
    elseif command == commands.NINE then
        states.set_current(state_ids.STATISTICS)
    elseif command == commands.ZERO then
        states.set_current(state_ids.GAME_MENU)
    end
end

return M