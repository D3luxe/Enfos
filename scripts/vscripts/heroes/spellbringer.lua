function jomays_legacy(keys)
	local caster = keys.caster
	local target = keys.target_points[1]

	local unit = CreateUnitByName("npc_spellbringer_jomays_legacy_dummy", target, true, caster, caster, caster:GetTeamNumber())
	unit:SetAbsOrigin(target) -- CreateUnitByName uses only the x and y coordinates so we have to move it with SetAbsOrigin()
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:SetDayTimeVisionRange(1200)
	unit:SetNightTimeVisionRange(1200)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:AddNewModifier(dummy, nil, "modifier_invulnerable", { duration = 9999})
end

function jomays_legacy_tick(keys)
	local caster = keys.caster
	local target = keys.target

	local targetHealth = target:GetHealth()
	local damage = targetHealth * 0.03
	DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
end

function mana_disruption(keys)
	local caster = keys.caster
	local target = keys.target
	local duration = keys.duration
	local manaPerSecond = keys.mana_per_second

	Timers:CreateTimer(DoUniqueString("manaDisruption"), {
		endTime = 1,
		callback = function()
			target:SetMana(target:GetMana() - manaPerSecond)
			duration = duration - 1
			
			ParticleManager:CreateParticle("particles/items2_fx/necronomicon_archer_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			if duration > 0 then
				return 1.0
			end
		end
	})
end

function spell_disruption(keys)
	local caster = keys.caster
	local target = keys.target
	local manaBurn = keys.mana_burn

	local damage = 0
	local targetMana = target:GetMana()

	if targetMana < 500 then
		damage = targetMana
	else
		damage = 500
	end
	target:SetMana(targetMana - manaBurn)
	ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

	DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
end

function summon_sidhlot(keys)
	local caster = keys.caster
	local target = keys.target_points[1]

	local unit = CreateUnitByName("npc_summon_sidhlot", target, true, caster, caster, caster:GetTeamNumber())
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

	ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
end

function summon_uthmor(keys)
	local caster = keys.caster
	local target = keys.target_points[1]

	local unit = CreateUnitByName("npc_summon_uthmor", target, true, caster, caster, caster:GetTeamNumber())
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

	ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
end

function summon_arhat(keys)
	local caster = keys.caster
	local target = keys.target_points[1]

	local unit = CreateUnitByName("npc_summon_arhat", target, true, caster, caster, caster:GetTeamNumber())
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

	ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
end

function summon_havroth(keys)
	local caster = keys.caster
	local target = keys.target_points[1]

	local unit = CreateUnitByName("npc_summon_havroth", target, true, caster, caster, caster:GetTeamNumber())
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

	ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
end

function sidhlot_resurrect(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerOwnerID()
	local radius = keys.radius
	local spellDuration = keys.duration
	local unitsRaised = 1
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_DEAD, 1, false)
	local validTargets = {}
	if units[1] == nil then
		return
	end
	for k,v in pairs(units) do
		if not v:IsAlive() then
			table.insert(validTargets, v)
		end
	end
-- find all the nearby dead units and reraise them
	for i=1,unitsRaised	do
		if validTargets[i] == nil then
			return
		end
		local raisedUnit = CreateUnitByName(validTargets[i]:GetUnitName(), validTargets[i]:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
		local waypoint = Entities:FindByNameNearest("*_wp_*", raisedUnit:GetAbsOrigin(), 0)

		raisedUnit:SetInitialGoalEntity(waypoint)
		ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_ABSORIGIN_FOLLOW, raisedUnit)
		validTargets[i]:Destroy()
	end
	caster:EmitSound("Hero_ObsidianDestroyer.ArcaneOrb.Impact")
end

function havroth_reflect(keys)
-- vars
	local damage = keys.DamageDealt
	local attacker = keys.attacker
	local caster = keys.caster
	local percentReflected = keys.damage_reflected / 100

	local armor = caster:GetPhysicalArmorValue()
	local damageMultiplication = ((0.06 * armor) / (1 + 0.06 * armor)) + 1


	local reflectedDamage = damage * percentReflected * damageMultiplication

	DealDamage(caster, attacker, reflectedDamage, DAMAGE_TYPE_PURE, 0)
end


function purification(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local radius = keys.radius

	Timers:CreateTimer(DoUniqueString("purificationDelay"), {
		endTime = 2,
		callback = function()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), target, caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
			for k,v in pairs(units) do
				local numMod = v:GetModifierCount()
				if numMod > 0 then

					for i = 0, numMod do
						local modName = v:GetModifierNameByIndex(i)
			
						local modValue = v:GetModifierNameByIndex(i)
				
						if modName ~= "modifier_dummy_modifier" then
							v:RemoveModifierByName(modName)
						end
					end
				end
			end
		end
	})

end

function locate(keys)
	local caster = keys.caster
	local target = keys.target_points[1]

	local unit = CreateUnitByName("npc_spellbringer_locate_dummy", target, true, caster, caster, caster:GetTeamNumber())
	unit:SetAbsOrigin(target) -- CreateUnitByName uses only the x and y coordinates so we have to move it with SetAbsOrigin()
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:SetDayTimeVisionRange(1200)
	unit:SetNightTimeVisionRange(1200)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:AddNewModifier(dummy, nil, "modifier_invulnerable", { duration = 9999})
	unit:AddNewModifier(caster, nil, "modifier_tower_truesight_aura", {})

	ParticleManager:CreateParticle("particles/items_fx/dust_of_appearance.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:CreateParticle("particles/econ/wards/f2p/f2p_ward/ward_true_sight.vpcf", PATTACH_OVERHEAD_FOLLOW, unit)
end

function whole_displacement(keys)
	local entSpawner = nil
	local waypoint = nil
	local caster = keys.caster
	local target = keys.target

	if PlayerResource:GetTeam( keys.caster_entindex ) == DOTA_TEAM_GOODGUYS then
		entSpawner = Entities:FindByName( nil, "dire_spawner1" )
		waypoint = Entities:FindByName(nil, "d_wp_5")
	else
		entSpawner = Entities:FindByName( nil, "radiant_spawner1" )
		waypoint = Entities:FindByName( nil, "r_wp_5" )
	end

	if not entSpawner then
		return
	end
	if not waypoint then
		return
	end
	local spawnLocation = entSpawner:GetAbsOrigin()
	FindClearSpaceForUnit(target, spawnLocation, true)
	target:SetInitialGoalEntity(waypoint)
end

function changeAbilitySet(caster, oldAbilitySet)
	local set = caster.abilitySet
	local oldSet = oldAbilitySet

	--Remove all of the old abilities
	if oldSet == 0 then
		caster:RemoveAbility("spellbringer_battle_sphere")
		caster:RemoveAbility("spellbringer_limb_disruption")
		caster:RemoveAbility("spellbringer_whole_displacement")
		caster:RemoveAbility("spellbringer_locate")
	elseif oldSet == 1 then
		caster:RemoveAbility("spellbringer_mana_disruption")
		caster:RemoveAbility("spellbringer_spell_disruption")
		caster:RemoveAbility("spellbringer_jomays_legacy")
		caster:RemoveAbility("spellbringer_glythtides_gift")
	elseif oldSet == 2 then
		caster:RemoveAbility("spellbringer_summon_arhat")
		caster:RemoveAbility("spellbringer_summon_uthmor")
		caster:RemoveAbility("spellbringer_summon_sidhlot")
		caster:RemoveAbility("spellbringer_summon_havroth")
	elseif oldSet == 3 then
		caster:RemoveAbility("phantom_assassin_enfos_courage")
		caster:RemoveAbility("generic_enfos_combat_mastery")
		caster:RemoveAbility("phantom_assassin_enfos_chadatrus_blessing")
		caster:RemoveAbility("phantom_assassin_enfos_righteous_wrath")
	elseif oldSet == 4 then
		caster:RemoveAbility("spellbringer_battle_sphere")
		caster:RemoveAbility("spellbringer_limb_disruption")
		caster:RemoveAbility("spellbringer_whole_displacement")
		caster:RemoveAbility("evoker_gar_zeng")
	end

	--Add all of the new abilities
	if set == 0 then
		caster:AddAbility("spellbringer_battle_sphere")
		caster:AddAbility("spellbringer_limb_disruption")
		caster:AddAbility("spellbringer_whole_displacement")
		caster:AddAbility("spellbringer_locate")
	elseif set == 1 then
		caster:AddAbility("spellbringer_mana_disruption")
		caster:AddAbility("spellbringer_spell_disruption")
		caster:AddAbility("spellbringer_jomays_legacy")
		caster:AddAbility("spellbringer_glythtides_gift")
	elseif set == 2 then
		caster:AddAbility("spellbringer_summon_arhat")
		caster:AddAbility("spellbringer_summon_uthmor")
		caster:AddAbility("spellbringer_summon_sidhlot")
		caster:AddAbility("spellbringer_summon_havroth")
	elseif set == 3 then
		caster:AddAbility("phantom_assassin_enfos_courage")
		caster:AddAbility("generic_enfos_combat_mastery")
		caster:AddAbility("phantom_assassin_enfos_chadatrus_blessing")
		caster:AddAbility("phantom_assassin_enfos_righteous_wrath")
	elseif set == 4 then
		caster:AddAbility("spellbringer_battle_sphere")
		caster:AddAbility("spellbringer_limb_disruption")
		caster:AddAbility("spellbringer_whole_displacement")
		caster:AddAbility("evoker_gar_zeng")
	end

	for i=0,4 do
		caster:GetAbilityByIndex(i):SetLevel(1)
	end

end

function ability_set_down(keys)
	local caster = keys.caster
	if caster.abilitySet == nil then
		caster.abilitySet = 0
	end

	local oldSet = caster.abilitySet

	caster.abilitySet = caster.abilitySet - 1

	if caster.abilitySet <= 0 then
		caster.abilitySet = 0
	end

	changeAbilitySet(caster, oldSet)
end

function ability_set_up(keys)
	local caster = keys.caster
	if caster.abilitySet == nil then
		caster.abilitySet = 0
	end

	local oldSet = caster.abilitySet

	caster.abilitySet = caster.abilitySet + 1

	if caster.abilitySet >= 2 then
		caster.abilitySet = 2
	end

	changeAbilitySet(caster, oldSet)
end