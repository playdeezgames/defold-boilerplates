local data = require("data.data")
local directions = require("world.enums.directions")

local M = {}

local function construct_route(route, route_data)
end

local function construct_room(room, room_data)
    function room:create_route(direction, destination_room)
        local route_id = #room_data.routes + 1
        room_data[route_id]={}

        local route_data = room_data[route_id]
        route_data.direction = direction
        route_data.destination_room = destination_room.room_id

        return self:get_route(route_id)
    end
    function room:get_route(route_id)
        local route_data = room_data[route_id]

        local route = {}
        route.route_id = route_id

        construct_route(route, route_data)

        return route
    end
end

local function construct_character(character, character_data)
end

function M.get_character(character_id)
    local character_data = data.characters[character_id]
     
    local character = {}
    character.character_id = character_id

    construct_character(character, character_data)

    return character
end

function M.get_room(room_id)
    local room_data = data.rooms[room_id]
     
    local room = {}
    room.room_id = room_id

    construct_room(room, room_data)

    return room
end

function M.create_room()
    local room_id = #data.rooms + 1
    data.rooms[room_id] = {}

    local room_data = data.rooms[room_id]
    room_data.routes={}

    return M.get_room(room_id)
end

function M.create_character(room)
    local character_id = #data.characters + 1
    data.characters[character_id]={}

    local character_data = data.characters[character_id]
    character_data.room = room.room_id

    return M.get_character(character_id)
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

function M.initialize()
    data.rooms = {}
    data.characters = {}
    data.avatar_id = nil

    local room1 = M.create_room()

    local room2 = M.create_room()
    room1:create_route(directions.SOUTH, room2)
    room2:create_route(directions.NORTH, room1)

    local room3 = M.create_room()
    room2:create_route(directions.SOUTH, room3)
    room3:create_route(directions.NORTH, room2)

    local avatar_character = M.create_character(room2)
    M.set_avatar(avatar_character)
end

return M