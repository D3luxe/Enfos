function preservation(keys)
	local caster = keys.caster
	local ability = keys.ability
	local shadowArts = caster:FindAbilityByName("shadow_priest_shadow_art_mastery")
	local shadowArtsLevel = shadowArts:GetLevel() - 1
	local shadowArtsLives = shadowArts:GetLevelSpecialValueFor("lives", shadowArtsLevel)
	print (shadowArtsLives)
	local lives = ability:GetSpecialValueFor("lives") + shadowArtsLives
	GameRules.Enfos:ModifyLife(caster:GetTeam(), 0, lives)
	if caster.repick == 0 then caster.repick = 1 end
end

function enfeeble(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sDuration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local shadowArts = caster:FindAbilityByName("shadow_priest_shadow_art_mastery")
	local shadowArtsLevel = shadowArts:GetLevel() - 1
	local shadowArtsDuration = shadowArts:GetLevelSpecialValueFor("duration", shadowArtsLevel)
	local totalDuration = sDuration + shadowArtsDuration
	print (shadowArtsDuration)
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	else
		ability:ApplyDataDrivenModifier(caster, target, "modifier_enfeeble_enfos", {duration = totalDuration}) -- the logic for enfeeble is handled in addon_game_mode.lua in the OnEntityKilled block
		target:RemoveModifierByName("modifier_faenellas_grace")
		if caster.repick == 0 then caster.repick = 1 end
	end
end

function greater_hallucination(keys)
-- illusion code largely taken from SpellLibrary: https://github.com/Pizzalol/SpellLibrary
	local caster = keys.caster
	local player = caster:GetPlayerID()
	local target = keys.target
	local ability = keys.ability
	local shadowArts = caster:FindAbilityByName("shadow_priest_shadow_art_mastery")
	local shadowArtsLevel = shadowArts:GetLevel() - 1
	local shadowArtsHeal = shadowArts:GetLevelSpecialValueFor("heal", shadowArtsLevel)
	local unit_name = target:GetUnitName()
	local origin = target:GetAbsOrigin() + RandomVector(100)
	local sDuration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor("outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor("incoming_damage", ability:GetLevel() - 1 )

	if shadowArtsHeal ~= nil then
		target:Heal(shadowArtsHeal, ability)
	end
	
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
	
	if target:FindModifierByName("modifier_sniper_technique") ~= nil then
		illusion:RemoveAbility("sniper_standard_technique")
		illusion:AddAbility("sniper_sniper_technique")
		illusion:FindAbilityByName("sniper_sniper_technique"):SetLevel(1)
		illusion:AddNewModifier(illusion, illusion:FindAbilityByName("sniper_sniper_technique"), "modifier_sniper_technique", {})
		illusion:FindAbilityByName("sniper_sniper_technique"):SetLevel(0)
	end
	
	if target:FindModifierByName("modifier_weaponsmith_forge_stack") ~= nil then
		illusion:AddAbility("weaponsmith_forge")
		illusion:FindAbilityByName("weaponsmith_forge"):SetLevel(
			target:FindAbilityByName("weaponsmith_forge"):GetLevel()
		)
		illusion:FindAbilityByName("weaponsmith_forge"):ApplyDataDrivenModifier( illusion, illusion, "modifier_weaponsmith_forge_stack", {} )
		illusion:SetModifierStackCount("modifier_weaponsmith_forge_stack", illusion, target:GetModifierStackCount("modifier_weaponsmith_forge_stack",target))
		illusion:FindAbilityByName("weaponsmith_forge"):SetLevel(0)
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
	ability:ApplyDataDrivenModifier(caster, illusion, "modifier_purification_target", {})
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
	
	local atkchange = false
	
	if target:FindModifierByName("modifier_faenrae_champion_inner_chaos") ~= nil then
		illusion:FindAbilityByName("faenrae_champion_inner_chaos"):SetLevel(
			target:FindAbilityByName("faenrae_champion_inner_chaos"):GetLevel()
		)
		illusion:FindAbilityByName("faenrae_champion_inner_chaos"):ApplyDataDrivenModifier( illusion, illusion, "modifier_faenrae_champion_inner_chaos", {duration = 45} )
		--illusion:AddNewModifier(illusion, illusion:FindAbilityByName("faenrae_champion_inner_chaos"), "modifier_faenrae_champion_inner_chaos", {duration = 45})
		illusion:FindAbilityByName("faenrae_champion_inner_chaos"):SetLevel(0)
		atkchange = true
	end
	
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
		
	if atkchange == true then
		heroNetTable[illusion:entindex()].attack = "modifier_attack_chaos"
		heroNetTable[illusion:entindex()].armor = "modifier_armor_hero"
	end
		
	CustomNetTables:SetTableValue("hero_data_live","summons",heroNetTable)
end

function greater_hallucination_lifesteal(keys)
	--Adds life steal to the illusions since it is hardcoded for normal lifesteal not to work.
	--PrintTable(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local damage = keys.DamageDealt
	--Defined in item_bloodthirst
	--local lifesteal = 10
	--print("Illusion life steal check")
	--Checks to see if the illusion has a bloodthirst
	if attacker:HasItemInInventory("item_bloodthirst") or attacker:HasItemInInventory("item_thirsting_blade") then
		local healAmount = damage * 0.1
		--print("Illusion has bloodthirst - healing for "..healAmount)
		attacker:Heal(healAmount, attacker)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN_FOLLOW, attacker)
	end
	if attacker:FindAbilityByName("ahlen_innate")~= nil then
		local healAmount = damage * 0.04
		--print("Illusion is Ahlen - healing for "..healAmount)
		attacker:Heal(healAmount, attacker)
		ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_ABSORIGIN_FOLLOW, attacker)
	end
end
function armageddon(keys)
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local impactDelay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1)
	local impactRadius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local searchRadius = ability:GetSpecialValueFor("meteor_fall_area")
	local shadowArts = caster:FindAbilityByName("shadow_priest_shadow_art_mastery")
	local shadowArtsLevel = shadowArts:GetLevel() - 1
	local shadowArtsChance = shadowArts:GetLevelSpecialValueFor("chance", shadowArtsLevel)
	local randomPoint = nil
	local randomNumber = math.random(1,100)
	if shadowArtsChance > randomNumber then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
		if units[1] == nil then -- end if no units found
			randomPoint = caster:GetAbsOrigin() + (RandomVector(searchRadius) * RandomFloat(0,1))
		else
			while #units > 1 do -- remove random units from the table until there's only one left
				table.remove(units, math.random(#units))
			end
			randomPoint = units[1]:GetAbsOrigin() -- not so random I guess
		end
	else
		randomPoint = caster:GetAbsOrigin() + (RandomVector(searchRadius) * RandomFloat(0,1))
	end
	local blastDummy = FastDummy(randomPoint, caster:GetTeamNumber())
	blastDummy:EmitSound("Hero_Invoker.SunStrike.Charge")
	local preParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_ABSORIGIN_FOLLOW, blastDummy)
	ParticleManager:SetParticleControl(preParticle, 0, randomPoint) 
	ParticleManager:SetParticleControl(preParticle, 1, Vector(impactRadius,0,0))
	Timers:CreateTimer(DoUniqueString("armageddonDelay"), {
		endTime = impactDelay,
		callback = function()
			blastDummy:StopSound("Hero_Invoker.SunStrike.Charge")
			ParticleManager:DestroyParticle(preParticle, true)
			blastDummy:EmitSound("Hero_Invoker.SunStrike.Ignite")
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, blastDummy)
			ParticleManager:SetParticleControl(particle, 0, randomPoint) 
			ParticleManager:SetParticleControl(particle, 1, Vector(impactRadius,0,0))
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), blastDummy:GetAbsOrigin(), caster, impactRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
			for k,v in pairs(enemies) do
				DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
			end
			DelayDestroy(blastDummy, 1)
		end
	})
end


						-- "FireEffect"
						-- {
							-- "EffectName"        "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
							-- "EffectAttachType"  "follow_origin"
							-- "Target"            "TARGET"

							-- "ControlPoints"
							-- {
								-- "01"	"%area_of_effect 0 0"
							-- }
						-- }












