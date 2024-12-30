local directions = require("world.enums.directions")
local M = {}

function M.construct(world, route, route_data)
    function route:get_direction()
        return directions.descriptors[route_data.direction_id]
    end
    function route:get_destination_room()
        return world.get_room(route_data.destination_room_id)
    end
end

return M