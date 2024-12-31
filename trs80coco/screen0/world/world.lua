local data = require("data.data")
local characters = require("world.characters")
local rooms = require("world.rooms")
local factions = require("world.factions")
local character_types = require("world.enums.character_types")
local initializer = require("world.initializer")
local messages = require("world.messages")
local inventories = require("world.inventories")

local M = {}

function M.initialize()
    M.abandon()
    initializer.initialize(M)
end

function M.abandon()
    data.rooms = {}
    data.characters = {}
    data.factions = {}
    data.messages = {}
    data.inventories = {}
    data.avatar_id = nil
end

--CHARACTERS-------------------------------------------------------------------

function M.create_character(room, faction, character_type)
    local character_id = nil
    for index, candidate in ipairs(data.characters) do
        if candidate == nil then
            character_id = index
            break
        end
    end
    
    character_id = character_id or (#(data.characters) + 1)
    data.characters[character_id]={statistics={}}

    local result = M.get_character(character_id)
    result:set_room(room)
    result:set_faction(faction)
    result:set_inventory(M.create_inventory())
    character_types.initialize(result, character_type)
    return result
end

function M.get_character(character_id)
    local character_data = data.characters[character_id]

    local character = {}
    character.character_id = character_id

    characters.construct(M, character, character_data)

    return character
end

function M.recycle_character(character)
    data.characters[character.character_id] = nil
end

--ROOMS------------------------------------------------------------------------

function M.create_room(description)
    local room_id = #(data.rooms) + 1
    data.rooms[room_id] = {}
    
    local room_data = data.rooms[room_id]
    room_data.description = description
    room_data.routes={}
    room_data.characters={}

    local room = M.get_room(room_id)
    room:set_inventory(M.create_inventory())
    return room
end

function M.get_room(room_id)
    local room_data = data.rooms[room_id]

    local room = {}
    room.room_id = room_id

    rooms.construct(M, room, room_data)

    return room
end

--INVENTORIES------------------------------------------------------------------

function M.create_inventory()
    local inventory_id = #(data.inventories) + 1
    data.inventories[inventory_id] = {}

    local inventory = M.get_inventory(inventory_id)
    return inventory
end

function M.get_inventory(inventory_id)
    local inventory_data = data.inventories[inventory_id]

    local inventory = {}
    inventory.inventory_id = inventory_id

    inventories.construct(M, inventory, inventory_data)

    return inventory
end

--FACTIONS---------------------------------------------------------------------

function M.create_faction()
    local faction_id = #(data.factions) + 1
    data.factions[faction_id] = {}

    local faction_data = data.factions[faction_id]
    faction_data.enemies = {}

    local result = M.get_faction(faction_id)
    return result
end

function M.get_faction(faction_id)
    local faction_data = data.factions[faction_id]

    local faction = {}
    faction.faction_id = faction_id

    factions.construct(M, faction, faction_data)

    return faction
end

--AVATAR-----------------------------------------------------------------------

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

--MESSAGES---------------------------------------------------------------------

function M.create_message()
    local message_id = #(data.messages) + 1
    data.messages[message_id]={}

    local result = M.get_message(message_id)
    return result
end

function M.has_messages()
    return #data.messages > 0
end

function M.get_message(message_id)
    local message_data = data.messages[message_id]

    local message = {}
    message.message_id = message_id

    messages.construct(M, message, message_data)

    return message
end

function M.get_next_message()
    if M.has_messages() then
        return M.get_message(1)
    end
    return nil
end

function M.dismiss_message()
    if M.has_messages() then
        table.remove(data.messages, 1)
    end
end

return M