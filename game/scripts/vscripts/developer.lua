CHEAT_CODES = {
    ["extrabounty"] = function(args) CEnfosGameMode:ExtraBounty(args) end,                  -- "Speeds construction of buildings and units" 
    ["sharebounty"] = function() CEnfosGameMode:SharedBounty() end,                  -- "Speeds construction of buildings and units"   
    ["commands"] = function() CEnfosGameMode:Commands() end,                  -- "Speeds construction of buildings and units"            
}

DEBUG_CODES = {
 
}

TEST_CODES = {
   -- ["giveitem"] = function(arg) CEnfosGameMode:GiveItem(arg) end,          -- Gives an item by name to the currently selected unit
   -- ["createunits"] = function(...) CEnfosGameMode:CreateUnits(...) end     -- Creates 'name' units around the currently selected unit, with optional num and neutral team
}

COMMAND_TIME = 60

function CEnfosGameMode:DeveloperMode(player)
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()

	hero:SetGold(50000, false)
	ModifyLumber(player, 500)

	--[[local position = GameRules.StartingPositions[pID].position
	dotacraft:SpawnTestUnits("orc_spirit_walker", 8, player, position + Vector(0,-600,0), false)
	dotacraft:SpawnTestUnits("nightelf_mountain_giant", 10, player, position + Vector(0,-1000,0), true)]]
end

-- A player has typed something into the chat
function CEnfosGameMode:OnPlayerChat(keys)
	local text = keys.text
	local playerID = keys.userid-1
	local bTeamOnly = keys.teamonly
    local player = PlayerResource:GetPlayer(playerID)

    -- Handle '-command'
    if StringStartsWith(text, "-") then
        text = string.sub(text, 2, string.len(text))
    end

    if GameRules:PlayerHasCustomGameHostPrivileges(player) then
    	local input = split(text)
    	local command = input[1]
    	if CHEAT_CODES[command] then
    		CHEAT_CODES[command](input[2])
    	elseif DEBUG_CODES[command] then
            DEBUG_CODES[command]()
        elseif TEST_CODES[command] then
            TEST_CODES[command](input[2], input[3], input[4], playerID)
        end
    end
end

function CEnfosGameMode:CommandTimeCheck(time)
    return time >= COMMAND_TIME
end
function CEnfosGameMode:ExtraBounty(level)
    if self:CommandTimeCheck(GameRules:GetDOTATime(false, false)) then
        GameRules:SendCustomMessage("Settings can only be changed in the first <font color='#2EFE2E'>"..COMMAND_TIME.."</font> seconds of the game! ", 0, 0)
        return
    end
    if level == nil then
        level = 0
    end
    local bountyLevel = tonumber(level)
    print("Extra Bounty: "..bountyLevel)
    if bountyLevel >= 2 and bountyLevel <= 5 then
        GameRules.ExtraBounty = bountyLevel
        GameRules:SendCustomMessage("You now get <font color='#2EFE2E'>"..bountyLevel.."</font> times the gold for each kill. ", 0, 0)
    else
        GameRules:SendCustomMessage("Extra bounty must be between <font color='#2EFE2E'>2</font> and <font color='#2EFE2E'>5</font> ", 0, 0)
    end
end

function CEnfosGameMode:SharedBounty()
    if self:CommandTimeCheck(GameRules:GetDOTATime(false, false)) then
        GameRules:SendCustomMessage("Settings can only be changed in the first <font color='#2EFE2E'>"..COMMAND_TIME.."</font> seconds of the game! ", 0, 0)
        return
    end
    GameRules.SharedBounty = not GameRules.SharedBounty

    local message = GameRules.SharedBounty and "Bounty is now shared between team members!" or "Bounty is no longer shared between team members!"
    GameRules:SendCustomMessage(message, 0, 0)
end

function CEnfosGameMode:Commands()
    GameRules:SendCustomMessage(" <font color='#2EFE2E'>'extrabounty (2,5)'</font> - Multiples the bounty given by creeps.", 0, 0)
    GameRules:SendCustomMessage(" <font color='#2EFE2E'>'sharebounty'</font> - Bounty is shared between teammates", 0, 0)
end

function CEnfosGameMode:CreateUnits(unitName, numUnits, bEnemy, pID)
    local pos = GetMainSelectedEntity(pID):GetAbsOrigin()
    local player = PlayerResource:GetPlayer(pID)
    local hero = player:GetAssignedHero()

     -- Handle possible unit issues
    numUnits = numUnits or 1
    if not GameRules.UnitKV[unitName] then
        Say(nil,"["..unitName.."] <font color='#ff0000'> is not a valid unit name!</font>", false)
        return
    end

    local gridPoints = GetGridAroundPoint(numUnits, pos)

    PrecacheUnitByNameAsync(unitName, function()
        for i=1,numUnits do
            local unit = CreateUnitByName(unitName, gridPoints[i], true, hero, hero, hero:GetTeamNumber())
            unit:SetOwner(hero)
            unit:SetControllableByPlayer(pID, true)
            unit:SetMana(unit:GetMaxMana())

            if bEnemy then 
                unit:SetTeam(DOTA_TEAM_NEUTRALS)
            else
                table.insert(player.units, unit)
            end

            FindClearSpaceForUnit(unit, gridPoints[i], true)
            unit:Hold()         
        end
    end, pID)
end

function GetGridAroundPoint( numUnits, point )
    local navPoints = {}  

    local unitsPerRow = math.floor(math.sqrt(numUnits))
    local unitsPerColumn = math.floor((numUnits / unitsPerRow))
    local remainder = numUnits - (unitsPerRow*unitsPerColumn) 

    local forward = point:Normalized()
    local right = RotatePosition(Vector(0,0,0), QAngle(0,90,0), forward)

    local start = (unitsPerColumn-1)* -.5

    local curX = start
    local curY = 0

    local offsetX = 100
    local offsetY = 100

    for i=1,unitsPerRow do
      for j=1,unitsPerColumn do
        local newPoint = point + (curX * offsetX * right) + (curY * offsetY * forward)
        navPoints[#navPoints+1] = newPoint
        curX = curX + 1
      end
      curX = start
      curY = curY - 1
    end

    local curX = ((remainder-1) * -.5)

    for i=1,remainder do 
        local newPoint = point + (curX * offsetX * right) + (curY * offsetY * forward)
        navPoints[#navPoints+1] = newPoint
        curX = curX + 1
    end

    return navPoints
end


--[[ 
StrengthAndHonor - No defeat
Motherland [race] [level] - level jump
SomebodySetUpUsTheBomb - Instant defeat
AllYourBaseAreBelongToUs - Instant victory
WhoIsJohnGalt - Enable research
SharpAndShiny - Research upgrades
DayLightSavings [time] - If a time is specified, time of day is set to that, otherwise time of day is alternately halted/resumed
]]