--[[
	CEnfosGameRound - A single round of Enfos
]]
ROUND_TIME = 80

if CEnfosGameRound == nil then
	CEnfosGameRound = class({})
end


function CEnfosGameRound:ReadConfiguration( kv, gameMode, roundNumber )
	self._gameMode = gameMode
	self._nRoundNumber = roundNumber
	self._szRoundQuestTitle = kv.round_quest_title or "#DOTA_Quest_Enfos_Round"
	self._szRoundTitle = kv.round_title or string.format( "Round%d", roundNumber )

	self._nFixedXP = tonumber( kv.FixedXP or 0 )

	self._vSpawners = {}
	for k, v in pairs( kv ) do
		if type( v ) == "table" and v.NPCName then
			local spawner = CEnfosGameSpawner()
			spawner:ReadConfiguration( k, v, self )
			self._vSpawners[ k ] = spawner
		end
	end

	for _, spawner in pairs( self._vSpawners ) do
		spawner:PostLoad( self._vSpawners )
	end
end


function CEnfosGameRound:Precache()
	for _, spawner in pairs( self._vSpawners ) do
		spawner:Precache()
	end
end

function CEnfosGameRound:Begin()
	self._vEnemiesRemaining = {}
	self._vEventHandles = {
		ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CEnfosGameRound, "OnNPCSpawned" ), self ),
		--ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CEnfosGameRound, 'OnItemPickedUp' ), self ),
	}
	ROUND_TIME = 40
	self._vPlayerStats = {}
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		self._vPlayerStats[ nPlayerID ] = {
			nCreepsKilled = 0,
			nPriorRoundDeaths = PlayerResource:GetDeaths( nPlayerID ),
		}
	end

	self._nCoreUnitsTotal = 0
	for _, spawner in pairs( self._vSpawners ) do
		spawner:Begin()
		self._nCoreUnitsTotal = self._nCoreUnitsTotal + spawner:GetTotalUnitsToSpawn()
	end
	self._nCoreUnitsKilled = 0

	self._entQuest = SpawnEntityFromTableSynchronous( "quest", {
		name = self._szRoundTitle,
		title =  self._szRoundQuestTitle
	})
	self._entQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_ROUND, self._nRoundNumber )
	self._entQuest:SetTextReplaceString( self._gameMode:GetDifficultyString() )

	self._entKillCountSubquest = SpawnEntityFromTableSynchronous( "subquest_base", {
		show_progress_bar = true,
		progress_bar_hue_shift = 0
	} )
	self._entQuest:AddSubquest( self._entKillCountSubquest )
	self._entKillCountSubquest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, ROUND_TIME )
	Timers:CreateTimer(DoUniqueString("round_timer"), {
		endTime = 1, -- guessing on the interval. it's not listed.
		callback = function()
			self._entKillCountSubquest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, ROUND_TIME)
			ROUND_TIME = ROUND_TIME - 1
			if ROUND_TIME > 0 then
				return 1
			elseif ROUND_TIME <= 0 then
				return
			end
		end
	})
	local kvRound = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	local round = Enfos.curRound
	local roundString = string.format("Round" .. math.min(round+1,42))
	local roundString2 = string.format("Round" .. math.min(round+2,42))
	local roundData = kvRound[roundString]
	local roundData2 = kvRound[roundString2]
	local unitInfo = LoadKeyValues("scripts/npc/units/" .. roundData.UnitFodder_1a.NPCName .. ".txt")
	local unitSecondInfo = nil
	local failsafe = true
	if roundData.UnitFodder_2a ~= nil then
		unitSecondInfo = LoadKeyValues("scripts/npc/units/" .. roundData.UnitFodder_2a.NPCName .. ".txt")
		failsafe = false
	end
	local unitInfo2 = LoadKeyValues("scripts/npc/units/" .. roundData2.UnitFodder_1a.NPCName .. ".txt")
	local unitSecondInfo2 = nil
	local failsafe2 = true
	if roundData2.UnitFodder_2a ~= nil then
		unitSecondInfo2 = LoadKeyValues("scripts/npc/units/" .. roundData2.UnitFodder_2a.NPCName .. ".txt")
		failsafe2 = false
	end
	--print(roundData.UnitFodder_1a.ArmorType)
	--[[for k,v in pairs(unitInfo) do
		print(k,v)
	end]]
	
	local daGold = math.min(round+2,42)
	if daGold == 42 then daGold = 0 end
	CustomNetTables:SetTableValue("next_wave_table","gold",{value = daGold*25})
	CustomNetTables:SetTableValue("next_wave_table","name",{value = "#"..roundData2.UnitFodder_1a.NPCName})
	CustomNetTables:SetTableValue("next_wave_table","hp",{value = unitInfo2.StatusHealth})
	CustomNetTables:SetTableValue("next_wave_table","hpRegen",{value = unitInfo2.StatusHealthRegen})
	CustomNetTables:SetTableValue("next_wave_table","mp",{value = unitInfo2.StatusMana})
	CustomNetTables:SetTableValue("next_wave_table","mpRegen",{value = unitInfo2.StatusManaRegen})
	CustomNetTables:SetTableValue("next_wave_table","atkMin",{value = unitInfo2.AttackDamageMin})
	CustomNetTables:SetTableValue("next_wave_table","atkMax",{value = unitInfo2.AttackDamageMax})
	CustomNetTables:SetTableValue("next_wave_table","atkType",{value = string.gsub(roundData2.UnitFodder_1a.AttackType,"modifier_attack_","")})
	CustomNetTables:SetTableValue("next_wave_table","atkRate",{value = unitInfo2.AttackRate})
	CustomNetTables:SetTableValue("next_wave_table","atkRange",{value = unitInfo2.AttackRange})
	if unitInfo2.AttackCapabilities == "DOTA_UNIT_CAP_RANGED_ATTACK" then CustomNetTables:SetTableValue("next_wave_table","atkMelee",{value = "Ranged"})
	elseif unitInfo2.AttackCapabilities == "DOTA_UNIT_CAP_MELEE_ATTACK" then CustomNetTables:SetTableValue("next_wave_table","atkMelee",{value = "Melee"})
	else CustomNetTables:SetTableValue("next_wave_table","atkMelee",{value = "None"}) end
	CustomNetTables:SetTableValue("next_wave_table","armor",{value = unitInfo2.ArmorPhysical})
	CustomNetTables:SetTableValue("next_wave_table","armorType",{value = string.gsub(roundData2.UnitFodder_1a.ArmorType,"modifier_armor_","")})
	if roundData2.UnitFodder_1a.ArmorType == "modifier_armor_hero" then CustomNetTables:SetTableValue("next_wave_table","armorMagic",{value = 25})
	elseif roundData2.UnitFodder_1a.ArmorType == "modifier_armor_heavy" then CustomNetTables:SetTableValue("next_wave_table","armorMagic",{value = -25})
	else CustomNetTables:SetTableValue("next_wave_table","armorMagic",{value = 0}) end
	CustomNetTables:SetTableValue("next_wave_table","speed",{value = unitInfo2.MovementSpeed})
	CustomNetTables:SetTableValue("next_wave_table","abil1",{value = unitInfo2.Ability1})
	CustomNetTables:SetTableValue("next_wave_table","abil2",{value = unitInfo2.Ability2})
	CustomNetTables:SetTableValue("next_wave_table","abil3",{value = unitInfo2.Ability3})
	CustomNetTables:SetTableValue("next_wave_table","abil4",{value = unitInfo2.Ability4})
	CustomNetTables:SetTableValue("next_wave_table","abil5",{value = unitInfo2.Ability5})
	
	if failsafe2 == false then
		CustomNetTables:SetTableValue("next_wave_table","name2",{value = "#"..roundData2.UnitFodder_2a.NPCName})
		CustomNetTables:SetTableValue("next_wave_table","hp2",{value = unitSecondInfo2.StatusHealth})
		CustomNetTables:SetTableValue("next_wave_table","hpRegen2",{value = unitSecondInfo2.StatusHealthRegen})
		CustomNetTables:SetTableValue("next_wave_table","mp2",{value = unitSecondInfo2.StatusMana})
		CustomNetTables:SetTableValue("next_wave_table","mpRegen2",{value = unitSecondInfo2.StatusManaRegen})
		CustomNetTables:SetTableValue("next_wave_table","atkMin2",{value = unitSecondInfo2.AttackDamageMin})
		CustomNetTables:SetTableValue("next_wave_table","atkMax2",{value = unitSecondInfo2.AttackDamageMax})
		CustomNetTables:SetTableValue("next_wave_table","atkType2",{value = string.gsub(roundData2.UnitFodder_2a.AttackType,"modifier_attack_","")})
		CustomNetTables:SetTableValue("next_wave_table","atkRate2",{value = unitSecondInfo2.AttackRate})
		CustomNetTables:SetTableValue("next_wave_table","atkRange2",{value = unitSecondInfo2.AttackRange})
		if unitSecondInfo2.AttackCapabilities == "DOTA_UNIT_CAP_RANGED_ATTACK" then CustomNetTables:SetTableValue("next_wave_table","atkMelee2",{value = "Ranged"})
		elseif unitSecondInfo2.AttackCapabilities == "DOTA_UNIT_CAP_MELEE_ATTACK" then CustomNetTables:SetTableValue("next_wave_table","atkMelee2",{value = "Melee"})
		else CustomNetTables:SetTableValue("next_wave_table","atkMelee2",{value = "None"}) end
		CustomNetTables:SetTableValue("next_wave_table","armor2",{value = unitSecondInfo2.ArmorPhysical})
		CustomNetTables:SetTableValue("next_wave_table","armorType2",{value = string.gsub(roundData2.UnitFodder_2a.ArmorType,"modifier_armor_","")})
		if roundData2.UnitFodder_2a.ArmorType == "modifier_armor_hero" then CustomNetTables:SetTableValue("next_wave_table","armorMagic2",{value = 25})
		elseif roundData2.UnitFodder_2a.ArmorType == "modifier_armor_heavy" then CustomNetTables:SetTableValue("next_wave_table","armorMagic2",{value = -25})
		else CustomNetTables:SetTableValue("next_wave_table","armorMagic2",{value = 0}) end
		CustomNetTables:SetTableValue("next_wave_table","speed2",{value = unitSecondInfo2.MovementSpeed})
		CustomNetTables:SetTableValue("next_wave_table","abil12",{value = unitSecondInfo2.Ability1})
		CustomNetTables:SetTableValue("next_wave_table","abil22",{value = unitSecondInfo2.Ability2})
		CustomNetTables:SetTableValue("next_wave_table","abil32",{value = unitSecondInfo2.Ability3})
		CustomNetTables:SetTableValue("next_wave_table","abil42",{value = unitSecondInfo2.Ability4})
		CustomNetTables:SetTableValue("next_wave_table","abil52",{value = unitSecondInfo2.Ability5})
	end
	CustomNetTables:SetTableValue("next_wave_table","hide",{value = false})
	CustomNetTables:SetTableValue("next_wave_table","hideSecond",{value = failsafe2})
	
	CustomNetTables:SetTableValue("this_wave_table","round",{value = math.min(round+1,42)})
	CustomNetTables:SetTableValue("this_wave_table","name",{value = "#"..roundData.UnitFodder_1a.NPCName})
	CustomNetTables:SetTableValue("this_wave_table","hp",{value = unitInfo.StatusHealth})
	CustomNetTables:SetTableValue("this_wave_table","hpRegen",{value = unitInfo.StatusHealthRegen})
	CustomNetTables:SetTableValue("this_wave_table","mp",{value = unitInfo.StatusMana})
	CustomNetTables:SetTableValue("this_wave_table","mpRegen",{value = unitInfo.StatusManaRegen})
	CustomNetTables:SetTableValue("this_wave_table","atkMin",{value = unitInfo.AttackDamageMin})
	CustomNetTables:SetTableValue("this_wave_table","atkMax",{value = unitInfo.AttackDamageMax})
	CustomNetTables:SetTableValue("this_wave_table","atkType",{value = string.gsub(roundData.UnitFodder_1a.AttackType,"modifier_attack_","")})
	CustomNetTables:SetTableValue("this_wave_table","atkRate",{value = unitInfo.AttackRate})
	CustomNetTables:SetTableValue("this_wave_table","atkRange",{value = unitInfo.AttackRange})
	if unitInfo.AttackCapabilities == "DOTA_UNIT_CAP_RANGED_ATTACK" then CustomNetTables:SetTableValue("this_wave_table","atkMelee",{value = "Ranged"})
	elseif unitInfo.AttackCapabilities == "DOTA_UNIT_CAP_MELEE_ATTACK" then CustomNetTables:SetTableValue("this_wave_table","atkMelee",{value = "Melee"})
	else CustomNetTables:SetTableValue("this_wave_table","atkMelee",{value = "None"}) end
	CustomNetTables:SetTableValue("this_wave_table","armor",{value = unitInfo.ArmorPhysical})
	CustomNetTables:SetTableValue("this_wave_table","armorType",{value = string.gsub(roundData.UnitFodder_1a.ArmorType,"modifier_armor_","")})
	if roundData.UnitFodder_1a.ArmorType == "modifier_armor_hero" then CustomNetTables:SetTableValue("this_wave_table","armorMagic",{value = 25})
	elseif roundData.UnitFodder_1a.ArmorType == "modifier_armor_heavy" then CustomNetTables:SetTableValue("this_wave_table","armorMagic",{value = -25})
	else CustomNetTables:SetTableValue("this_wave_table","armorMagic",{value = 0}) end
	CustomNetTables:SetTableValue("this_wave_table","speed",{value = unitInfo.MovementSpeed})
	CustomNetTables:SetTableValue("this_wave_table","abil1",{value = unitInfo.Ability1})
	CustomNetTables:SetTableValue("this_wave_table","abil2",{value = unitInfo.Ability2})
	CustomNetTables:SetTableValue("this_wave_table","abil3",{value = unitInfo.Ability3})
	CustomNetTables:SetTableValue("this_wave_table","abil4",{value = unitInfo.Ability4})
	CustomNetTables:SetTableValue("this_wave_table","abil5",{value = unitInfo.Ability5})
	
	if failsafe == false then
		CustomNetTables:SetTableValue("this_wave_table","name2",{value = "#"..roundData.UnitFodder_2a.NPCName})
		CustomNetTables:SetTableValue("this_wave_table","hp2",{value = unitSecondInfo.StatusHealth})
		CustomNetTables:SetTableValue("this_wave_table","hpRegen2",{value = unitSecondInfo.StatusHealthRegen})
		CustomNetTables:SetTableValue("this_wave_table","mp2",{value = unitSecondInfo.StatusMana})
		CustomNetTables:SetTableValue("this_wave_table","mpRegen2",{value = unitSecondInfo.StatusManaRegen})
		CustomNetTables:SetTableValue("this_wave_table","atkMin2",{value = unitSecondInfo.AttackDamageMin})
		CustomNetTables:SetTableValue("this_wave_table","atkMax2",{value = unitSecondInfo.AttackDamageMax})
		CustomNetTables:SetTableValue("this_wave_table","atkType2",{value = string.gsub(roundData.UnitFodder_2a.AttackType,"modifier_attack_","")})
		CustomNetTables:SetTableValue("this_wave_table","atkRate2",{value = unitSecondInfo.AttackRate})
		CustomNetTables:SetTableValue("this_wave_table","atkRange2",{value = unitSecondInfo.AttackRange})
		if unitSecondInfo.AttackCapabilities == "DOTA_UNIT_CAP_RANGED_ATTACK" then CustomNetTables:SetTableValue("this_wave_table","atkMelee2",{value = "Ranged"})
		elseif unitSecondInfo.AttackCapabilities == "DOTA_UNIT_CAP_MELEE_ATTACK" then  CustomNetTables:SetTableValue("this_wave_table","atkMelee2",{value = "Melee"})
		else CustomNetTables:SetTableValue("this_wave_table","atkMelee2",{value = "None"}) end
		CustomNetTables:SetTableValue("this_wave_table","armor2",{value = unitSecondInfo.ArmorPhysical})
		CustomNetTables:SetTableValue("this_wave_table","armorType2",{value = string.gsub(roundData.UnitFodder_2a.ArmorType,"modifier_armor_","")})
		if roundData.UnitFodder_2a.ArmorType == "modifier_armor_hero" then CustomNetTables:SetTableValue("this_wave_table","armorMagic2",{value = 25})
		elseif roundData.UnitFodder_2a.ArmorType == "modifier_armor_heavy" then CustomNetTables:SetTableValue("this_wave_table","armorMagic2",{value = -25})
		else CustomNetTables:SetTableValue("this_wave_table","armorMagic2",{value = 0}) end
		CustomNetTables:SetTableValue("this_wave_table","speed2",{value = unitSecondInfo.MovementSpeed})
		CustomNetTables:SetTableValue("this_wave_table","abil12",{value = unitSecondInfo.Ability1})
		CustomNetTables:SetTableValue("this_wave_table","abil22",{value = unitSecondInfo.Ability2})
		CustomNetTables:SetTableValue("this_wave_table","abil32",{value = unitSecondInfo.Ability3})
		CustomNetTables:SetTableValue("this_wave_table","abil42",{value = unitSecondInfo.Ability4})
		CustomNetTables:SetTableValue("this_wave_table","abil52",{value = unitSecondInfo.Ability5})
	end
	CustomNetTables:SetTableValue("this_wave_table","hide",{value = false})
	CustomNetTables:SetTableValue("this_wave_table","hideSecond",{value = failsafe})
end

-- function to fire when the round ends.
function CEnfosGameRound:End()
	for _, eID in pairs( self._vEventHandles ) do
		StopListeningToGameEvent( eID )
	end
	self._vEventHandles = {}

	for _,spawner in pairs( self._vSpawners ) do
		spawner:End()
	end

	if self._entQuest then
		UTIL_RemoveImmediate( self._entQuest )
		self._entQuest = nil
		self._entKillCountSubquest = nil
	end

	local roundEndSummary = {
		nRoundNumber = self._nRoundNumber - 1,
		nRoundDifficulty = GameRules:GetCustomGameDifficulty(),
		roundName = self._szRoundTitle,
		nTowers = nTowers,
		nTowersStanding = nTowersStanding,
		nTowersStandingGoldReward = nTowersStandingGoldReward,
	}
	CustomNetTables:SetTableValue("this_wave_table","hide",{value = true})
end


function CEnfosGameRound:Think()
	for _, spawner in pairs( self._vSpawners ) do
		spawner:Think()
	end
end

-- ?
function CEnfosGameRound:ChooseRadiantSpawnInfo()
	return self._gameMode:ChooseRadiantSpawnInfo()
end

function CEnfosGameRound:ChooseDireSpawnInfo()
	return self._gameMode:ChooseDireSpawnInfo()
end

-- this function checks for the time remaining. if it's 0 or less, the round is over.
function CEnfosGameRound:IsFinished()
	for _, spawner in pairs( self._vSpawners ) do
		if not spawner:IsFinishedSpawning() then
			return false
		end
	end
	if ROUND_TIME <= 0 then
		return true
	end

	--print ( string.format( "%d seconds remaining in the round...", ROUND_TIME ) )
	return false
end




function CEnfosGameRound:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:IsPhantom() or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:GetUnitName() == "" then
		return
	end

	if spawnedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS or spawnedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		spawnedUnit:SetMustReachEachGoalEntity(true)
	end
end

function CEnfosGameRound:StatusReport( )
	print( string.format( "Enemies remaining: %d", #self._vEnemiesRemaining ) )
	for _,e in pairs( self._vEnemiesRemaining ) do
		if e:IsNull() then
			print( string.format( "<Unit %s Deleted from C++>", e.unitName ) )
		else
			print( e:GetUnitName() )
		end
	end
	print( string.format( "Spawners: %d", #self._vSpawners ) )
	for _,s in pairs( self._vSpawners ) do
		s:StatusReport()
	end
end