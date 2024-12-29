local data = require("data.data")
local directions = require("world.enums.directions")

local M = {}

local function construct_route(route, route_data)
    function route:get_direction()
        return directions.descriptors[route_data.direction_id]
    end
    function route:get_destination_room()
        return M.get_room(route_data.destination_room_id)
    end
end

local function construct_room(room, room_data)
    function room:has_enemies(character)
        for _,candidate in ipairs(self:get_characters()) do
            if candidate:is_enemy(character) then
                return true
            end
        end
        return false
    end
    function room:get_enemies(character)
        local enemies = {}
        for _,candidate in ipairs(self:get_characters()) do
            if candidate:is_enemy(character) then
                table.insert(enemies, candidate)
            end
        end
        return enemies
    end
    function room:create_route(direction, destination_room)
        local route_id = #(room_data.routes) + 1
        room_data.routes[route_id]={}

        local route_data = room_data.routes[route_id]
        route_data.direction_id = direction
        route_data.destination_room_id = destination_room.room_id

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
        for _,character_id in ipairs(room_data.characters) do
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
    function character:fight()
        if not self:has_enemies() then return end
        --TODO: attack
        --TODO: counter attack
    end
    function character:run()
        if not self:has_enemies() or not self:can_move() then return end
        --TODO: attacks of opportunity from enemies
        local routes = self:get_room():get_routes()
        local route = routes[math.random(1, #routes)]
        --TODO: message about running
        self:take_route(route)
    end
    function character:is_enemy(other_character)
        if other_character:get_faction():is_enemy(self:get_faction()) then
            return true
        end
    end
    function character:set_faction(faction)
        character_data.faction_id = faction.faction_id
    end
    function character:get_faction()
        if character_data.faction_id ~= nil then
            return M.get_faction(character_data.faction_id)
        end
        return nil
    end
    function character:has_enemies()
        return self:get_room():has_enemies(self)
    end
    function character:get_enemies()
        return self:get_room():get_enemies(self)
    end
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
    function character:take_route(route)
        if route == nil then return end
        self:set_room(route:get_destination_room())
    end
end


local function construct_faction(faction, faction_data)
    function faction:set_enemy(other_faction, is_enemy)
        if is_enemy then
            self:set_enemy(other_faction, false)
            table.insert(faction_data.enemies, other_faction.faction_id)
        else
            local new_enemies = {}
            for _, faction_id in ipairs(faction_data.enemies) do
                if faction_id ~= other_faction.faction_id then
                    table.insert(new_enemies, faction_id)
                end
            end
            faction_data.enemies = new_enemies
        end
    end
    function faction:is_enemy(other_faction)
        for _, faction_id in ipairs(faction_data.enemies) do
            if faction_id == other_faction.faction_id then
                return true
            end
        end
        return false
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

function M.create_character(room, faction)
    local character_id = #(data.characters) + 1
    data.characters[character_id]={}

    local result = M.get_character(character_id)
    result:set_room(room)
    result:set_faction(faction)
    return result
end

function M.get_faction(faction_id)
    local faction_data = data.factions[faction_id]

    local faction = {}
    faction.faction_id = faction_id

    construct_faction(faction, faction_data)

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

    local room1 = M.create_room()

    local room2 = M.create_room()
    room1:create_route(directions.SOUTH, room2)
    room2:create_route(directions.NORTH, room1)

    local room3 = M.create_room()
    room2:create_route(directions.SOUTH, room3)
    room3:create_route(directions.NORTH, room2)

    local monster_faction = M.create_faction()
    local player_faction = M.create_faction()
    monster_faction:set_enemy(player_faction, true)
    player_faction:set_enemy(monster_faction, true)

    local goblin_enemy = M.create_character(room1, monster_faction)

    local avatar_character = M.create_character(room2, player_faction)
    M.set_avatar(avatar_character)
end

return M