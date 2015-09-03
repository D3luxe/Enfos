--[[
Satyr Reaver Spawn Logic
]]

-- what is all this stuff?

function Spawn( entityKeyValues )
	ABILITY_curse = thisEntity:FindAbilityByName( "mob_curse" )
	thisEntity:SetContextThink( "SatyrReaverThink", SatyrReaverThink, 0.25 )

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

function SatyrReaverThink()
	if not thisEntity:IsAlive() then
		return nil
	end
	
	if thisEntity:GetAttackTarget() == nil then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 1, false)
		if units ~= nil then
			if #units > 0 then
				for i=1,#units do
					if not units[i]:IsAttackImmune() then
						thisEntity:SetForceAttackTarget(units[i])
						break
					end
				end
			end
		end
	end
	
	-- Spawn a broodmother whenever we're able to do so.
	if ABILITY_curse:IsFullyCastable() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 1, false)
		if units ~= nil then
			if #units > 0 then
				local unitPicked = math.random(1,#units)
				if not units[unitPicked]:HasModifier("modifier_mob_curse") then
					thisEntity:CastAbilityOnTarget(units[unitPicked], ABILITY_curse, -1)
				end
			end
		end
		return 1.0
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end

function curse(keys)
	local caster = keys.caster
	local target = keys.target
	local sDuration = keys.ability:GetSpecialValueFor("duration")
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else
		keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_mob_curse", {duration = sDuration})
	end	
end

function remove_invisiblity( event )
 event.caster:RemoveModifierByName("modifier_invisible")
end

function apply_invisibility( event )
  event.caster:AddNewModifier(event.caster, event.ability, "modifier_invisible", {duration = -1}) 
end