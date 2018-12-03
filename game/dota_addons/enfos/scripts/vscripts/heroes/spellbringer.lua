function AddTypes(mob, armor, attack)
	local spawnedUnitIndex = mob
	local armorType = armor
	local attackType = attack

	local armorItem = CreateItem("item_armor_type_modifier", nil, nil) 
	armorItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, armorType, {})
	UTIL_RemoveImmediate(armorItem)
	armorItem = nil

	local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
	attackItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, attackType, {})
	UTIL_RemoveImmediate(attackItem)
	attackItem = nil
end

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
	if target:IsHero() then
		DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
end

function mana_disruption(keys)
	local caster = keys.caster
	local target = keys.target
	local duration = keys.duration
	local manaPerSecond = keys.mana_per_second
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else
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
end

function spell_disruption(keys)
	local caster = keys.caster
	local target = keys.target
	local manaBurn = keys.mana_burn

	local damage = 0
	local targetMana = target:GetMana()

	if targetMana < 90000 then
		damage = targetMana
	else
		damage = 90000
	end
	
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else	
		target:SetMana(targetMana - manaBurn)
		ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		
		local dmgNumAmount = math.floor(damage*math.abs((target:GetBaseMagicalResistanceValue()-100)/100))
		local dmgCharacters = string.len(tostring(dmgNumAmount))
		
		local effect = ParticleManager:CreateParticle("particles/hero_spellbringer/spellbringer_spell_disrupt_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(effect,3,Vector(0,dmgNumAmount,0))
		ParticleManager:SetParticleControl(effect,4,Vector(1.2,dmgCharacters,0))
		ParticleManager:SetParticleControl(effect,1,Vector(0,0,6))
		ParticleManager:SetParticleControl(effect,2,Vector(1,1,0))
		
		target:EmitSound("Hero_Antimage.ManaVoid")
		DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
end

function summon_sidhlot(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	if math.abs(target.x) < 1500 then
		if target.x < 0 then target.x = -1500
		else target.x = 1500 end
	end

	local unit = CreateUnitByName("npc_summon_sidhlot", target, true, caster, caster, caster:GetTeamNumber())
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:SetOwner(caster:GetOwner())
	unit:SetRenderColor(82, 235, 41)

	ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
end

function summon_uthmor(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	if math.abs(target.x) < 1500 then
		if target.x < 0 then target.x = -1500
		else target.x = 1500 end
	end

	local unit = CreateUnitByName("npc_summon_uthmor", target, true, caster, caster, caster:GetTeamNumber())
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:SetRenderColor(82, 235, 41)

	ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
end

function summon_arhat(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	if math.abs(target.x) < 1500 then
		if target.x < 0 then target.x = -1500
		else target.x = 1500 end
	end

	local unit = CreateUnitByName("npc_summon_arhat", target, true, caster, caster, caster:GetTeamNumber())
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:SetRenderColor(82, 235, 41)

	ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
end

function summon_havroth(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	if math.abs(target.x) < 1500 then
		if target.x < 0 then target.x = -1500
		else target.x = 1500 end
	end

	local unit = CreateUnitByName("npc_summon_havroth", target, true, caster, caster, caster:GetTeamNumber())
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:SetRenderColor(82, 235, 41)

	ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
end

function sidhlot_resurrect(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerOwnerID()
	local radius = keys.radius
	local spellDuration = keys.duration
	local unitsRaised = 1
	local thisSpell = caster:GetAbilityByIndex(0)
	local units = Corpses:FindAlliedInRadius(pid, caster:GetAbsOrigin(), radius)
	if units[1] == nil then
		thisSpell:EndCooldown()
		local manaCost = thisSpell:GetManaCost(thisSpell:GetLevel()-1)
		caster:GiveMana(manaCost)
		CEnfosGameMode:SendErrorMessage(pid, "No usable corpses nearby")
		return
	end
	--[[for i = #units,1,-1 do
		if units[i]:GetTeamNumber() ~= caster:GetTeamNumber() then
			table.remove(units, i)
		end
	end
	if units[1] == nil then
		print("two")
		thisSpell:EndCooldown()
		local manaCost = thisSpell:GetManaCost(thisSpell:GetLevel()-1)
		caster:GiveMana(manaCost)
		CEnfosGameMode:SendErrorMessage(pid, "No usable corpses nearby")
		return
	end]]
-- find all the nearby dead units and reraise them
	for i=1,unitsRaised	do
		local raisedUnit = CreateUnitByName(units[i].unit_name, units[i]:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
		local waypoint = Entities:FindByNameNearest("*_wp_*", raisedUnit:GetAbsOrigin(), 0)

		raisedUnit:SetInitialGoalEntity(waypoint)
		ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_ABSORIGIN_FOLLOW, raisedUnit)
		units[i]:RemoveCorpse()
		raisedUnit:SetRenderColor(0, 84, 255)
		raisedUnit.noCorpse = true
		thisSpell:ApplyDataDrivenModifier(caster, raisedUnit, "modifier_sidhlot_resurrect", {})
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
	print("-----")
	print(damage)
	print(percentReflected)
	print(armor)
	print(damageMultiplication)

	local reflectedDamage = damage * percentReflected

	--DealDamage(caster, attacker, reflectedDamage, DAMAGE_TYPE_PURE, 0)
end


function purification(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local radius = keys.radius

	local soundDummy = FastDummy(target, caster:GetTeam())
	EmitSoundOnLocationForAllies(soundDummy:GetAbsOrigin(),"Hero_Invoker.EMP.Charge",soundDummy)
	DelayDestroy(soundDummy, 1.0)
	for _,hero in pairs(HeroList:GetAllHeroes()) do
		if hero:GetPlayerID() and hero:GetTeam() == caster:GetTeam() then
			local preParticle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_invoker/invoker_emp_charge.vpcf", PATTACH_ABSORIGIN, hero, PlayerResource:GetPlayer(hero:GetPlayerID()))
			ParticleManager:SetParticleControl(preParticle, 0, target)
			
			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(preParticle, true)
			end)
		end
	end
	
	Timers:CreateTimer(DoUniqueString("purificationDelay"), {
		endTime = 2,
		callback = function()
			local dummy = FastDummy(target, DOTA_TEAM_NOTEAM)
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf", PATTACH_ABSORIGIN, dummy)
			dummy:EmitSound("Hero_Invoker.EMP.Discharge")
			--ParticleManager:SetParticleControl(particle, 1, Vector(radius, 1, radius)) -- smoke cloud radius
			DelayDestroy(dummy, 1.0)
			local units = FindUnitsInRadius(caster:GetTeamNumber(), target, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
			
			for k,v in pairs(units) do
				--[[local numMod = v:GetModifierCount()
				if numMod > 0 then

					for i = 0, numMod do
						local modName = v:GetModifierNameByIndex(i)
			
						local modValue = v:GetModifierNameByIndex(i)
						
						print(v.IsPurgable)
						if modName ~= "modifier_dummy_modifier" then
							v:RemoveModifierByName(modName)
						end
					end
				end
				if v:IsIllusion() then
					v:ForceKill(true)
				end]]
				CustomPurge(v,true,true)
			end
			
		
		end
	})

end

function locate(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	if math.abs(target.x) < 1500 then
		if target.x < 0 then target.x = -1500
		else target.x = 1500 end
	end

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

	local randWP = math.random(1,2)
	if target:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		if randWP == 1 then
			entSpawner = Entities:FindByName( nil, "dire_spawner1" )
			waypoint = Entities:FindByName(nil, "d_wp_5")
		else
			entSpawner = Entities:FindByName( nil, "dire_spawner3" )
			waypoint = Entities:FindByName(nil, "d_wp_13")
		end
	else
		if randWP == 1 then
			entSpawner = Entities:FindByName( nil, "radiant_spawner1" )
			waypoint = Entities:FindByName( nil, "r_wp_5" )
		else
			entSpawner = Entities:FindByName( nil, "radiant_spawner3" )
			waypoint = Entities:FindByName( nil, "r_wp_13" )
		end
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

function battle_sphere(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = keys.ability:GetSpecialValueFor("damage")
	local sDuration = keys.ability:GetSpecialValueFor("duration")
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else
		target:AddNewModifier(caster, nil, "modifier_stunned", {duration = sDuration})
		DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL)
	end
end

function limb_disruption(keys)
	local caster = keys.caster
	local target = keys.target
	local sDuration = keys.ability:GetSpecialValueFor("duration")
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else
		keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_spellbringer_limb_disruption", {duration = sDuration})
	end
end

function glythtides_gift(keys)
	local caster = keys.caster
	local target = keys.target
	local sDuration = keys.ability:GetSpecialValueFor("duration")
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else
		keys.ability:ApplyDataDrivenModifier(caster,target,"modifier_spellbringer_glythtides_gift", {duration = sDuration})
	end	
end

function changeAbilitySet(caster, oldAbilitySet)
	local set = caster.abilitySet
	local oldSet = oldAbilitySet

	--Remove all of the old abilities
	if oldSet == 0 then
		caster:RemoveAbility("spellbringer_battle_sphere")
		caster:RemoveAbility("spellbringer_limb_disruption")
		caster:RemoveAbility("spellbringer_purification")
		caster:RemoveAbility("spellbringer_locate")
	elseif oldSet == 1 then
		caster:RemoveAbility("spellbringer_mana_disruption")
		caster:RemoveAbility("spellbringer_spell_disruption")
		caster:RemoveAbility("spellbringer_jomays_legacy")
		caster:RemoveAbility("spellbringer_glythtides_gift")
	elseif oldSet == 2 then
		caster:RemoveAbility("spellbringer_purification")
		caster:RemoveAbility("spellbringer_limb_disruption")
		caster:RemoveAbility("spellbringer_whole_displacement")
		caster:RemoveAbility("spellbringer_locate")
	elseif oldSet == 3 then
		caster:RemoveAbility("spellbringer_battle_sphere")
		caster:RemoveAbility("spellbringer_limb_disruption")
		caster:RemoveAbility("spellbringer_whole_displacement")
		caster:RemoveAbility("evoker_gar_zeng")
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
		caster:AddAbility("spellbringer_purification")
		caster:AddAbility("spellbringer_locate")
	elseif set == 1 then
		caster:AddAbility("spellbringer_mana_disruption")
		caster:AddAbility("spellbringer_spell_disruption")
		caster:AddAbility("spellbringer_jomays_legacy")
		caster:AddAbility("spellbringer_glythtides_gift")
	elseif set == 2 then
		caster:AddAbility("spellbringer_purification")
		caster:AddAbility("spellbringer_limb_disruption")
		caster:AddAbility("spellbringer_whole_displacement")
		caster:AddAbility("spellbringer_locate")
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

	if caster.abilitySet <= -1 then
		caster.abilitySet = 2
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

	if caster.abilitySet >= 3 then
		caster.abilitySet = 0
	end

	changeAbilitySet(caster, oldSet)
end

function SummonDarkrift(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerOwnerID()
	local target = keys.target_points[1]
	local maxUnits = 6
	local curUnits = 0
	local thisSpell = caster:GetItemInSlot(0)
	local kvRound = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	local round = Enfos.curRound + 3
-- filter out invalid rounds
	if round == 20 then
		round = 19
	elseif round == 36 then
		round = 35
	elseif round > 42 then
		round = 42
	end
-- get the correct data
	local roundString = string.format("Round" .. round)
	local roundData = kvRound[roundString]
	local unitToSpawn = roundData.UnitFodder_1a.NPCName
	local unitToSpawn2 = nil
	--print(unitToSpawn, unitToSpawn2)
-- spawn the unit
	for i=1,6 do
		
	end

	Timers:CreateTimer(DoUniqueString("SummonDarkrift"), {
		endTime = 0.2,
		callback = function()
			curUnits = curUnits + 1

			if curUnits <= maxUnits then
				local antiGrief = target.x
				if math.abs(antiGrief) < 1500 then
					if antiGrief < 0 then antiGrief = -1500
					else antiGrief = 1500 end
				end
				spawnLocation = Vector(antiGrief, target.y, target.z)
				spawnLocation = spawnLocation + RandomVector( RandomFloat( 0, 200 ) )
				unitToSpawn2 = unitToSpawn
				if unitToSpawn == "npc_dota_creep_crazed_madmen" then unitToSpawn2 = "npc_dota_creep_crazed_spearman" end if unitToSpawn == "npc_dota_creep_crazed_spearman" then unitToSpawn2 = "npc_dota_creep_crazed_madmen" end
				if unitToSpawn == "npc_dota_creature_wood_troll" then unitToSpawn2 = "npc_dota_creature_wood_troll_rock_tosser" end if unitToSpawn == "npc_dota_creature_wood_troll_rock_tosser" then unitToSpawn2 = "npc_dota_creature_wood_troll" end
				if unitToSpawn == "npc_dota_giant_spider" then unitToSpawn2 = "npc_dota_giant_poison_spider" end if unitToSpawn == "npc_dota_giant_poison_spider" then unitToSpawn2 = "npc_dota_giant_spider" end
				
				local unitToSpawnForReal = unitToSpawn
				--print(unitToSpawn, unitToSpawn2)
				if curUnits == 3 or curUnits == 6 then
					unitToSpawnForReal = unitToSpawn2
				end
				local unit = CreateUnitByName(unitToSpawnForReal, spawnLocation, true, caster, caster, caster:GetTeamNumber())
				unit:SetInitialGoalEntity(nil) -- (should) stop the spawned units from trying to run to the goal.
				unit.summonerUnit = true
				if curUnits == 3 or curUnits == 6 then
					if unitToSpawn2 == unitToSpawn then
						unit:SetHullRadius(roundData.UnitFodder_1a.HullSize)
						unit.hullSize = roundData.UnitFodder_1a.HullSize --just in case
						AddTypes(unit, roundData.UnitFodder_1a.ArmorType, roundData.UnitFodder_1a.AttackType)
					else
						unit:SetHullRadius(roundData.UnitFodder_2a.HullSize)
						unit.hullSize = roundData.UnitFodder_2a.HullSize
						AddTypes(unit, roundData.UnitFodder_2a.ArmorType, roundData.UnitFodder_2a.AttackType)
					end
				else
					unit:SetHullRadius(roundData.UnitFodder_1a.HullSize)
					unit.hullSize = roundData.UnitFodder_1a.HullSize
					AddTypes(unit, roundData.UnitFodder_1a.ArmorType, roundData.UnitFodder_1a.AttackType)
				end
				for i=1,3 do -- I dunno why I need to FindClearSpaceForUnit a bunch, but I do
					FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
				end
				unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
				unit:SetOwner(caster:GetOwner())
				unit:SetNoCorpse()
				--unit:SetMaximumGoldBounty(0)
				--unit:SetMinimumGoldBounty(0)
				--print(unit:GetGoldBounty())
				thisSpell:ApplyDataDrivenModifier(unit, unit, "modifier_summoner_summon_darkrift", {duration = 60})
				--thisSpell:ApplyDataDrivenModifier(unit, unit, "modifier_summon_purge_target", {})
				unit:AddNewModifier(unit, nil, "modifier_phased", {duration = 0.2})
				for i=1,15 do -- bit of a hacky way to make sure the units learn their abilities...
					if unit:GetAbilityByIndex(i) ~= nil then
						unit:GetAbilityByIndex(i):SetLevel(1)
					end
				end
				ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_ground_flash_ti4.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				unit:SetRenderColor(0, 84, 255)
				--unit:CreatureLevelUp(math.floor(GameRules.DIFFICULTY+(0.25*GameRules.DIFFICULTY)-1))
				--print(GameRules.DIFFICULTY+(0.25*GameRules.DIFFICULTY)-1)
				return 0.3
			end
		end
	})
	unitToSpawn2 = nil
end

--[[Author: Pizzalol
	Date: 09.02.2015.
	Chains from target to target, healing them and dealing damage to enemies in a small
	radius around them
	Jump priority is
	1. Hurt heroes
	2. Hurt units
	3. Heroes
	4. Units]]
function chain_heal( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local bounce_radius = ability:GetLevelSpecialValueFor("bounce_radius", ability_level)
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability_level)
	local heal = ability:GetLevelSpecialValueFor("heal", ability_level)
	local unit_healed = false

	local hit_table = {}

	-- Particles
	local shadow_wave_particle = keys.shadow_wave_particle
	local shadow_wave_damage_particle = keys.damage_particle

	-- If the target is not the caster then do the extra bounce for the caster
	if target ~= caster then
		-- Insert the caster into the hit table
		table.insert(hit_table, caster)
		-- Heal the caster and do damage to the units around it
		caster:Heal(heal, caster)
	end

	-- Mark the target as already hit
	table.insert(hit_table, target)
	-- Heal the initial target and do the damage to the units around it
	target:Heal(heal, caster)
	
	
	-- Priority is Hurt Heroes > Hurt Units > Heroes > Units
	-- we start from 2 first because we healed 1 target already
	for i = 2, max_targets do
		-- Helper variable to keep track if we healed a unit already
		unit_healed = false

		-- Find all the heroes in bounce radius
		local heroes = FindUnitsInRadius(caster:GetTeam(), target_location, nil, bounce_radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
		
		-- HURT HEROES --
		-- First we check for hurt heroes
		for _,unit in pairs(heroes) do
			local check_unit = 0	-- Helper variable to determine if a unit has been hit or not

			-- Checking the hit table to see if the unit is hit
			for c = 0, #hit_table do
				if hit_table[c] == unit then
					check_unit = 1
				end
			end

			-- If its not hit then check if the unit is hurt
			if check_unit == 0 then
				if unit:GetHealth() ~= unit:GetMaxHealth() then
					-- After we find the hurt hero unit then we insert it into the hit table to keep track of it
					-- and we also get the unit position
					table.insert(hit_table, unit)
					local unit_location = unit:GetAbsOrigin()

					-- Create the particle for the visual effect
					local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

					-- Set the unit as the new target
					target = unit
					target_location = unit_location

					-- Heal it and deal damage to enemy units around it
					target:Heal(heal, caster)

					-- Set the helper variable to true
					unit_healed = true

					-- Exit the loop for finding hurt heroes
					break
				end
			end
		end

		-- Find all the units in bounce radius
		local units = FindUnitsInRadius(caster:GetTeam(), target_location, nil, bounce_radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, 0, FIND_CLOSEST, false)
		
		-- HURT UNITS --
		-- check for hurt units if we havent healed a unit yet
		if not unit_healed then
			for _,unit in pairs(units) do
				local check_unit = 0	-- Helper variable to determine if the unit has been hit or not

				-- Checking the hit table to see if the unit is hit
				for c = 0, #hit_table do
					if hit_table[c] == unit then
						check_unit = 1
					end
				end

				-- If its not hit then check if the unit is hurt
				if check_unit == 0 then
					if unit:GetHealth() ~= unit:GetMaxHealth() then
						-- After we find the hurt hero unit then we insert it into the hit table to keep track of it
						-- and we also get the unit position
						table.insert(hit_table, unit)
						local unit_location = unit:GetAbsOrigin()

						-- Create the particle for the visual effect
						local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
						ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
						ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

						-- Set the unit as the new target
						target = unit
						target_location = unit_location

						-- Heal it and deal damage to enemy units around it
						target:Heal(heal, caster)
						local units_to_damage = FindUnitsInRadius(caster:GetTeam(), target_location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

						for _,v in pairs(units_to_damage) do
							-- Play the particle
							local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
							ParticleManager:SetParticleControlEnt(damage_particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
							ParticleManager:ReleaseParticleIndex(damage_particle)

							damage_table.victim = v
							ApplyDamage(damage_table)
						end

						-- Set the helper variable to true
						unit_healed = true

						-- Exit the loop for finding hurt heroes
						break
					end
				end
			end
		end

		-- HEROES --
		-- In this loop we search for valid heroes regardless if it is hurt or not
		-- Search only if we havent healed a unit yet
		if not unit_healed then
			for _,unit in pairs(heroes) do
				local check_unit = 0	-- Helper variable to determine if a unit has been hit or not

				-- Checking the hit table to see if the unit is hit
				for c = 0, #hit_table do
					if hit_table[c] == unit then
						check_unit = 1
					end
				end

				-- If its not hit then do the bounce
				if check_unit == 0 then
					-- Insert the found unit into the hit table
					-- and we also get the unit position
					table.insert(hit_table, unit)
					local unit_location = unit:GetAbsOrigin()

					-- Create the particle for the visual effect
					local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

					-- Set the unit as the new target
					target = unit
					target_location = unit_location

					-- Heal it and deal damage to enemy units around it
					target:Heal(heal, caster)

					-- Set the helper variable to true
					unit_healed = true

					-- Exit the loop
					break				
				end
			end
		end

		-- UNITS --
		-- Search for units regardless if it is hurt or not
		-- Search only if we havent healed a unit yet
		if not unit_healed then
			for _,unit in pairs(units) do
				local check_unit = 0	-- Helper variable to determine if a unit has been hit or not

				-- Checking the hit table to see if the unit is hit
				for c = 0, #hit_table do
					if hit_table[c] == unit then
						check_unit = 1
					end
				end

				-- If its not hit then do the bounce
				if check_unit == 0 then
					-- Insert the found unit into the hit table
					-- and we also get the unit position
					table.insert(hit_table, unit)
					local unit_location = unit:GetAbsOrigin()

					-- Create the particle for the visual effect
					local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

					-- Set the unit as the new target
					target = unit
					target_location = unit_location

					-- Heal it and deal damage to enemy units around it
					target:Heal(heal, caster)

					-- Set the helper variable to true
					unit_healed = true

					-- Exit the loop for finding hurt heroes
					break				
				end
			end
		end
	end
end

function mana_recharge(keys)
	local caster = keys.caster
	caster:GiveMana(30)
end

function Grazhirs_Effigy(keys)
	-- illusion code largely taken from SpellLibrary: https://github.com/Pizzalol/SpellLibrary
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local target = keys.target
	local ability = keys.ability
	local unit_name = target:GetUnitName()
	local origin = target:GetAbsOrigin() + RandomVector(100)
	local sDuration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

	-- handle_UnitOwner needs to be nil, else it will crash the game.
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	illusion:SetPlayerID(target:GetPlayerID())
	illusion:SetControllableByPlayer(player, true)
	
	illusion.custom_stats = true
	illusion.strength = target.strength
	illusion.strength_gain = target.strength_gain
	illusion.strength_bonus = target.strength_bonus
	illusion.strength_total = target.strength_total
	illusion.agility = target.agility
	illusion.agility_gain = target.agility_gain
	illusion.agility_bonus = target.agility_bonus
	illusion.agility_total = target.agility_total
	illusion.intellect = target.intellect
	illusion.intellect_gain = target.intellect_gain
	illusion.intellect_bonus = target.intellect_bonus
	illusion.intellect_total = target.intellect_total
	illusion.movespeed = target.movespeed
	illusion.speedagi = target.speedagi
	illusion.speedbase = target.speedbase
	illusion.damage_bonus = target.damage_bonus
	illusion.attribute_level = target.attribute_level
	
	--Stats:ModifyStatBonuses(illusion)
	--okay im just gonna copy and paste the entire stat page here
	
	---
	---
	---
	
	local applier = CreateItem("item_stat_modifier", nil, nil)
	local applier2 = CreateItem("item_stat_modifier_lua", nil, nil)
	
	if not illusion:HasModifier("modifier_movespeed_cap") then
		illusion:AddNewModifier( illusion, applier2, "modifier_movespeed_cap", {} )
	end
	
	-- Get player attribute values
	local strength = illusion.strength + illusion.strength_bonus
	local agility = illusion.agility + illusion.agility_bonus
	local intellect = illusion.intellect + illusion.intellect_bonus
	local movespeed = illusion:GetIdealSpeed()
	local basespeed = illusion:GetBaseMoveSpeed()
	local att = illusion:GetPrimaryAttribute()
	local damageStat = 0
	local damageStatBase = 0
	local damageStatPlus = 0
	if att == DOTA_ATTRIBUTE_STRENGTH then
		damageStat = strength
		damageStatBase = illusion.strength
		damageStatPlus = illusion.strength_bonus
	end
	if att == DOTA_ATTRIBUTE_AGILITY then
		damageStat = agility
		damageStatBase = illusion.agility
		damageStatPlus = illusion.agility_bonus
	end
	if att == DOTA_ATTRIBUTE_INTELLECT then
		damageStat = intellect
		damageStatBase = illusion.intellect
		damageStatPlus = illusion.intellect_bonus
	end
	-- Adjustments

	-- STR
	
		-- HP Bonus
		if not illusion:HasModifier("modifier_health_bonus") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_health_bonus", {})
		end

		local health_stacks = strength * HP_PER_STR
		illusion:SetModifierStackCount("modifier_health_bonus", illusion, health_stacks)
		
		illusion:SetHealth(target:GetHealth())

		-- HP Regen Bonus (flat)
		if not illusion:HasModifier("modifier_health_regen_constant") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_health_regen_constant", {})
		end

		local health_regen_stacks = strength * HP_REGEN_PER_STR * 100
		illusion:SetModifierStackCount("modifier_health_regen_constant", illusion, health_regen_stacks)

	-- AGI

		-- Attack Speed Bonus
		if not illusion:HasModifier("modifier_attackspeed_bonus_constant") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_attackspeed_bonus_constant", {})
		end

		local attackspeed_stacks = agility * ATKSPD_PER_AGI
		illusion:SetModifierStackCount("modifier_attackspeed_bonus_constant", illusion, attackspeed_stacks)

		-- Armor bonus
		local armorAdjustment = (ARMOR_PER_AGI * illusion.agility) + illusion.baseArmor
		illusion:SetPhysicalArmorBaseValue(armorAdjustment)
		if not illusion:HasModifier("modifier_physical_armor_bonus") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_physical_armor_bonus", {})
		end
		local armorAdjustment = ARMOR_PER_AGI * illusion.agility_bonus * 100
		illusion:SetModifierStackCount("modifier_physical_armor_bonus", illusion, armorAdjustment)
		
		--Move Speed Bonus
		illusion:SetBaseMoveSpeed(illusion.speedbase + (MOVE_SPEED_PER_AGI * agility))

	-- INT
		
		-- Mana Bonus
		if not illusion:HasModifier("modifier_mana_bonus") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_mana_bonus", {})
			--illusion:GiveMana(1)
		end

		local mana_stacks = intellect * MANA_PER_INT
		illusion:SetModifierStackCount("modifier_mana_bonus", illusion, mana_stacks)
		
		illusion:SetMana(target:GetMana())

		-- Mana Regen Bonus (flat)
		if not illusion:HasModifier("modifier_base_mana_regen") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_base_mana_regen", {})
		end

		--local mana_regen_stacks = intellect * mana_regen_adjustment_flat * 100
		local mana_regen_stacks = intellect * MANA_REGEN_PER_INT * 100
		illusion:SetModifierStackCount("modifier_base_mana_regen", illusion, mana_regen_stacks)

	-- Damage

	-- Get player primary stat value
		if not illusion:HasModifier("modifier_damage_bonus") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_damage_bonus", {})
		end

		local damage_stacks = damageStatBase
		illusion:SetModifierStackCount("modifier_damage_bonus", illusion, damage_stacks)
		
		if not illusion:HasModifier("modifier_damage_bonus_plus") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_damage_bonus_plus", {})
		end
		if not illusion:HasModifier("modifier_damage_bonus_minus") then
			applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_damage_bonus_minus", {})
			illusion:SetModifierStackCount("modifier_damage_bonus_minus", illusion, 1)
		end
		
		local damage_stacks_plus = damageStatPlus
		illusion:SetModifierStackCount("modifier_damage_bonus_plus", illusion, damage_stacks_plus+1)
	
	-- Update the stored values for next timer cycle
	illusion.strength_total = strength
	illusion.agility_total = agility
	illusion.intellect_total = intellect
	illusion.movespeed = movespeed
	illusion.damage_bonus = damageStat
		
	---
	---
	---
	
	--illusion:AddNewModifier(illusion, nil, "modifier_kill", {duration = sDuration})
	applier:ApplyDataDrivenModifier(illusion, illusion, "modifier_illusion_tracker_nofx", {})
	
	-- Level Up the unit to the casters level
	local targetLevel = target:GetLevel()
	for i=1,targetLevel-1 do
		illusion:HeroLevelUp(false)
	end

	-- Set the skill points to 0 and learn the skills of the caster
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = target:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility ~= nil then
				if CEnfosGameMode:CheckEffigySpell(abilityName,abilitySlot) == true then
					illusionAbility:SetLevel(abilityLevel)
				end
			end
		end
	end

	-- Recreate the items of the caster
	for itemSlot=0,5 do
		local item = target:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = sDuration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_illusion_lifesteal", {})
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
	
	local heroNetTable = {}
	heroNetTable[illusion:entindex()] = {
		strength = illusion.strength,
		strength_bonus = illusion.strength_bonus,
		strength_gain = illusion.strength_gain,
		agility = illusion.agility,
		agility_bonus = illusion.agility_bonus,
		agility_gain = illusion.agility_gain,
		intellect = illusion.intellect,
		intellect_bonus = illusion.intellect_bonus,
		intellect_gain = illusion.intellect_gain}
	CustomNetTables:SetTableValue("hero_data_live","summons",heroNetTable)
end
