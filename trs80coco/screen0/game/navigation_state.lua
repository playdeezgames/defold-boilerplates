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
    display_buffer.write_line("ROOM: "..room.room_id, 1)
    local routes = room:get_routes()
    if #routes > 0 then
        display_buffer.write_line("EXITS:", 1)
        for _,route in ipairs(routes) do
            display_buffer.write_line(route:get_direction(), 1)
        end
    end
    display_buffer.write_line(" ", 1)
    if avatar:can_move() then
        display_buffer.write("1)", 2)
        display_buffer.write_line(" MOVE", 1)
    end
    display_buffer.write("0)", 2)
    display_buffer.write_line(" GAME MENU", 1)
end

function M.handle_command(command)
    if command == commands.ONE then
        states.set_current(state_ids.MOVE)
    end
end

return M