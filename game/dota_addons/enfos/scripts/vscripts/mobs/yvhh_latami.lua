--[[
Yvhh La`Tami Spawn Logic
]]

function Spawn( entityKeyValues )
	ABILITY_frost_bolt = thisEntity:FindAbilityByName( "mob_frost_bolt" )
	thisEntity:SetContextThink( "YvhhLatamiThink", YvhhLatamiThink, 0.25 )
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

function YvhhLatamiThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	-- Spawn a broodmother whenever we're able to do so.
	if ABILITY_frost_bolt:IsFullyCastable() then
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 1, false)
		if units ~= nil then
			if #units > 0 then
				local unitPicked = math.random(1,#units)
				if units[unitPicked]:HasModifier("modifier_mob_frost_bolt_target") and not units[unitPicked]:HasModifier("modifier_mob_frost_bolt") and thisEntity:FindAbilityByName("mob_frost_bolt"):IsCooldownReady() then
					thisEntity:CastAbilityOnTarget(units[unitPicked], ABILITY_frost_bolt, -1)
					Timers:CreateTimer(DoUniqueString("delay"), {
						endTime = 1,
						callback = function()
							ABILITY_frost_bolt:StartCooldown(ABILITY_frost_bolt:GetCooldown(1) - 1) 
						end
					})
				end
			end
		end
		return 1.0
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end

function frost_bolt(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = keys.ability:GetSpecialValueFor("damage")
	local sDuration = keys.ability:GetSpecialValueFor("duration")
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else
		keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_mob_frost_bolt", {duration = sDuration})
		DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL)
	end	
end