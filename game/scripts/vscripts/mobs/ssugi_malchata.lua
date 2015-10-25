--[[
Ssugi Malchata Spawn Logic
]]

function Spawn( entityKeyValues )
	ABILITY_slow = thisEntity:FindAbilityByName( "mob_slow" )
	thisEntity:SetContextThink( "SsugiMalchataThink", SsugiMalchataThink, 0.25 )

	--Find the closest waypoint, use it as a goal entity if we can
	local waypoint = Entities:FindByNameNearest( "*_wp_*", thisEntity:GetOrigin(), 0 )
	if waypoint then
		thisEntity:SetInitialGoalEntity( waypoint )
		thisEntity:MoveToPositionAggressive( waypoint:GetOrigin() )
	else
		local ancient =  Entities:FindByName( nil, "*_wp_12" )
		thisEntity:SetInitialGoalEntity( ancient )
		thisEntity:MoveToPositionAggressive( ancient:GetOrigin() )
	end
end

function SsugiMalchataThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	-- Spawn a broodmother whenever we're able to do so.
	if ABILITY_slow:IsFullyCastable() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 1, false)
		if units ~= nil then
			if #units > 0 then
				local unitPicked = math.random(1,#units)
				if not units[unitPicked]:HasModifier("modifier_mob_slow") then
					thisEntity:CastAbilityOnTarget(units[unitPicked], ABILITY_slow, -1)
				end
			end
		end
		return 1.0
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end