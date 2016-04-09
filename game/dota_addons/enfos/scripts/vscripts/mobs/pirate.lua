--[[
Pirate Spawn Logic
]]

function Spawn( entityKeyValues )
	ABILITY_frenzy = thisEntity:FindAbilityByName( "mob_frenzy" )
	thisEntity:SetContextThink( "PirateThink", PirateThink, 0.25 )
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

function PirateThink()
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
	
	if ABILITY_frenzy:IsFullyCastable() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
		if units ~= nil then
			if #units > 0 then
				local unitPicked = math.random(1,#units)
				if not units[unitPicked]:HasModifier("modifier_mob_frenzy") and not thisEntity:HasModifier("modifier_invisible") and thisEntity:FindAbilityByName("mob_frenzy"):IsCooldownReady() then
					thisEntity:CastAbilityOnTarget(units[unitPicked], ABILITY_frenzy, -1)
					Timers:CreateTimer(DoUniqueString("delay"), {
						endTime = 1, -- hardcoding these values because I'm really tired
						callback = function()
							ABILITY_frenzy:StartCooldown(ABILITY_frenzy:GetCooldown(1) - 1) 
						end
					})
				end
			end
		end
		return 1.0
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end

function Pulverize(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damageNear = ability:GetSpecialValueFor("damage_near")
	local damageFar = ability:GetSpecialValueFor("damage_far")
	local rangeNear = ability:GetSpecialValueFor("range_near")
	local rangeFar = ability:GetSpecialValueFor("range_far")
	local unitsNear = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), caster, rangeNear, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
	local unitsFar = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), caster, rangeFar, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
	for k,v in pairs(unitsNear) do
		DealDamage(caster, v, damageNear, DAMAGE_TYPE_MAGICAL, 0)
	end	
	for k,v in pairs(unitsFar) do
		DealDamage(caster, v, damageFar, DAMAGE_TYPE_MAGICAL, 0)
	end
end