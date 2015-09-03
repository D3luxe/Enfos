--[[
Poloh Spawn Logic
]]

-- what is all this stuff?

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "PolohThink", PolohThink, 0.25 )

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

function PolohThink()
	if not thisEntity:IsAlive() then
		return nil
	end
	

	if thisEntity:GetAttackTarget() == nil then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 1, false)
		if units ~= nil then
			if #units > 0 then
				for i=1,#units do
					if not units[i]:IsAttackImmune()
						thisEntity:SetForceAttackTarget(units[i])
						break
					end
				end
			end
		else
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
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end


function remove_invisiblity( event )
 event.caster:RemoveModifierByName("modifier_invisible")
end

function apply_invisibility( event )
  event.caster:AddNewModifier(event.caster, event.ability, "modifier_invisible", {duration = -1}) 
end