local routes = require("world.routes")
local M = {}

function M.construct(world, room, room_data)
    function room:set_inventory(inventory)
        room_data.inventory_id = inventory.inventory_id
    end
    function room:get_inventory()
        return world.get_inventory(room_data.inventory_id)
    end
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
    function room:get_description()
        return room_data.description
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

        routes.construct(world, route, route_data)

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
            table.insert(result, world.get_character(character_id))
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

return M