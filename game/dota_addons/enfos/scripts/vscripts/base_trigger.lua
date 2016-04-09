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
function RadiantLoseLife(trigger)
	if trigger.activator:IsCreature() then 
		if trigger.activator:GetUnitName() == "npc_dota_spirit_hawk" or trigger.activator:GetUnitName() == "npc_dota_spirit_owl" then
			trigger.activator:ForceKill(true)
		elseif trigger.activator:GetTeam() == DOTA_TEAM_BADGUYS then
			if trigger.activator:GetOwner() == nil then
				trigger.activator.noxp = true
				trigger.activator:ForceKill(true)
				GameRules.Enfos:ModifyLife(DOTA_TEAM_GOODGUYS, 1, 1)
			end
		end
	end
end

function DireLoseLife(trigger)
	if trigger.activator:IsCreature() then 
		if trigger.activator:GetUnitName() == "npc_dota_spirit_hawk" or trigger.activator:GetUnitName() == "npc_dota_spirit_owl" then
			trigger.activator:ForceKill(true)
		elseif trigger.activator:GetTeam() == DOTA_TEAM_GOODGUYS then
			if trigger.activator:GetOwner() == nil then
				trigger.activator:ForceKill(true)
				GameRules.Enfos:ModifyLife(DOTA_TEAM_BADGUYS, 1, 1)
			end
		end
	end
end

function RadiantLeftTeleport1(trigger)
	local point = Entities:FindByName( nil, "radiant_left_teleport_target_2" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	--SendToConsole("dota_camera_center")
end
function RadiantLeftTeleport2(trigger)
	local point = Entities:FindByName( nil, "radiant_left_teleport_target_1" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	--SendToConsole("dota_camera_center")
end
function RadiantRightTeleport1(trigger)
	local point = Entities:FindByName( nil, "radiant_right_teleport_target_2" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	--SendToConsole("dota_camera_center")
end
function RadiantRightTeleport2(trigger)
	local point = Entities:FindByName( nil, "radiant_right_teleport_target_1" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	--SendToConsole("dota_camera_center")
end
function DireLeftTeleport1(trigger)
	local point = Entities:FindByName( nil, "dire_left_teleport_target_2" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	--SendToConsole("dota_camera_center")
end
function DireLeftTeleport2(trigger)
	local point = Entities:FindByName( nil, "dire_left_teleport_target_1" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	--SendToConsole("dota_camera_center")
end
function DireRightTeleport1(trigger)
	local point = Entities:FindByName( nil, "dire_right_teleport_target_2" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	--SendToConsole("dota_camera_center")
end
function DireRightTeleport2(trigger)
	local point = Entities:FindByName( nil, "dire_right_teleport_target_1" ):GetAbsOrigin()
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:Stop()
	--SendToConsole("dota_camera_center")
end