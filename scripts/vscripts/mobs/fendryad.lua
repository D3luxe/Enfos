--[[
Fendryad Spawn Logic
]]

function Spawn( entityKeyValues )
	ABILITY_curse = thisEntity:FindAbilityByName( "mob_curse" )
	ABILITY_mana_burn = thisEntity:FindAbilityByName( "mob_mana_burn" )
	thisEntity:SetContextThink( "FendryadThink", FendryadThink, 0.25 )

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

function FendryadThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	-- Cast Curse
	if ABILITY_curse:IsFullyCastable() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 1, false)
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

	-- Cast Mana Burn
	if ABILITY_mana_burn:IsFullyCastable() then
		local chance = math.random(1,100)
		if chance >= 50 then
			local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 1, false)
			if units ~= nil then
				if #units > 0 then
					local unitPicked = math.random(1,#units)
					thisEntity:CastAbilityOnTarget(units[unitPicked], ABILITY_mana_burn, -1)
				end
			end
		end
		return 1.0
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end