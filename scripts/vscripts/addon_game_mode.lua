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

if CEnfosGameMode == nil then
	CEnfosGameMode = class({})
end

-- Precache resources
function Precache( context )
	PrecacheResource( "model", "models/heroes/lone_druid/spirit_bear.vmdl", context )
	PrecacheResource( "model", "models/props_gameplay/recipe.mdl", context )
end

-- Actually make the game mode when we activate
function Activate()
	GameRules.Enfos = CEnfosGameMode()
	GameRules.Enfos:InitGameMode()
end


function CEnfosGameMode:InitGameMode()
	self._nRoundNumber = 1
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
	GameRules:SetPreGameTime( 30.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconSize( 400 )
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
	GameRules:GetGameModeEntity():SetFogOfWarDisabled( true )
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( 50 )
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

	-- Custom console commands
	Convars:RegisterCommand( "Enfos_test_round", function(...) return self:_TestRoundConsoleCommand( ... ) end, "Test a round of Enfos.", FCVAR_CHEAT )
	Convars:RegisterCommand( "Enfos_status_report", function(...) return self:_StatusReportConsoleCommand( ... ) end, "Report the status of the current Enfos game.", FCVAR_CHEAT )
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
	--ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CEnfosGameMode, "OnEntityHurt" ), self )

	-- Register OnThink with the game engine so it is called every 0.25 seconds
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 ) 
end

function CEnfosGameMode:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
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

	return self._vRadiantSpawnsList[ RandomInt( 1, #self._vRadiantSpawnsList ) ]
end

-- Verify spawners if random is set
function CEnfosGameMode:ChooseDireSpawnInfo()
	if #self._vDireSpawnsList == 0 then
		error( "Attempt to choose a dire spawn, but no dire spawns are specified in the data." )
		return nil
	end
	return self._vDireSpawnsList[ RandomInt( 1, #self._vDireSpawnsList ) ]
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
	ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/frostivus_gameplay/frostivus_hero_light.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero, PlayerResource:GetPlayer( nPlayerID ) ) )
end

function CEnfosGameMode:OnPlayerPicked( event )
	--PrintTable(event)
	local spawnedUnit = event.hero
	 -- Attach client side hero effects on spawning players
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if ( PlayerResource:IsValidPlayer( nPlayerID ) ) then
			PlayerResource:GetPlayer(nPlayerID):GetAssignedHero():GetAbilityByIndex(4):SetLevel(1)
		end
	end
end

function CEnfosGameMode:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	 if spawnedUnit:IsCreature() then
		-- spawnedUnit:SetHPGain( spawnedUnit:GetMaxHealth() * 0.3 ) -- LEVEL SCALING VALUE FOR HP
		-- spawnedUnit:SetManaGain( 0 )
		-- spawnedUnit:SetHPRegenGain( 0 )
		-- spawnedUnit:SetManaRegenGain( 0 )
		-- if spawnedUnit:IsRangedAttacker() then
			-- spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.1 ) -- LEVEL SCALING VALUE FOR DPS
		-- else
			-- spawnedUnit:SetDamageGain( ( ( spawnedUnit:GetBaseDamageMax() + spawnedUnit:GetBaseDamageMin() ) / 2 ) * 0.2 ) -- LEVEL SCALING VALUE FOR DPS
		-- end
		-- spawnedUnit:SetArmorGain( 0 )
		-- spawnedUnit:SetMagicResistanceGain( 0 )
		-- spawnedUnit:SetDisableResistanceGain( 0 )
		-- spawnedUnit:SetAttackTimeGain( 0 )
		 spawnedUnit:SetMoveSpeedGain( 0 )
		-- spawnedUnit:SetBountyGain( 0 )
		-- spawnedUnit:SetXPGain( 0 )
		-- spawnedUnit:CreatureLevelUp( GameRules:GetCustomGameDifficulty() )
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

end

function CEnfosGameMode:OnEntityHurt( event )
	PrintTable(event)
end


function CEnfosGameMode:ComputeTowerBonusGold( nTowersTotal, nTowersStanding )
	local nRewardPerTower = self._nTowerRewardAmount + self._nTowerScalingRewardPerRound * (self._nRoundNumber - 1)
	return nRewardPerTower * nTowersStanding
end

-- Leveling/gold data for console command "Enfos_test_round"
XP_PER_LEVEL_TABLE = {
	0,-- 1
	200,-- 2
	400,-- 3
	600,-- 4
	800,-- 5
	1000,-- 6
	1200,-- 7
	1400,-- 8
	1600,-- 9
	1800,-- 10
	2000,-- 11
	2200,-- 12
	2400,-- 13
	2600,-- 14
	2800,-- 15
	3000,-- 16
	3200,-- 17
	3400,-- 18
	3600,-- 19
	3800,-- 20
	4000,-- 21
	4200,-- 22
	4400,-- 23
	4600,-- 24
	4800, -- 25
	5000, -- 26
	5200, -- 27
	5400, -- 28
	5600, -- 29
	5800, -- 30
	6000, -- 31
	6200, -- 32
	6400, -- 33
	6600, -- 34
	6800, -- 35
	7000, -- 36
	7200, -- 37
	7400, -- 38
	7600, -- 39
	7800, -- 40
	8000, -- 41
	8200, -- 42
	8400, -- 43
	8600, -- 44
	8800, -- 45
	9000, -- 46
	9200, -- 47
	9400, -- 48
	9600, -- 49
	9800, -- 50
	10000 -- 51
}

STARTING_GOLD = 1200
ROUND_EXPECTED_VALUES_TABLE = {
	{ gold = STARTING_GOLD, xp = 0 }, -- 1
	{ gold = 1054+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[4] }, -- 2
	{ gold = 2212+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[5] }, -- 3
	{ gold = 3456+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[6] }, -- 4
	{ gold = 4804+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[8] }, -- 5
	{ gold = 6256+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[9] }, -- 6
	{ gold = 7812+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[9] }, -- 7
	{ gold = 9471+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[10] }, -- 8
	{ gold = 11234+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[11] }, -- 9
	{ gold = 13100+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[13] }, -- 10
	{ gold = 15071+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[13] }, -- 11
	{ gold = 17145+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[14] }, -- 12
	{ gold = 19322+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[16] }, -- 13
	{ gold = 21604+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[18] }, -- 14
	{ gold = 23368+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[18] } -- 15
}

-- Custom game specific console command "Enfos_test_round"
function CEnfosGameMode:_TestRoundConsoleCommand( cmdName, roundNumber, delay )
	local nRoundToTest = tonumber( roundNumber )
	print (string.format( "Testing round %d", nRoundToTest ) )
	if nRoundToTest <= 0 or nRoundToTest > #self._vRounds then
		Msg( string.format( "Cannot test invalid round %d", nRoundToTest ) )
		return
	end

	local nExpectedGold = ROUND_EXPECTED_VALUES_TABLE[nRoundToTest].gold or 600
	local nExpectedXP = ROUND_EXPECTED_VALUES_TABLE[nRoundToTest].xp or 0
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			PlayerResource:ReplaceHeroWith( nPlayerID, PlayerResource:GetSelectedHeroName( nPlayerID ), nExpectedGold, nExpectedXP )
			PlayerResource:SetBuybackCooldownTime( nPlayerID, 0 )
			PlayerResource:SetBuybackGoldLimitTime( nPlayerID, 0 )
			PlayerResource:ResetBuybackCostTime( nPlayerID )
		end
	end

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



