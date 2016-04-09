--[[
Fendryad Spawn Logic
]]

function Spawn( entityKeyValues )
	ABILITY_curse = thisEntity:FindAbilityByName( "mob_curse" )
	ABILITY_mana_burn = thisEntity:FindAbilityByName( "mob_mana_burn" )
	--thisEntity:SetContextThink( "FendryadThink", FendryadThink, 0.25 )

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
		print("Fendryad curse")
		local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 1, false)
		if units ~= nil then
			if #units > 0 then
				local unitPicked = math.random(1,#units)
				if not units[unitPicked]:HasModifier("modifier_mob_curse") and thisEntity:FindAbilityByName("mob_curse"):IsCooldownReady() then
					thisEntity:CastAbilityOnTarget(units[unitPicked], ABILITY_curse, -1)
					Timers:CreateTimer(DoUniqueString("delay"), {
						endTime = 1, -- hardcoding these values because I'm really tired
						callback = function()
								print("Casting curse")
								thisEntity:FindAbilityByName("mob_curse"):StartCooldown(7) 
						end
					})
				end
			end
		end
		return 1.0
	end

	-- Cast Mana Burn
	if ABILITY_mana_burn:IsFullyCastable() then
		print("Fendryad mana burn")
		local chance = math.random(1,100)
		if chance >= 50 then
			print("Chance passed, casting mana burn")
			local units = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), thisEntity, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 1, false)
			if units ~= nil then
				if #units > 0 then
					local unitPicked = math.random(1,#units)
					if thisEntity:FindAbilityByName("mob_mana_burn"):IsCooldownReady() then
						thisEntity:CastAbilityOnTarget(units[unitPicked], ABILITY_mana_burn, -1)
						Timers:CreateTimer(DoUniqueString("delay"), {
							endTime = 1, -- hardcoding these values because I'm really tired
							callback = function()
									print("Casting mana burn")
									thisEntity:FindAbilityByName("mob_mana_burn"):StartCooldown(8) 
							end
						})
					end
				end
			end
		end
		return 1.0
	end
	return 0.25 + RandomFloat( 0.25, 0.5 )
end

--[[
	Based on spell library mana_burn by kritth	
]]

function mana_burn_function( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local mana_to_burn = keys.ability:GetLevelSpecialValueFor( "burn_amount", keys.ability:GetLevel() - 1 )
	local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
	local damageType = keys.ability:GetAbilityDamageType()
	local life_time = 2.0
	
	
	if sphereCheck then
		return
	else
		-- Apply effect of ability
		target:ReduceMana( mana_to_burn )
		
		-- Show VFX
		local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, target )
		ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
	    ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
		local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
		
		-- Create timer to properly destroy particles
		Timers:CreateTimer( life_time, function()
				ParticleManager:DestroyParticle( numberIndex, false )
				ParticleManager:DestroyParticle( burnIndex, false)
				return nil
			end
		)
	end
end