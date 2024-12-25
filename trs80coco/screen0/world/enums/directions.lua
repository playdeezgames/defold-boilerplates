local M = {}
M.NORTH = "NORTH"
M.EAST = "EAST"
M.SOUTH = "SOUTH"
M.WEST = "WEST"
local function make_descriptor(name,abbreviation)
    local descriptor = {}
    function descriptor:get_name()
        return name
    end
    function descriptor:get_abbreviation()
        return abbreviation
    end
    return descriptor
end
M.descriptors = {}
M.descriptors[M.NORTH]=make_descriptor("NORTH","N")
M.descriptors[M.EAST]=make_descriptor("EAST","E")
M.descriptors[M.SOUTH]=make_descriptor("SOUTH","S")
M.descriptors[M.WEST]=make_descriptor("WEST","W")
return M