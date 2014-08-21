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

function RadiantLeftTeleport1(trigger)
	local point = Entities:FindByName( nil, "radiant_left_teleport_target_2" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	SendToConsole("dota_camera_center")
end
function RadiantLeftTeleport2(trigger)
	local point = Entities:FindByName( nil, "radiant_left_teleport_target_1" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	SendToConsole("dota_camera_center")
end
function RadiantRightTeleport1(trigger)
	local point = Entities:FindByName( nil, "radiant_right_teleport_target_2" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	SendToConsole("dota_camera_center")
end
function RadiantRightTeleport2(trigger)
	local point = Entities:FindByName( nil, "radiant_right_teleport_target_1" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	SendToConsole("dota_camera_center")
end
function DireLeftTeleport1(trigger)
	local point = Entities:FindByName( nil, "dire_left_teleport_target_2" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	SendToConsole("dota_camera_center")
end
function DireLeftTeleport2(trigger)
	local point = Entities:FindByName( nil, "dire_left_teleport_target_1" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	SendToConsole("dota_camera_center")
end
function DireRightTeleport1(trigger)
	local point = Entities:FindByName( nil, "dire_left_teleport_target_2" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	SendToConsole("dota_camera_center")
end
function DireRightTeleport2(trigger)
	local point = Entities:FindByName( nil, "dire_right_teleport_target_1" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	SendToConsole("dota_camera_center")
end