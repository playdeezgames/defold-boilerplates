local data = require("data.data")
local directions = require("world.enums.directions")
local characters = require("world.characters")
local rooms = require("world.rooms")
local factions = require("world.factions")
local character_types = require("world.enums.character_types")

local M = {}

function M.get_character(character_id)
    local character_data = data.characters[character_id]

    local character = {}
    character.character_id = character_id

    characters.construct(M, character, character_data)

    return character
end

function M.get_room(room_id)
    local room_data = data.rooms[room_id]

    local room = {}
    room.room_id = room_id

    rooms.construct(M, room, room_data)

    return room
end

function M.create_room(description)
    local room_id = #(data.rooms) + 1
    data.rooms[room_id] = {}
    
    local room_data = data.rooms[room_id]
    room_data.description = description
    room_data.routes={}
    room_data.characters={}

    return M.get_room(room_id)
end

function M.create_character(room, faction, character_type)
    local character_id = #(data.characters) + 1
    data.characters[character_id]={statistics={}}

    local result = M.get_character(character_id)
    result:set_room(room)
    result:set_faction(faction)
    character_types.initialize(result, character_type)
    return result
end

function M.get_faction(faction_id)
    local faction_data = data.factions[faction_id]

    local faction = {}
    faction.faction_id = faction_id

    factions.construct(M, faction, faction_data)

    return faction
end

function M.create_faction()
    local faction_id = #(data.factions) + 1
    data.factions[faction_id] = {}

    local faction_data = data.factions[faction_id]
    faction_data.enemies = {}

    local result = M.get_faction(faction_id)
    return result
end

function M.set_avatar(character)
    if character == nil then
        data.avatar_id = nil
    else
        data.avatar_id = character.character_id
    end
end

function M.get_avatar()
    if data.avatar_id == nil then
        return nil
    end
    return M.get_character(data.avatar_id)
end

function M.abandon()
    data.rooms = {}
    data.characters = {}
    data.factions = {}
    data.avatar_id = nil
end

function M.initialize()
    M.abandon()

    local room1 = M.create_room("A 15'x15' CHAMBER")

    local room2 = M.create_room("A 30'x35' CHAMBER")
    room1:create_route(directions.SOUTH, room2)
    room2:create_route(directions.NORTH, room1)

    local room3 = M.create_room("A 15'x15' CHAMBER")
    room2:create_route(directions.SOUTH, room3)
    room3:create_route(directions.NORTH, room2)

    local monster_faction = M.create_faction()
    local player_faction = M.create_faction()
    monster_faction:set_enemy(player_faction, true)
    player_faction:set_enemy(monster_faction, true)

    local goblin_enemy = M.create_character(room1, monster_faction, character_types.GOBLIN)

    local avatar_character = M.create_character(room2, player_faction, character_types.N00B)
    M.set_avatar(avatar_character)
end

return M