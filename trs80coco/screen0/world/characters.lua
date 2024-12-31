local M = {}

local function roll_dice(dice, maximum)
    local result = 0
    for _ = 1, dice do
        if result < maximum and math.random(1,6) == 6 then
            result = result + 1
        end
    end
    return result
end

function M.construct(world, character, character_data)
    function character:set_attack_dice(attack_dice)
        character_data.statistics.attack_dice = attack_dice
    end
    function character:get_attack_dice()
        return character_data.statistics.attack_dice
    end
    function character:set_maximum_attack(maximum_attack)
        character_data.statistics.maximum_attack = maximum_attack
    end
    function character:get_maximum_attack()
        return character_data.statistics.maximum_attack
    end
    function character:set_defend_dice(defend_dice)
        character_data.statistics.defend_dice = defend_dice
    end
    function character:get_defend_dice()
        return character_data.statistics.defend_dice
    end
    function character:set_maximum_defend(maximum_defend)
        character_data.statistics.maximum_defend = maximum_defend
    end
    function character:get_maximum_defend()
        return character_data.statistics.maximum_defend
    end
    function character:set_health(health)
        character_data.statistics.health = math.max(0, math.min(character:get_maximum_health(), health))
    end
    function character:get_health()
        return character_data.statistics.health
    end
    function character:set_maximum_health(maximum_health)
        character_data.statistics.maximum_health = maximum_health
    end
    function character:get_maximum_health()
        return character_data.statistics.maximum_health
    end
    function character:roll_attack()
        return roll_dice(self:get_attack_dice(), self:get_maximum_attack())
    end
    function character:roll_defend()
        return roll_dice(self:get_defend_dice(), self:get_maximum_defend())
    end
    function character:take_damage(damage)
        self:set_health(self:get_health() - damage)
    end
    function character:is_dead()
        return self:get_health() <= 0
    end
    function character:attack(enemy)
        if self:is_dead() or enemy:is_dead() then return end
        local message = world.create_message()
        message:add_line(self:get_name().." ATTACKS "..enemy:get_name())
        local attack_roll = self:roll_attack()
        local defend_roll = enemy:roll_defend()
        if attack_roll > defend_roll then
            local damage = attack_roll - defend_roll
            message:add_line(enemy:get_name().." TAKES "..damage.." DAMAGE!")
            enemy:take_damage(damage)
            if enemy:is_dead() then
                message:add_line(self:get_name().." KILLS "..enemy:get_name())
            else
                message:add_line(enemy:get_name().." HAS "..enemy:get_health().." HEALTH LEFT")
            end
        else
            message:add_line(self:get_name().." MISSES!")
        end
    end
    function character:fight()
        if not self:has_enemies() then return end
        local enemies = self:get_enemies()
        self:attack(enemies[1])
        local corpses = {}
        for _,enemy in ipairs(enemies) do
            if enemy:is_dead() then
                table.insert(corpses, enemy)
            else
                enemy:attack(self)
            end
        end
        for _, corpse in ipairs(corpses) do
            corpse:recycle()
        end
    end
    function character:recycle()
        if not self:is_avatar() then
            self:set_room(nil)
            world.recycle_character(self)
        end
    end
    function character:is_avatar()
        local avatar = world.get_avatar()
        if avatar ~= nil then
            return avatar.character_id == self.character_id
        end
        return false
    end
    function character:set_name(name)
        character_data.name = name
    end
    function character:get_name()
        return character_data.name
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
            return world.get_faction(character_data.faction_id)
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
        return world.get_room(character_data.room_id)
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

return M