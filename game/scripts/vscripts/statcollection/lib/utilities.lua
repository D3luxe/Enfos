STAT_UTILITIES_VERSION = "0.1"

--[[
    This file contains a general use API for collecting stats, to be used in your schema.lua BuildGameArray or BuildPlayersArray
    It will be extended with more functionalities as the library gets more usage and example cases
    All the functions should only use methods from the Dota API, and not contain calls to a value specific to a certain game mode (use a different file for this!)
]]

local heroNames = {
				{	["name"]="npc_dota_hero_omniknight",
					["enfos"]="Ahlen",
				},
				{	["name"]="npc_dota_hero_crystal_maiden",
					["enfos"]="Arcane_Mistress",
				},
				{	["name"]="npc_dota_hero_beastmaster",
					["enfos"]="Barbarian",
				},
				{	["name"]="npc_dota_hero_medusa",
					["enfos"]="Bard",
				},
				{	["name"]="npc_dota_hero_ursa",
					["enfos"]="Battle_Chanter",
				},
				{	["name"]="npc_dota_hero_juggernaut",
					["enfos"]="Blood_Dancer",
				},
				{	["name"]="npc_dota_hero_ember_spirit",
					["enfos"]="Cabalist",
				},
				{	["name"]="npc_dota_hero_naga_siren",
					["enfos"]="Cleric",
				},
				{	["name"]="npc_dota_hero_lina",
					["enfos"]="Empath",
				},
				{	["name"]="npc_dota_hero_earth_spirit",
					["enfos"]="Entropist",
				},
				{	["name"]="npc_dota_hero_storm_spirit",
					["enfos"]="Evoker",
				},
				{	["name"]="npc_dota_hero_terrorblade",
					["enfos"]="Faenrae_Champion",
				},
				{	["name"]="npc_dota_hero_dragon_knight",
					["enfos"]="Holy_Warrior",
				},
				{	["name"]="npc_dota_hero_dazzle",
					["enfos"]="Hypnotist",
				},
				{	["name"]="npc_dota_hero_bounty_hunter",
					["enfos"]="Magic_Infuser",
				},
				{	["name"]="npc_dota_hero_silencer",
					["enfos"]="Mentalist",
				},
				{	["name"]="npc_dota_hero_luna",
					["enfos"]="Moon_Mage",
				},
				{	["name"]="npc_dota_hero_treant",
					["enfos"]="Oak",
				},
				{	["name"]="npc_dota_hero_phantom_assassin",
					["enfos"]="Paladin",
				},
				{	["name"]="npc_dota_hero_drow_ranger",
					["enfos"]="Ranger",
				},
				{	["name"]="npc_dota_hero_lich",
					["enfos"]="Revenant",
				},
				{	["name"]="npc_dota_hero_witch_doctor",
					["enfos"]="Shadow_Priest",
				},
				{	["name"]="npc_dota_hero_sniper",
					["enfos"]="Sniper",
				},
				{	["name"]="npc_dota_hero_spirit_breaker",
					["enfos"]="Summoner",
				},
				{	["name"]="npc_dota_hero_furion",
					["enfos"]="Tempest",
				},
				{	["name"]="npc_dota_hero_antimage",
					["enfos"]="Thief",
				},
				{	["name"]="npc_dota_hero_skywrath_mage",
					["enfos"]="Time_Mage",
				},
				{	["name"]="npc_dota_hero_troll_warlord",
					["enfos"]="Troll_Cannibal",
				},
				{	["name"]="npc_dota_hero_shadow_shaman",
					["enfos"]="Warlock",
				},
				{	["name"]="npc_dota_hero_sven",
					["enfos"]="Weaponsmith",
				},

}
------------------------------
--       Game Functions     --
------------------------------

-- Number of times roshan was killed
function GetRoshanKills()
    local total_rosh_kills = 0
    for playerID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayerID(playerID) then
            local roshan_kills_player =  PlayerResource:GetRoshanKills(playerID)
            total_rosh_kills = total_rosh_kills + roshan_kills_player
        end
    end

    return total_rosh_kills
end

------------------------------
--      Player Functions    --
------------------------------

-- Hero name without its npc_dota_hero prefix.
-- If you would like to send custom hero names you should use a different function instead
function GetHeroName( playerID )
	local heroName = "ERROR - MISSING"
	local heroPicked = PlayerResource:GetSelectedHeroName( playerID )

	for i = 1, #heroNames do
		if heroNames[i].name == heroPicked then
			heroName = heroNames[i].enfos
		end
	end

    
    return heroName
end

-- Current gold and item net worth
function GetNetworth( hero )
    local networth = hero:GetGold()

    -- Iterate over item slots adding up its gold cost
    for i=0,15 do
        local item = hero:GetItemInSlot(i)
        if item then
            networth = networth + item:GetCost()
        end
    end

    return networth
end

-- Long string of item names ordered alphabetically, without the item_ prefix and separated by commas
function GetItemList(hero)
    local itemTable = {}

    for i=0,5 do
        local item = hero:GetItemInSlot(i)
        if item then
            local itemName = string.gsub(item:GetAbilityName(),"item_","") --Cuts the item_ prefix
            table.insert(itemTable,itemName)
        end
    end

    table.sort(itemTable)
    local itemList = table.concat(itemTable, ",") --Concatenates with a comma

    return itemList
end