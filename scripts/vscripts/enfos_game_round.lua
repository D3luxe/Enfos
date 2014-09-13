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