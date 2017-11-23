--https://github.com/MNoya/DotaCraft/blob/master/game/dota_addons/dotacraft/scripts/vscripts/mechanics/corpses.lua
if not Corpses then
    Corpses = class({})
end

CORPSE_DURATION = 30
CORPSE_APPEAR_DELAY = 3

function Corpses:CreateFromUnit(killed)
	if LeavesCorpse( killed ) then
        local name = killed:GetUnitName()
        local position = killed:GetAbsOrigin()
        local fv = killed:GetForwardVector()
        local team = killed:GetTeamNumber()
		local etc = {}
		etc.hull = killed.hullSize
		etc.arm = killed.armorType
		etc.atk = killed.attackType
		etc.bomb = killed:GetMaxHealth()
        local corpse = Corpses:CreateByNameOnPosition(name, position, team, etc)
        corpse.playerID = killed:GetPlayerOwnerID()
        corpse:SetForwardVector(fv)
        corpse:AddNoDraw()
        Timers:CreateTimer(CORPSE_APPEAR_DELAY, function()
            if IsValidEntity(corpse) then
                UTIL_Remove(killed)
                corpse:RemoveNoDraw()
            end
        end)
    end
end

function Corpses:CreateByNameOnPosition(name, position, team, etc)
    local corpse = CreateUnitByName("npc_corpse", position, false, nil, nil, team)
    corpse.unit_name = name -- Keep a reference to its name
	corpse.hullSize = etc.hull
	corpse.armorType = etc.arm
	corpse.attackType = etc.atk
	corpse.bomb_health = etc.bomb

    -- Remove the corpse from the game at any point
    function corpse:RemoveCorpse()
        corpse:StopExpiration()
        -- Remove the entity
        UTIL_Remove(corpse)
    end

    -- Removes the removal timer
    function corpse:StopExpiration()
        if corpse.removal_timer then Timers:RemoveTimer(corpse.removal_timer) end
    end

    -- Remove itself after the corpse duration
    function corpse:StartExpiration()
        corpse.corpse_expiration = GameRules:GetGameTime() + CORPSE_DURATION

        corpse.removal_timer = Timers:CreateTimer(CORPSE_DURATION, function()
            if corpse and IsValidEntity(corpse) then
                UTIL_Remove(corpse)
            end
        end)
    end

    corpse:StartExpiration()
    
    return corpse
end

function Corpses:AreAnyInRadius(playerID, origin, radius)
    return self:FindClosestInRadius(playerID, origin, radius) ~= nil
end

function Corpses:AreAnyAlliedInRadius(playerID, origin, radius)
    return self:FindAlliedInRadius(playerID, origin, radius)[1] ~= nil
end

function Corpses:FindClosestInRadius(playerID, origin, radius)
    return self:FindInRadius(playerID, origin, radius)[1]
end

function Corpses:FindInRadius(playerID, origin, radius)
    local targets = FindUnitsInRadius(PlayerResource:GetTeam(playerID), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
    local corpses = {}
    for _,target in pairs(targets) do
        if IsCorpse(target) then
            table.insert(corpses, target)
        end
    end
    return corpses
end

-- Only Friendly corpses
function Corpses:FindAlliedInRadius(playerID, origin, radius)
    local targets = FindUnitsInRadius(PlayerResource:GetTeam(playerID), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
    local corpses = {}
    local teamNumber = PlayerResource:GetTeam(playerID)
    for _,target in pairs(targets) do
        if IsCorpse(target) then
            table.insert(corpses, target)
        end
    end
    return corpses
end

function CDOTA_BaseNPC:SetNoCorpse()
    self.noCorpse = true
end

function SetNoCorpse(event)
    event.target:SetNoCorpse()
end

-- Needs a corpse_expiration and not being eaten by cannibalize
function IsCorpse(unit)
    return unit.corpse_expiration and not unit.being_eaten
end

-- Custom Corpse Mechanic
function LeavesCorpse(unit)
    
    if not unit or not IsValidEntity(unit) then
        return false

    -- Heroes don't leave corpses (includes illusions)
    elseif unit:IsHero() then
        return false

    -- Ignore buildings 
    elseif unit.GetInvulnCount ~= nil then
        return false

    -- Ignore units that were specifically set to leave no corpse
    elseif unit.noCorpse then
        return false

    -- Read the LeavesCorpse KV
    else
        -- Leave corpse     
        return true
    end
end