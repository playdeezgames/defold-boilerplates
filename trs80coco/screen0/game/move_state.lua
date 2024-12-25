local display_buffer = require("display_buffer.display_buffer")
local commands = require("input.commands")
local world = require("world.world")
local states = require("game.states")
local state_ids = require("game.state_ids")

local M = {}

function M.update(dt)
	display_buffer.clear(97)
	display_buffer.write_line("MOVE!", 2)
    display_buffer.write_line(" ", 1)

    local avatar = world.get_avatar()
    assert(avatar, "avatar should not be nil here")
    local room = avatar:get_room()
    local routes = room:get_routes()
    for index,route in ipairs(routes) do
        display_buffer.write(index..")", 2)
        display_buffer.write_line(" "..route:get_direction(), 1)
    end
    display_buffer.write("0)", 2)
    display_buffer.write_line(" NEVER MIND", 1)
end

local routeIndices = {}
routeIndices[commands.ONE]=1
routeIndices[commands.TWO]=2
routeIndices[commands.THREE]=3
routeIndices[commands.FOUR]=4
routeIndices[commands.FIVE]=5
routeIndices[commands.SIX]=6
routeIndices[commands.SEVEN]=7
routeIndices[commands.EIGHT]=8
routeIndices[commands.NINE]=9

function M.handle_command(command)
    if command == commands.ZERO then
        states.set_current(state_ids.NEUTRAL)
        return
    else
        local routeIndex = routeIndices[command]
        if routeIndex ~= nil then
            local avatar = world.get_avatar()
            assert(avatar, "avatar shall not be nil")
            local routes = avatar:get_room():get_routes()
            if routeIndex<=#routes then
                avatar:take_route(routes[routeIndex])
                states.set_current(state_ids.NEUTRAL)
            end
        end
    end
end

return M