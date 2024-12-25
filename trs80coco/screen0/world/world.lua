local data = require("data.data")
local directions = require("world.enums.directions")

local M = {}

local function construct_route(route, route_data)
    function route:get_direction()
        return route_data.direction
    end
end

local function construct_room(room, room_data)
    function room:create_route(direction, destination_room)
        local route_id = #(room_data.routes) + 1
        room_data.routes[route_id]={}

        local route_data = room_data.routes[route_id]
        route_data.direction = direction
        route_data.destination_room = destination_room.room_id

        return self:get_route(route_id)
    end
    function room:get_route(route_id)
        local route_data = room_data.routes[route_id]

        local route = {}
        route.route_id = route_id

        construct_route(route, route_data)

        return route
    end
    function room:get_routes()
        local routes = {}
        for route_id,route in ipairs(room_data.routes) do
            if route ~= nil then
                table.insert(routes, self:get_route(route_id))
            end
        end
        return routes
    end
    function room:add_character(character)
        if character==nil then
            return
        end
        self:remove_character(character)
        table.insert(room_data.characters, character.character_id)
    end
    function room:remove_character(character)
        if character==nil then
            return
        end
        local new_characters = {}
        for _,character_id in ipairs(room_data.characters) do
            if character_id ~= character.character_id then
                table.insert(new_characters, character_id)
            end
        end
        room_data.characters = new_characters
    end
    function room:get_characters()
        local result = {}
        for _,character_id in room_data.characters do
            table.insert(result, M.get_character(character_id))
        end
        return result
    end
    function room:has_routes()
        for _,route in ipairs(room_data.routes) do
            if route ~= nil then
                return true
            end
        end
        return false
    end
end

local function construct_character(character, character_data)
    function character:set_room(room)
        local old_room = self:get_room()
        if old_room~=nil then
            old_room:remove_character(self)
        end
        if room == nil then
            character_data.room_id = nil
        else
            character_data.room_id = room.room_id
            room:add_character(self)
        end
    end
    function character:get_room()
        if character_data.room_id==nil then
            return nil
        end
        return M.get_room(character_data.room_id)
    end
    function character:can_move()
        local room = self:get_room()
        if room==nil then return false end
        return room:has_routes()
    end
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
    local room_id = #(data.rooms) + 1
    data.rooms[room_id] = {}

    local room_data = data.rooms[room_id]
    room_data.routes={}
    room_data.characters={}

    return M.get_room(room_id)
end

function M.create_character(room)
    local character_id = #(data.characters) + 1
    data.characters[character_id]={}

    local result = M.get_character(character_id)
    result:set_room(room)
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