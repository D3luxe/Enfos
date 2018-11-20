function Favored_Enemy(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	--print("Casting Favored Enemy")
	--If there is no current favored enemy stored (beginning of game) then set one and return out
	if caster.FavoredEnemy == nil then
		--print("Favored Enemy nil, setting")
		caster.FavoredEnemy = target:GetUnitName()
		--print(caster.FavoredEnemy)
		if caster.FavoredEnemy == "npc_dota_creep_crazed_madmen" then caster.FavoredEnemy2 = "npc_dota_creep_crazed_spearman" end if caster.FavoredEnemy == "npc_dota_creep_crazed_spearman" then caster.FavoredEnemy2 = "npc_dota_creep_crazed_madmen" end
		if caster.FavoredEnemy == "npc_dota_creature_wood_troll" then caster.FavoredEnemy2 = "npc_dota_creature_wood_troll_rock_tosser" end if caster.FavoredEnemy == "npc_dota_creature_wood_troll_rock_tosser" then caster.FavoredEnemy2 = "npc_dota_creature_wood_troll" end
		if caster.FavoredEnemy == "npc_dota_giant_spider" then caster.FavoredEnemy2 = "npc_dota_giant_poison_spider" end if caster.FavoredEnemy == "npc_dota_giant_poison_spider" then caster.FavoredEnemy2 = "npc_dota_giant_spider" end
		return
	end
	--print("Favored enemy currently is "..caster.FavoredEnemy)
	-- If a favored enemy already exists, then cycle through all of the mobs and remove the modifier to prepare to switch targets
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	
	for k,v in pairs(units) do
		if v:GetUnitName() == caster.FavoredEnemy or v:GetUnitName() == caster.FavoredEnemy2 then
			if v:HasModifier("modifier_favored_enemy_targeted") then
				--print("Removing favored enemy from "..v:GetUnitName())
				v:RemoveModifierByName("modifier_favored_enemy_targeted")
			end
		end
	end

	caster.FavoredEnemy2 = nil
	--Set the new favored enemy
	caster.FavoredEnemy = target:GetUnitName()
	if caster.FavoredEnemy == "npc_dota_creep_crazed_madmen" then caster.FavoredEnemy2 = "npc_dota_creep_crazed_spearman" end if caster.FavoredEnemy == "npc_dota_creep_crazed_spearman" then caster.FavoredEnemy2 = "npc_dota_creep_crazed_madmen" end
	if caster.FavoredEnemy == "npc_dota_creature_wood_troll" then caster.FavoredEnemy2 = "npc_dota_creature_wood_troll_rock_tosser" end if caster.FavoredEnemy == "npc_dota_creature_wood_troll_rock_tosser" then caster.FavoredEnemy2 = "npc_dota_creature_wood_troll" end
	if caster.FavoredEnemy == "npc_dota_giant_spider" then caster.FavoredEnemy2 = "npc_dota_giant_poison_spider" end if caster.FavoredEnemy == "npc_dota_giant_poison_spider" then caster.FavoredEnemy2 = "npc_dota_giant_spider" end
	--print("New favored enemy is "..caster.FavoredEnemy)

	-- Initial application of favored enemy debuff
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)

	for k,v in pairs(units) do
		if v:GetUnitName() == caster.FavoredEnemy or v:GetUnitName() == caster.FavoredEnemy2 then
			if not v:HasModifier("modifier_favored_enemy_targeted") then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_favored_enemy_targeted", {})
			end
		end
	end

end

function Favored_Enemy_Damage(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("bonus_damage")
	local duration = ability:GetSpecialValueFor("stun_duration")

	if caster.FavoredEnemy == nil then
		return
	end

	if target:GetUnitName() == caster.FavoredEnemy or target:GetUnitName() == caster.FavoredEnemy2 then
		DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})
	end


	--Removes favored enemy if Ranger attacks a mob from another wave.
	if target:GetUnitName() ~= caster.FavoredEnemy and target:GetUnitName() ~= caster.FavoredEnemy2 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)

		for k,v in pairs(units) do
			if v:GetUnitName() == caster.FavoredEnemy or v:GetUnitName() == caster.FavoredEnemy2 then
				if v:HasModifier("modifier_favored_enemy_targeted") then
					--print("Removing favored enemy from "..v:GetUnitName())
					v:RemoveModifierByName("modifier_favored_enemy_targeted")
				end
			end
		end

		caster.FavoredEnemy = nil
		caster.FavoredEnemy2 = nil
	end
end

function Favored_Enemy_Tick(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if caster.FavoredEnemy == nil then
		--print("Tick cancelled no favored enemy")
		return
	end

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)

	for k,v in pairs(units) do
		if v:GetUnitName() == caster.FavoredEnemy or v:GetUnitName() == caster.FavoredEnemy2 then
			if not v:HasModifier("modifier_favored_enemy_targeted") then
				--print("Ticking - applying modifier to mob "..v:GetUnitName())
				ability:ApplyDataDrivenModifier(caster, v, "modifier_favored_enemy_targeted", {})
			end
		end
	end
end


function Haraweps_Bonds_Autocast(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Name of the modifier to avoid casting the spell on targets that were already buffed
	local modifier = "modifier_ranger_haraweps_bonds"

	-- Get if the ability is on autocast mode and cast the ability on the attacked target if it doesn't have the modifier
	if ability:GetAutoCastState() and ability:IsFullyCastable() and not ability:IsInAbilityPhase() then
		if not IsChanneling( caster ) then
			if not target:HasModifier(modifier) then
				caster:CastAbilityOnTarget(target, ability, caster:GetPlayerOwnerID())
			end
		end	
	end	
end

-- Auxiliar function that goes through every ability and item, checking for any ability being channelled
function IsChanneling ( unit )
	
	for abilitySlot=0,15 do
		local ability = unit:GetAbilityByIndex(abilitySlot)
		if ability ~= nil and ability:IsChanneling() then 
			return true
		end
	end

	for itemSlot=0,5 do
		local item = unit:GetItemInSlot(itemSlot)
		if item ~= nil and item:IsChanneling() then
			return true
		end
	end

	return false
end

function SummonMeraudsCompanion(keys)
-- vars
	local caster = keys.caster
	local thisSpellLevel = caster:FindAbilityByName("ranger_merauds_companion"):GetLevel()
	local findUnits = Entities:FindAllByClassnameWithin("npc_dota_creature", caster:GetAbsOrigin(), 1000)
-- logic
	--print("Spawning unit")
	for k,v in pairs(findUnits) do
		if v:GetUnitName() == "npc_merauds_companion" and not v.summonerUnit then -- in case the cooldowns get refreshed, we don't want to upgrade existing units
			v:AddNewModifier(unit, nil, "modifier_phased", {duration = 3}) -- to prevent them from getting stuck
			v.summonerUnit = true 	
			AddTypes(v, "modifier_armor_light", "modifier_attack_normal")
			v:SetBaseDamageMin(keys.damage)
			v:SetBaseDamageMax(keys.damage)
			v:SetMaxHealth(keys.health)
			v:SetBaseMaxHealth(keys.health)
			v:SetHealth(keys.health)
		end
	end
end

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

function MinimumRangeCheck(keys)
	local caster = keys.caster
	local target = keys.target
	
	if caster.acq_range == nil then caster.acq_range = caster:GetAcquisitionRange() end
	--print(target:FindModifierByNameAndCaster("modifier_ranger_check_aura",caster))
	if target:FindModifierByNameAndCaster("modifier_ranger_check_aura",caster) ~= nil then
		
		--print("FINDING TARGET")
		local potential_targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, caster.acq_range+caster:GetHullRadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        for k,v in pairs(potential_targets) do
			--PrintTable(v:FindAllModifiers())
			--print(v:FindModifierByNameAndCaster("modifier_ranger_check_aura",caster))
			--print(v)
			if v:FindModifierByNameAndCaster("modifier_ranger_check_aura",caster) == nil then
				--print((v:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D())
				if (v:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() >= 250 then
					caster:MoveToTargetToAttack(v)
					caster.acq_limit = false
					caster:SetAcquisitionRange(caster.acq_range)
					print("NOOB ACQUIRED")
					return
				end
            end
        end
		
		caster:Stop()
		caster.acq_limit = true
		caster.acq_range = caster:GetAcquisitionRange()
		caster:SetAcquisitionRange(0)
		if caster.acq_loop == nil then caster.acq_loop = 1
		else caster.acq_loop = caster.acq_loop + 1 end
		if caster.acq_loop == 101 then caster.acq_loop = 1 end
		local timeLoop = caster.acq_loop
		
		Timers:CreateTimer("rangerLoop", {
			endTime = GameRules:GetGameTime()+0.25,
			callback = function()
				--print("SEARCHING FOR NOOB")
				if caster.acq_limit == false then return end
				if caster.acq_loop ~= timeLoop then return end
				
				potential_targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, caster.acq_range+caster:GetHullRadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
				for k,v in pairs(potential_targets) do

					if v:FindModifierByNameAndCaster("modifier_ranger_check_aura",caster) == nil then
						caster:SetAttacking(v)
						caster.acq_limit = false
						caster:SetAcquisitionRange(caster.acq_range)
						return
					end
				end
				
				if caster.acq_limit == true then return GameRules:GetGameTime()+0.25 end
			end
		})
	end
end