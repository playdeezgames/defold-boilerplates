local M = {}

M.KEY = "KEY"
M.SWORD = "SWORD"

local function initialize_key(item)
    item:set_name("KEY")
end

local function initialize_sword(item)
    item:set_name("SWORD")
end

local initializers = {}
initializers[M.KEY]=initialize_key
initializers[M.SWORD]=initialize_sword

function M.initialize(item, item_type)
    initializers[item_type](item)
end

return M