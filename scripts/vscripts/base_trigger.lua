---------------------------------------------------------------------------------------------------------------------------------------
---	TRIGGERS	
---------------------------------------------------------------------------------------------------------------------------------------
_goodLives = 100
_badLives = 100


function RadiantLoseLife(trigger)
	if trigger.activator:IsCreature() then 
		_goodLives = _goodLives - 1
		trigger.activator:ForceKill(true)
		GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, _goodLives)
		if _goodLives == 0 then
			GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
			return
		end
	end
end

function DireLoseLife(trigger)
	if trigger.activator:IsCreature() then 
		_badLives = _badLives - 1
		trigger.activator:ForceKill(true)
		GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, _badLives)
		if _badLives == 0 then
			GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
			return
		end
	end
end