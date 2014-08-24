-- Initialization
if Triggers == nil then
  Triggers = class({})
  Triggers.__index = Triggers
end

function Triggers:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---------------------------------------------------------------------------------------------------------------------------------------
---	TRIGGERS	
---------------------------------------------------------------------------------------------------------------------------------------
Triggers._goodLives = 100
Triggers._badLives = 100


function RadiantLoseLife(trigger)
	if trigger.activator:IsCreature() then 
		if trigger.activator:GetUnitName() == "npc_dota_spirit_hawk" or trigger.activator:GetUnitName() == "npc_dota_spirit_owl" then
			trigger.activator:ForceKill(true)
		else
			Triggers._goodLives = Triggers._goodLives - 1
			trigger.activator:ForceKill(true)
			GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, Triggers._goodLives)
			if Triggers._goodLives == 0 then
				GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
				return
			end
		end
	end
end

function DireLoseLife(trigger)
	if trigger.activator:IsCreature() then 
		Triggers._badLives = Triggers._badLives - 1
		trigger.activator:ForceKill(true)
		GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, Triggers._badLives)
		if Triggers._badLives == 0 then
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
	local point = Entities:FindByName( nil, "dire_right_teleport_target_2" ):GetAbsOrigin()
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