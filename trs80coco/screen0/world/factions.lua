local M = {}

function M.construct(world, faction, faction_data)
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

return M