local directions = require("world.enums.directions")
local character_types = require("world.enums.character_types")
local M = {}

function M.initialize(world)

    local room1 = world.create_room("A 15'x15' CHAMBER")

    local room2 = world.create_room("A 30'x35' CHAMBER")
    room1:create_route(directions.SOUTH, room2)
    room2:create_route(directions.NORTH, room1)

    local room3 = world.create_room("A 15'x15' CHAMBER")
    room2:create_route(directions.SOUTH, room3)
    room3:create_route(directions.NORTH, room2)

    local monster_faction = world.create_faction()
    local player_faction = world.create_faction()
    monster_faction:set_enemy(player_faction, true)
    player_faction:set_enemy(monster_faction, true)

    world.create_character(room1, monster_faction, character_types.GOBLIN)

    local avatar_character = world.create_character(room2, player_faction, character_types.N00B)
    world.set_avatar(avatar_character)
end

return M