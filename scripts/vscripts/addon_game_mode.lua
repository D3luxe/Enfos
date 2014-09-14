--[[
Enfos

	Underscore prefix such as "_function()" denotes a local function and is used to improve readability
	
	Variable Prefix Examples
		"fl"	Float
		"n"		Int
		"v"		Table
		"b"		Boolean
]]
require( "Enfos_game_round" )
require( "Enfos_game_spawner" )
require( "util")
require( "enfos")
require( "timers")
require( "base_trigger")

MAX_LEVEL = 125
XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE[0] = 0
radiantXP = 0
direXP = 0
for i=1,MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = i * 100 + XP_PER_LEVEL_TABLE[i-1] + 100
end

--[[heroTable = {"npc_dota_hero_naga_siren",				-- 1 	Ahlen
			"npc_dota_hero_juggernaut",					-- 2 	Blood Dancer
			"npc_dota_hero_beastmaster",				-- 3 	Barbarian
			"npc_dota_hero_skywrath_mage",				-- 4 	Time Mage
			"npc_dota_hero_ursa",						-- 5 	Battle Chanter
			"npc_dota_hero_shadow_shaman",				-- 6 	Warlock
			"npc_dota_hero_dragon_knight",				-- 7 	Holy Warrior
			"npc_dota_hero_bounty_hunter",				-- 8 	Magic Infuser
			"npc_dota_hero_phantom_assassin",			-- 9 	Paladin
			"npc_dota_hero_silencer",					-- 10 	Mentalist
			"npc_dota_hero_storm_spirit",				-- 11 	Evoker
			"npc_dota_hero_luna",						-- 12 	Moon Mage
			"npc_dota_hero_dazzle",						-- 13 	Hypnotist
			"npc_dota_hero_omniknight",					-- 14 	Weaponsmith
			"npc_dota_hero_lich",						-- 15 	Revenant
			"npc_dota_hero_sniper",						-- 16 	Sniper
			"npc_dota_hero_treant",						-- 17 	Oak
			"npc_dota_hero_antimage",					-- 18 	Thief
			"npc_dota_hero_earth_spirit"				-- 19 	Entropist
		}]]--

heroTable = {
				{	["name"]="npc_dota_hero_naga_siren",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_juggernaut",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_unarmored",
				},
				{	["name"]="npc_dota_hero_beastmaster",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_skywrath_mage",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_ursa",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_shadow_shaman",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_dragon_knight",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_divine",
				},
				{	["name"]="npc_dota_hero_bounty_hunter",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_phantom_assassin",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_divine",
				},
				{	["name"]="npc_dota_hero_silencer",
					["attackType"]="modifier_attack_normal",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_storm_spirit",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_luna",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_dazzle",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_unarmored",
				},
				{	["name"]="npc_dota_hero_omniknight",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_lich",
					["attackType"]="modifier_attack_magical",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_sniper",
					["attackType"]="modifier_attack_pierce",
					["armorType"]="modifier_armor_medium",
				},
				{	["name"]="npc_dota_hero_treant",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_heavy",
				},
				{	["name"]="npc_dota_hero_antimage",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_light",
				},
				{	["name"]="npc_dota_hero_earth_spirit",
					["attackType"]="modifier_attack_hero",
					["armorType"]="modifier_armor_heavy",
				},
		}	

uniqueItems = { "item_nimsha",
				"item_bloodthirst",
				"item_small_round_shield",
				"item_iron_helmet",
				"item_elven_plate_mail",
				"item_elite_elven_boots",
				"item_thirsting_blade",
				"item_uthmors_mirror_blade",
				"item_ring_of_victory",
				"item_scepter_of_the_magi",
			}


if CEnfosGameMode == nil then
	CEnfosGameMode = class({})
	CEnfosGameMode.__index = CEnfosGameMode
end

-- Precache resources
function Precache( context )
	PrecacheResource( "model", "models/heroes/lone_druid/spirit_bear.vmdl", context )
	PrecacheResource( "model", "models/props_gameplay/recipe.mdl", context )
	PrecacheResource( "model", "models/props_structures/tower_good4.vmdl", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/necronomicon_archer_manaburn.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", context )
	PrecacheResource( "particle", "particles/hero_moon_mage/jakiro_liquid_fire_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/aura_assault.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_viper/viper_base_attack.vpcf", context )

	--Arhat
	PrecacheResource( "model", "models/heroes/invoker/invoker.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_cape.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_shoulder.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_head.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_hair.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_bracer.vmdl", context )
	PrecacheResource( "model", "models/heroes/invoker/invoker_dress.vmdl", context )

	--Uthmor
	PrecacheResource( "model", "models/heroes/elder_titan/ancestral_spirit.vmdl", context )

	--Sidhlot
	PrecacheResource( "model", "models/heroes/necrolyte/necrolyte_sickle.vmdl", context )
	PrecacheResource( "model", "models/heroes/necrolyte/beard.vmdl", context )
	PrecacheResource( "model", "models/heroes/necrolyte/hat.vmdl", context )
	PrecacheResource( "model", "models/heroes/necrolyte/shoulders.vmdl", context )
	PrecacheResource( "model", "models/heroes/necrolyte/necrolyte.vmdl", context )

	--Havroth
	PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_dragonspawn_a/n_creep_dragonspawn_a.vmdl", context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", context )
end

-- Actually make the game mode when we activate
function Activate()
	GameRules.Enfos = CEnfosGameMode()
	GameRules.Enfos:InitGameMode()

end


function CEnfosGameMode:InitGameMode()
	STARTING_GOLD = 25
	curRound = 0
	self._nRoundNumber = 1
	self._iGoodSpawnPoint = 1
	self._iBadSpawnPoint = 1
	self._currentRound = nil
	self._flLastThinkGameTime = nil
	self._entAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	if not self._entAncient then
		print( "Ancient entity not found!" )
	end

	self:_ReadGameConfiguration()
	GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroRespawnEnabled( true )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )
	GameRules:SetUseUniversalShopMode( false )
	GameRules:SetHeroSelectionTime( 60.0 )
	GameRules:SetPreGameTime( 45.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	--GameRules:SetHeroMinimapIconSize( 400 )
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1400 )		--1134 default dota 2
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )
	GameRules:SetGoldTickTime( 60.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, 100)
	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, 100)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled( false )
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( MAX_LEVEL )
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
	GameRules:GetGameModeEntity():SetFixedRespawnTime(-1)

	-- Custom console commands
	Convars:RegisterCommand( "Enfos_test_round", function(...) return self:_TestRoundConsoleCommand( ... ) end, "Test a round of Enfos.", FCVAR_CHEAT )
	Convars:RegisterCommand( "Enfos_status_report", function(...) return self:_StatusReportConsoleCommand( ... ) end, "Report the status of the current Enfos game.", FCVAR_CHEAT )
	Convars:RegisterCommand( "Enfos_reset_lives", function(...) return self:_ResetLivesConsoleCommand( ... ) end, "Reset the lives in the game", FCVAR_CHEAT )
	-- Set all towers invulnerable
	for _, tower in pairs( Entities:FindAllByName( "npc_dota_Enfos_tower_spawn_protection" ) ) do
		tower:AddNewModifier( tower, nil, "modifier_invulnerable", {} )
	end

	-- Hook into game events allowing reload of functions at run time
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CEnfosGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( CEnfosGameMode, "OnPlayerPicked" ), self )
	ListenToGameEvent( "player_reconnected", Dynamic_Wrap( CEnfosGameMode, 'OnPlayerReconnected' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CEnfosGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CEnfosGameMode, "OnGameRulesStateChange" ), self )
	ListenToGameEvent( "player_stats_updated", Dynamic_Wrap(CEnfosGameMode, 'OnPlayerStatsUpdated'), self)
	ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap(CEnfosGameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap(CEnfosGameMode, 'OnPlayerLevelledUp'), self)
	ListenToGameEvent( "dota_inventory_changed", Dynamic_Wrap(CEnfosGameMode, 'OnInventoryChanged'), self)
	ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap(CEnfosGameMode, 'OnItemPurchased'), self)
	ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap(CEnfosGameMode, 'OnAbilityCast'), self)
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap(CEnfosGameMode, 'OnItemPickedUp'), self)
	--ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CEnfosGameMode, "OnEntityHurt" ), self )

	-- Register OnThink with the game engine so it is called every 0.25 seconds
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
	GameRules:GetGameModeEntity():SetThink( "XpThink", self, "ExperienceThink", 0.25 )
	-- defining our global tables here. we need to populate them with initial player values or else we won't be able to index them.

	--Catch the Spellbringer UI
	--register the 'BuyAbilityPoint' command in our console
	Convars:RegisterCommand( "CastSpellbringerAbility", function(name, p)
	    --get the player that sent the command
	    local cmdPlayer = Convars:GetCommandClient()
	    if cmdPlayer then 
	        --if the player is valid, execute PlayerBuyAbilityPoint
	        return self:CastSpellbringerAbility( cmdPlayer, p ) 
	    end
	end, "A player casted an ability", 0 )
end


function CEnfosGameMode:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function CEnfosGameMode:XpThink()

    -- Check if the game is actual over
    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    else

        -- Loop for Radiant Players
        for xpPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
            teamID = PlayerResource:GetTeam(xpPlayerID)

            -- Get the highest XP value in Team of the current player
            for teamPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                if PlayerResource:GetTeam(teamPlayerID) == DOTA_TEAM_GOODGUYS then
                    if radiantXP < PlayerResource:GetTotalEarnedXP(teamPlayerID) then
                        radiantXP = PlayerResource:GetTotalEarnedXP(teamPlayerID)
                    end
                end
            end         

            -- Give XP to current Player if needed
            if PlayerResource:GetSelectedHeroEntity(xpPlayerID) ~= nil then
                if radiantXP > PlayerResource:GetSelectedHeroEntity(xpPlayerID):GetCurrentXP() and PlayerResource:GetTeam(xpPlayerID) == DOTA_TEAM_GOODGUYS then
                	local currentXP = PlayerResource:GetSelectedHeroEntity(xpPlayerID):GetCurrentXP()
                	local xpBonus = radiantXP - currentXP
                    PlayerResource:GetSelectedHeroEntity(xpPlayerID):AddExperience(xpBonus, false)
                end
            end
        end

         -- Loop for Dire Players
        for xpPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
            teamID = PlayerResource:GetTeam(xpPlayerID)

            -- Get the highest XP value in Team of the current player
            for teamPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                if PlayerResource:GetTeam(teamPlayerID) == DOTA_TEAM_BADGUYS then
                    if direXP < PlayerResource:GetTotalEarnedXP(teamPlayerID) then
                        direXP = PlayerResource:GetTotalEarnedXP(teamPlayerID)
                    end
                end
            end         

            -- Give XP to current Player if needed
            if PlayerResource:GetSelectedHeroEntity(xpPlayerID) ~= nil then
                if direXP > PlayerResource:GetSelectedHeroEntity(xpPlayerID):GetCurrentXP() and PlayerResource:GetTeam(xpPlayerID) == DOTA_TEAM_BADGUYS then
                	local currentXP = PlayerResource:GetSelectedHeroEntity(xpPlayerID):GetCurrentXP()
                	local xpBonus = direXP - currentXP
                    PlayerResource:GetSelectedHeroEntity(xpPlayerID):AddExperience(xpBonus, false)
                end
            end
        end
        -- Repeater Thinker every 0.25 seconds
        return 0.25
    end
end

--Spellbringer casting from UI
function CEnfosGameMode:CastSpellbringerAbility(player, p)
	local price = 200
	local pID = player:GetPlayerID()
	local playerGold = PlayerResource:GetGold(pID)
	local playerHero = player:GetAssignedHero()

	local abilityToCast = playerHero:FindAbilityByName("evoker_gar_zeng_proxy")

	playerHero:CastAbilityNoTarget(abilityToCast, -1)
end

-- Read and assign configurable keyvalues if applicable
function CEnfosGameMode:_ReadGameConfiguration()
	local kv = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	kv = kv or {} -- Handle the case where there is not keyvalues file

	self._bAlwaysShowPlayerGold = kv.AlwaysShowPlayerGold or false
	self._bRestoreHPAfterRound = kv.RestoreHPAfterRound or false
	self._bRestoreMPAfterRound = kv.RestoreMPAfterRound or false
	self._bRewardForTowersStanding = kv.RewardForTowersStanding or false
	self._bUseReactiveDifficulty = kv.UseReactiveDifficulty or false

	self._nTowerRewardAmount = tonumber( kv.TowerRewardAmount or 0 )
	self._nTowerScalingRewardPerRound = tonumber( kv.TowerScalingRewardPerRound or 0 )

	self._flPrepTimeBetweenRounds = tonumber( kv.PrepTimeBetweenRounds or 0 )

	--self:_ReadRandomSpawnsConfiguration( kv["RandomSpawns"] )
	
	self:_ReadRadiantSpawnsConfiguration( kv["RadiantSpawns"] )
	
	self:_ReadDireSpawnsConfiguration( kv["DireSpawns"] )
	--self:_ReadLootItemDropsConfiguration( kv["ItemDrops"] )
	self:_ReadRoundConfigurations( kv )
end

-- Verify spawners if random is set
function CEnfosGameMode:ChooseRadiantSpawnInfo()
	if #self._vRadiantSpawnsList == 0 then
		error( "Attempt to choose a radiant spawn, but no radiant spawns are specified in the data." )
		return nil
	end
	self._iGoodSpawnPoint = self._iGoodSpawnPoint + 1
	if self._iGoodSpawnPoint > #self._vRadiantSpawnsList then
		self._iGoodSpawnPoint = 1
	end
	return self._vRadiantSpawnsList[self._iGoodSpawnPoint]
end

-- Verify spawners if random is set
function CEnfosGameMode:ChooseDireSpawnInfo()
	if #self._vDireSpawnsList == 0 then
		error( "Attempt to choose a dire spawn, but no dire spawns are specified in the data." )
		return nil
	end
	self._iBadSpawnPoint = self._iBadSpawnPoint + 1
	if self._iBadSpawnPoint > #self._vDireSpawnsList then
		self._iBadSpawnPoint = 1
	end
	return self._vDireSpawnsList[self._iBadSpawnPoint]
end


-- Verify valid spawns are defined and build a table with them from the keyvalues file
function CEnfosGameMode:_ReadRadiantSpawnsConfiguration( kvSpawns )
	self._vRadiantSpawnsList = {}
	if type( kvSpawns ) ~= "table" then
		return
	end
	for _,sp in pairs( kvSpawns ) do			-- Note "_" used as a shortcut to create a temporary throwaway variable
		table.insert( self._vRadiantSpawnsList, {
			szRadiantSpawnerName = sp.SpawnerName or "",
			szRadiantFirstWaypoint = sp.Waypoint or ""
		} )
	end
end

-- Verify valid spawns are defined and build a table with them from the keyvalues file
function CEnfosGameMode:_ReadDireSpawnsConfiguration( kvSpawns )
	self._vDireSpawnsList = {}
	if type( kvSpawns ) ~= "table" then
		return
	end
	for _,sp in pairs( kvSpawns ) do			-- Note "_" used as a shortcut to create a temporary throwaway variable
		table.insert( self._vDireSpawnsList, {
			szDireSpawnerName = sp.SpawnerName or "",
			szDireFirstWaypoint = sp.Waypoint or ""
		} )
	end
end

-- Set number of rounds without requiring index in text file
function CEnfosGameMode:_ReadRoundConfigurations( kv )
	self._vRounds = {}
	while true do
		local szRoundName = string.format("Round%d", #self._vRounds + 1 )
		local kvRoundData = kv[ szRoundName ]
		if kvRoundData == nil then
			return
		end
		local roundObj = CEnfosGameRound()
		roundObj:ReadConfiguration( kvRoundData, self, #self._vRounds + 1 )
		table.insert( self._vRounds, roundObj )
	end
end


-- When game state changes set state in script
function CEnfosGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		--ShowGenericPopup( "#Enfos_instructions_title", "#Enfos_instructions_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
		
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--self:_RespawnPlayers()
		self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
	end
end


-- Evaluate the state of the game
function CEnfosGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:_CheckForDefeat()

		if self._flPrepTimeEnd ~= nil then
			self:_ThinkPrepTime()
		elseif self._currentRound ~= nil then
			self._currentRound:Think()
			if self._currentRound:IsFinished() then
				self._currentRound:End()
				self._currentRound = nil
				-- Heal all players
				-- self:_RefreshPlayers()

				self._nRoundNumber = self._nRoundNumber + 1
				if self._nRoundNumber > #self._vRounds then
					self._nRoundNumber = 1
					GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
				else
					self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
				end
			end

	end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end
	return 1
end


function CEnfosGameMode:_RefreshPlayers()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
					hero:RespawnUnit()
				end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
			end
		end
	end
end

function CEnfosGameMode:_RespawnPlayers()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
			hero:RespawnUnit()
		end
	end
end


function CEnfosGameMode:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end

	-- local bAllPlayersDead = true
	-- for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		-- if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			-- if not PlayerResource:HasSelectedHero( nPlayerID ) then
				-- bAllPlayersDead = false
			-- else
				-- local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				-- if hero and hero:IsAlive() then
					-- bAllPlayersDead = false
				-- end
			-- end
		-- end
	-- end
end


function CEnfosGameMode:_ThinkPrepTime()
	if GameRules:GetGameTime() >= self._flPrepTimeEnd then
		self._flPrepTimeEnd = nil
		if self._entPrepTimeQuest then
			UTIL_RemoveImmediate( self._entPrepTimeQuest )
			self._entPrepTimeQuest = nil
		end

		if self._nRoundNumber > #self._vRounds then
			GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
			return false
		end
		self._currentRound = self._vRounds[ self._nRoundNumber ]
		self._currentRound:Begin()
			curRound = curRound + 1
			local goldAmount = curRound * 25
			for nPlayerID = 0, 9 do
				if ( PlayerResource:IsValidPlayer( nPlayerID ) ) then
					local player = PlayerResource:GetPlayer(nPlayerID):GetAssignedHero()
					player:SetGold(player:GetGold()+goldAmount, false)
				end
			end
			if curRound == 6 or curRound == 27 then
				GameRules:SendCustomMessage("This wave has invisible monsters -", 0, 0)
				GameRules:SendCustomMessage("Make sure you buy <font color='#58ACFA'>Sentry Wards</font>!!", 0, 0)
			end

			if curRound == 20 or curRound == 36 then
				GameRules:SendCustomMessage("<font color='#58ACFA'>Bonus Wave!!</font>", 0, 0)
				GameRules:SendCustomMessage("Successfully killing a mob grants a bonus life", 0, 0)
			end
		return
	end

	if not self._entPrepTimeQuest then
		self._entPrepTimeQuest = SpawnEntityFromTableSynchronous( "quest", { name = "PrepTime", title = "#DOTA_Quest_Enfos_PrepTime" } )
		self._entPrepTimeQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, self._nRoundNumber )
		self._entPrepTimeQuest:SetTextReplaceString( self:GetDifficultyString() )

		self._vRounds[ self._nRoundNumber ]:Precache()
	end
	self._entPrepTimeQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self._flPrepTimeEnd - GameRules:GetGameTime() )
end

function CEnfosGameMode:GetDifficultyString()
	local nDifficulty = GameRules:GetCustomGameDifficulty()
	if nDifficulty > 4 then
		return string.format( "(+%d)", nDifficulty )
	elseif nDifficulty > 0 then
		return string.rep( "+", nDifficulty )
	else
		return ""
	end
end


function CEnfosGameMode:_SpawnHeroClientEffects( hero, nPlayerID )
	-- Spawn these effects on the client, since we don't need them to stay in sync or anything
	-- ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/generic_gameplay/winter_effects_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer( nPlayerID ) ) )	-- Attaches the breath effects to players for winter maps
	--ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/frostivus_gameplay/frostivus_hero_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer( nPlayerID ) ) )
end

function CEnfosGameMode:OnPlayerPicked( event )
	local spawnedUnit = event.hero
	local spawnedUnitIndex = EntIndexToHScript(event.heroindex)
	
	-- we have to handle exceptions here, since not all units will have their passive on index 4. we can add "ors" here later
	if spawnedUnitIndex:GetClassname() == "npc_dota_hero_luna" then
		spawnedUnitIndex:GetAbilityByIndex(5):SetLevel(1)
		--Moon glaives

		spawnedUnitIndex:GetAbilityByIndex(6):SetLevel(1)
	else
		spawnedUnitIndex:GetAbilityByIndex(4):SetLevel(1)
	end
	--local statAbility = spawnedUnitIndex:FindAbilityByName("spell_dummy_modifier")
	--if statAbility ~= nil then
	--	statAbility:SetLevel(1)
	--end
	spawnedUnitIndex:SetGold(STARTING_GOLD, false)

	local spellbringerName = nil
	local spellbringerLocation = nil
	local playerID = spawnedUnitIndex:GetPlayerID()
	playerID = playerID + 1
	spellbringerName = "spellbringer_"..playerID

	if spellbringerName ~= nil then
		spellbringerLocation = Entities:FindByName( nil, spellbringerName ):GetAbsOrigin()
	end
	Timers:CreateTimer(DoUniqueString("spawnSpellbringer"), {
		endTime = 0.1,
		callback = function()
			if spellbringerLocation ~= nil then
				local unit2 = CreateUnitByName("npc_spellbringer", spellbringerLocation, false, spawnedUnitIndex, spawnedUnitIndex, spawnedUnitIndex:GetTeamNumber())
				unit2:SetControllableByPlayer(spawnedUnitIndex:GetPlayerID(), true)
				--FindClearSpaceForUnit(unit2, spellbringerLocation, true)
				unit2:RemoveModifierByName("modifier_tower_truesight_aura")
				unit2:RemoveModifierByName("modifier_invulnerable")
			else
				print("Incorrect spellbringer location!!")
			end
		end
	})

	local heroPicked = spawnedUnitIndex:GetUnitName()
	local heroArmorType = nil
	local heroAttackType = nil
	for i = 1, #heroTable do
		if heroArmorType == nil or heroAttackType == nil then
			if heroTable[i].name == heroPicked then
				heroArmorType = heroTable[i].armorType
				heroAttackType = heroTable[i].attackType
			end
		end
	end
	if heroArmorType ~= nil then
		local armorType = CreateItem("item_armor_type_modifier", nil, nil) 
		armorType:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, heroArmorType, {})
		UTIL_RemoveImmediate(armorType)
		armorType = nil
	end

	if heroAttackType ~= nil then
		local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
		attackItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, heroAttackType, {})
		UTIL_RemoveImmediate(attackItem)
		attackItem = nil
	end

	-- Apply timer to update stats
	CEnfosGameMode:ModifyStatBonuses(spawnedUnitIndex)


end

function CEnfosGameMode:ModifyStatBonuses(unit)
	local spawnedUnitIndex = unit
		Timers:CreateTimer(DoUniqueString("updateHealth_" .. spawnedUnitIndex:GetPlayerID()), {
		endTime = 0.25,
		callback = function()
			-- ==================================
			-- Adjust health based on strength
			-- ==================================

			-- Get player strength
			local strength = spawnedUnitIndex:GetStrength()

			--Check if strBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.strBonus == nil then
				spawnedUnitIndex.strBonus = 0
			end

			-- If player strength is different this time around, start the adjustment
			if strength ~= spawnedUnitIndex.strBonus then
				-- Modifier values
				local bitTable = {512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier("modifier_health_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_health_mod_" .. val)
					end
				end
				
				-- Creates temporary item to steal the modifiers from
				local healthUpdater = CreateItem("item_health_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(strength / val)
					if count >= 1 then
						healthUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_health_mod_" .. val, {})
						strength = strength - val
					end
				end
				-- Cleanup
				UTIL_RemoveImmediate(healthUpdater)
				healthUpdater = nil
			end
			-- Updates the stored strength bonus value for next timer cycle
			spawnedUnitIndex.strBonus = spawnedUnitIndex:GetStrength()


			-- ==================================
			-- Adjust mana based on Intellect
			-- ==================================

			-- Get player intellect
			local intellect = spawnedUnitIndex:GetIntellect()

			--Check if intBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.intBonus == nil then
				spawnedUnitIndex.intBonus = 0
			end

			-- If player int is different this time around, start the adjustment
			if intellect ~= spawnedUnitIndex.intBonus then
				-- Modifier values
				local bitTable = {512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier("modifier_mana_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_mana_mod_" .. val)
					end
				end
				
				-- Creates temporary item to steal the modifiers from
				local manaUpdater = CreateItem("item_mana_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(intellect / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_mana_mod_" .. val, {})
						intellect = intellect - val
					end
				end

				-- Cleanup
				UTIL_RemoveImmediate(manaUpdater)
				manaUpdater = nil
			end
			-- Updates the stored Int bonus value for next timer cycle
			spawnedUnitIndex.intBonus = spawnedUnitIndex:GetIntellect()


			-- ==================================
			-- Adjust damage based on primary stat
			-- ==================================

			-- Get player primary stat value
			local primStat = spawnedUnitIndex:GetPrimaryStatValue()

			--Check if primaryStatBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.primaryStatBonus == nil then
				spawnedUnitIndex.primaryStatBonus = 0
			end

			-- If player int is different this time around, start the adjustment
			if primStat ~= spawnedUnitIndex.primaryStatBonus then
				-- Modifier values
				local bitTable = {512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier( "modifier_damage_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_damage_mod_" .. val)
					end
				end
				
				-- Creates temporary item to steal the modifiers from
				local manaUpdater = CreateItem("item_damage_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(primStat / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_damage_mod_" .. val, {})
						primStat = primStat - val
					end
				end

				-- Cleanup
				UTIL_RemoveImmediate(manaUpdater)
				manaUpdater = nil
			end
			-- Updates the stored Int bonus value for next timer cycle
			spawnedUnitIndex.primaryStatBonus = spawnedUnitIndex:GetPrimaryStatValue()

			-- ==================================
			-- Adjust armor based on agi
			-- ==================================

			-- Get player primary stat value
			local agility = spawnedUnitIndex:GetAgility()

			--Check if primaryStatBonus is stored on hero, if not set it to 0
			if spawnedUnitIndex.agilityBonus == nil then
				spawnedUnitIndex.agilityBonus = 0
			end

			-- If player int is different this time around, start the adjustment
			if agility ~= spawnedUnitIndex.agilityBonus then
				-- Modifier values
				local bitTable = {512,256,128,64,32,16,8,4,2,1}

				-- Gets the list of modifiers on the hero and loops through removing and health modifier
				for u = 1, #bitTable do
					local val = bitTable[u]
					if spawnedUnitIndex:HasModifier( "modifier_armor_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_armor_mod_" .. val)
					end
					
					if spawnedUnitIndex:HasModifier( "modifier_negative_armor_mod_" .. val)  then
						spawnedUnitIndex:RemoveModifierByName("modifier_negative_armor_mod_" .. val)
					end
				end
				agility = agility / 7
				-- Remove Armor
				-- Creates temporary item to steal the modifiers from
				local manaUpdater = CreateItem("item_armor_modifier", nil, nil) 
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_negative_armor_mod_" .. val, {})
						agility = agility - val
					end
				end

				-- Calculate armor per 20 agility
				agility = spawnedUnitIndex:GetAgility()
				agility = agility / 20
				--Add armor from bitfield
				for p=1, #bitTable do
					local val = bitTable[p]
					local count = math.floor(agility / val)
					if count >= 1 then
						manaUpdater:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, "modifier_armor_mod_" .. val, {})
						agility = agility - val
					end
				end

				-- Cleanup
				UTIL_RemoveImmediate(manaUpdater)
				manaUpdater = nil
			end
			-- Updates the stored Int bonus value for next timer cycle
			spawnedUnitIndex.agilityBonus = spawnedUnitIndex:GetAgility()
			return 0.25
		end
	})
end

function CEnfosGameMode:OnPlayerStatsUpdated( event )
end	

function CEnfosGameMode:OnPlayerLearnedAbility( event )

	local player = event.player - 1
	if PlayerResource:IsValidPlayer( player ) then
		local hero = PlayerResource:GetSelectedHeroEntity(player)
		--GameRules.Enfos:UpdateBaseStats(hero)
	else
		print("Invalid player!")
	end
end

function CEnfosGameMode:OnInventoryChanged( event )
	print("Player inventory changed")
	local player = event.PlayerID 
	if PlayerResource:IsValidPlayer( player ) then
		local hero = PlayerResource:GetSelectedHeroEntity(player)
		--GameRules.Enfos:UpdateBaseStats(hero)
	else
		print("Invalid player!")
	end
end

function CEnfosGameMode:OnItemPickedUp(event)
	--PrintTable(event)
	local itemname = event.itemname
	local player = event.PlayerID 
	local hero = nil
	if PlayerResource:IsValidPlayer( player ) then
		hero = PlayerResource:GetSelectedHeroEntity(player)
		
	else
		print("Invalid player!")
	end

	-- Automatically drops the new unique item if a previous unique is found.
	local uniqueItemCount = 0
	for i=1, #uniqueItems do
		for item = 0, 18 do
			if hero:GetItemInSlot(item) ~= nil then
				if hero:GetItemInSlot(item):GetName() == uniqueItems[i] then
					uniqueItemCount = uniqueItemCount + 1
					--print(uniqueItemCount)
				end
			end
		end
	end
	Timers:CreateTimer(DoUniqueString("itemPickup"), {
		endTime = 0.01,
		callback = function()
			while uniqueItemCount > 1 do
				for p=1, #uniqueItems do
					if hero:HasItemInInventory(uniqueItems[p]) then
						for item = 0, 18 do
							if hero:GetItemInSlot(item) ~= nil then
								if hero:GetItemInSlot(item):GetName() == itemname then
									hero:DropItemAtPosition(hero:GetAbsOrigin(), hero:GetItemInSlot(item))
								end
							end
						end
						uniqueItemCount = uniqueItemCount - 1
					end
				end
			end
		end
	})


	

end
function CEnfosGameMode:OnItemPurchased(event)
	--PrintTable(event)
	local itemname = event.itemname
	local player = event.PlayerID 
	local hero = nil
	if PlayerResource:IsValidPlayer( player ) then
		hero = PlayerResource:GetSelectedHeroEntity(player)
		
	else
		print("Invalid player!")
	end

	-- Autocasts tomes if found in inventory
	if string.find(itemname, "item_tome") then
		local itemSlot = -1
		for item = 0, 18 do
			if hero:GetItemInSlot(item) ~= nil then
				if hero:GetItemInSlot(item):GetName() == itemname then
					itemSlot = item
				end
			end
		end
		hero:CastAbilityImmediately(hero:GetItemInSlot(itemSlot), player)
	end


	-- Automatically drops the new unique item if a previous unique is found.
	local uniqueItemCount = 0
	for i=1, #uniqueItems do
		for item = 0, 18 do
			if hero:GetItemInSlot(item) ~= nil then
				if hero:GetItemInSlot(item):GetName() == uniqueItems[i] then
					uniqueItemCount = uniqueItemCount + 1
					--print(uniqueItemCount)
				end
			end
		end
	end

	while uniqueItemCount > 1 do
		for p=1, #uniqueItems do
			if hero:HasItemInInventory(uniqueItems[p]) then
				for item = 0, 18 do
					if hero:GetItemInSlot(item) ~= nil then
						if hero:GetItemInSlot(item):GetName() == itemname then
							hero:DropItemAtPosition(hero:GetAbsOrigin(), hero:GetItemInSlot(item))
						end
					end
				end
				uniqueItemCount = uniqueItemCount - 1
			end
		end
	end
end


function CEnfosGameMode:OnPlayerLevelledUp( event )

	local player = event.player - 1
	if PlayerResource:IsValidPlayer( player ) then
		local hero = PlayerResource:GetSelectedHeroEntity(player)
		--GameRules.Enfos:UpdateBaseStats(hero)
	else
		print("Invalid player!")
	end
end


function CEnfosGameMode:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	 if spawnedUnit:IsCreature() then
	 	if spawnedUnit:GetUnitName() == "npc_dota_neutral_satyr_reaver" then
			spawnedUnit:AddNewModifier(caster, nil, "modifier_tower_truesight_aura", {})
	 	end
		-- spawnedUnit:SetHPGain( spawnedUnit:GetMaxHealth() * 0.3 ) -- LEVEL SCALING VALUE FOR HP
	 end

	 if spawnedUnit:IsHero() then
	 	spawnedUnit.strBonus = 0
	 	spawnedUnit.intBonus = 0
	 	spawnedUnit.primaryStatBonus = 0
	 end

end


-- Attach client-side hero effects for a reconnecting player
function CEnfosGameMode:OnPlayerReconnected( event )
	local nReconnectedPlayerID = event.PlayerID
	for _, hero in pairs( Entities:FindAllByClassname( "npc_dota_hero" ) ) do
		if hero:IsRealHero() then
			self:_SpawnHeroClientEffects( hero, nReconnectedPlayerID )
		end
	end
end


function CEnfosGameMode:OnEntityKilled( event )
	local killer = EntIndexToHScript( event.entindex_attacker )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local exp = killedUnit:GetDeathXP()
	if not killedUnit or killedUnit:GetClassname() == "npc_dota_thinker" or killedUnit:IsPhantom() then
		return
	end

	local corpseBlacklist = {
				"npc_dota_creature_wood_troll",
				"npc_dota_rock_troll",
				"npc_dota_mottled_westanuryn",
				"npc_dota_spirit_hawk",
				"npc_dota_death_spirit",
				"npc_dota_rock_guardian",
				"npc_dota_skeletal_sailor",
				"npc_dota_armored_warklin",
				"npc_dota_snaer_hafwa",
				"npc_dota_slai_screamer"
							}

	--print(killer)
	if killedUnit:IsCreature() then
		--Set all killed units to have a corpse on default
		if killedUnit.noCorpse == nil then
			killedUnit.noCorpse = false
		end

		for i=1, #corpseBlacklist do
			if killedUnit:GetUnitName() == corpseBlacklist[i] then
				killedUnit.noCorpse = true
			end
		end

		if killedUnit:GetUnitName() == "npc_dota_spirit_hawk" or killedUnit:GetUnitName() == "npc_dota_spirit_owl" then
			if killer:IsHero() then
				local killerTeam = killer:GetTeam()
				if(killerTeam == 2) then
					Triggers._goodLives = Triggers._goodLives + 1
					GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, Triggers._goodLives)
				elseif(killerTeam == 3) then
					Triggers._badLives = Triggers._badLives + 1
					GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, Triggers._badLives)
				end
			end
		end
	end

	--if killedUnit:IsHero() then
	--	killedUnit:SetBuybackGoldLimitTime(0)
	--	killedUnit:SetBuybackCooldownTime(0)
	--end
end

function CEnfosGameMode:OnEntityHurt( event )
	--PrintTable(event)
end

function CEnfosGameMode:OnAbilityCast( keys )
	--PrintTable(keys)
	local abilityName = keys.abilityname
	--local ply = keys.PlayerID
	--local hero = keys.PlayerID:GetAssignedHero()
	return

	
end

function CEnfosGameMode:ComputeTowerBonusGold( nTowersTotal, nTowersStanding )
	local nRewardPerTower = self._nTowerRewardAmount + self._nTowerScalingRewardPerRound * (self._nRoundNumber - 1)
	return nRewardPerTower * nTowersStanding
end




ROUND_EXPECTED_VALUES_TABLE = {

}

-- Custom game specific console command "Enfos_test_round"
function CEnfosGameMode:_TestRoundConsoleCommand( cmdName, roundNumber, delay )
	local nRoundToTest = tonumber( roundNumber )
	print (string.format( "Testing round %d", nRoundToTest ) )
	if nRoundToTest <= 0 or nRoundToTest > #self._vRounds then
		Msg( string.format( "Cannot test invalid round %d", nRoundToTest ) )
		return
	end
	curRound = nRoundToTest - 1

	if self._entPrepTimeQuest then
		UTIL_RemoveImmediate( self._entPrepTimeQuest )
		self._entPrepTimeQuest = nil
	end

	if self._currentRound ~= nil then
		self._currentRound:End()
		self._currentRound = nil
	end

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if containedItem then
			UTIL_RemoveImmediate( containedItem )
		end
		UTIL_RemoveImmediate( item )
	end

	if self._entAncient and not self._entAncient:IsNull() then
		self._entAncient:SetHealth( self._entAncient:GetMaxHealth() )
	end

	self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
	self._nRoundNumber = nRoundToTest
	if delay ~= nil then
		self._flPrepTimeEnd = GameRules:GetGameTime() + tonumber( delay )
	end
end

function CEnfosGameMode:_StatusReportConsoleCommand( cmdName )
	print( "*** Enfos Status Report ***" )
	print( string.format( "Current Round: %d", self._nRoundNumber ) )
	if self._currentRound then
		self._currentRound:StatusReport()
	end
	print( "*** Enfos Status Report End *** ")
end

function CEnfosGameMode:_ResetLivesConsoleCommand( cmdName )
	print( "*** Enfos Life Reset ***" )
	print(Triggers._badLives)
	print(Triggers._goodLives)
	Triggers._badLives = 100
	Triggers._goodLives = 100

	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, Triggers._goodLives)

	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, Triggers._badLives)
end



