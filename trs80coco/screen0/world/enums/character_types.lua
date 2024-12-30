local M = {}

M.GOBLIN = "GOBLIN"
M.N00B = "N00B"

local function initialize_goblin(character)
    character:set_name("goblin")
    character:set_attack_dice(4)
    character:set_maximum_attack(2)
    character:set_defend_dice(1)
    character:set_maximum_defend(1)
    character:set_health(1)
    character:set_maximum_health(1)
end

local function initialize_avatar(character)
    character:set_name("n00b")
    character:set_attack_dice(1)
    character:set_maximum_attack(1)
    character:set_defend_dice(4)
    character:set_maximum_defend(2)
    character:set_health(5)
    character:set_maximum_health(5)
end

local initializers = {}
initializers[M.GOBLIN]=initialize_goblin
initializers[M.N00B]=initialize_avatar

function M.initialize(character, character_type)
    initializers[character_type](character)
end

return M