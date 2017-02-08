function EquipThirstingBlade(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		--print("Attacker is ranged")
		return
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_thirsting_blade_leech", {})
	end
end

function UnequipThirstingBlade(keys)
	local ability = keys.ability
	local caster = keys.caster

	caster:RemoveModifierByName("modifier_thirsting_blade_leech")
end

function EquipBloodthirst(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		--print("Attacker is ranged")
		return
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bloodthirst_leech", {})
	end
end

function UnequipBloodthirst(keys)
	local ability = keys.ability
	local caster = keys.caster

	caster:RemoveModifierByName("modifier_bloodthirst_leech")
end

function EquipVampiricPotion(keys)
	local caster = keys.caster
	local ability = keys.ability
	--if caster:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		--ability:ApplyDataDrivenModifier(caster, caster, "modifier_vampiric_potion_nope", {})
	--else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_vampiric_potion_leech", {})
	--end
end

function UnequipVampiricPotion(keys)
	local ability = keys.ability
	local caster = keys.caster

	caster:RemoveModifierByName("modifier_vampiric_potion_leech")
	--caster:RemoveModifierByName("modifier_vampiric_potion_nope")
end

function empath_pickup(keys)
	--[[
	1: STRENGTH
	2: INTELLECT
	3: AGILITY
	4: GOLD
	]]
	local caster = keys.caster
	local tome = keys.ability
	local statBonus = tome:GetLevelSpecialValueFor("bonus_stat", 0)
	local statModified = tome:GetLevelSpecialValueFor("stat", 0)
	

	if caster:IsRealHero() == false then
		caster = caster:GetPlayerOwner():GetAssignedHero()
	end

	local stat = ""
	if statModified == 1 then
		stat = "strength"
	elseif statModified == 2 then
		stat = "intellect"
	elseif statModified == 3 then
		stat = "agility"
	elseif statModified == 4 then
		stat = "gold"
	elseif statModified == 5 then
		stat = "lumber"
	end
	if stat ~= "" then
		if not caster:HasModifier("modifier_cast_once") then
			tome:ApplyDataDrivenModifier(caster, caster, "modifier_cast_once", nil)
			GameRules.Enfos:UseTome(caster, stat, statBonus)
		end
	end
	--PrintTable(keys)
end

function blink(keys)
	--PrintTable(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()

	ProjectileManager:ProjectileDodge(caster)

	local difference = point - casterPos

	if difference:Length2D() > keys.Range then
		point = casterPos + (point - casterPos):Normalized() * keys.Range
	end
	FindClearSpaceForUnit(caster, point, false)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	Timers:CreateTimer("blink_timer" .. pid, {
		endTime = 0.03, 	
		callback = function()
			ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	})
end

function ironbark_leathers(keys)
-- vars
	local caster = keys.caster
	local ability = keys.ability
	if ability ~= nil and ability:IsCooldownReady() and not caster:HasModifier("modifier_item_sphere_target") then
		caster:AddNewModifier(caster, ability, "modifier_item_sphere_target", {duration = -1})
	end
end

function ironbark_leathers_thinker(keys)
-- checks to see if the sphere should be up
	local caster = keys.caster
	local ability = keys.ability
	
	if not caster:HasModifier("modifier_item_sphere_target") then
		if ability ~= nil and ability:IsCooldownReady() then
			caster:AddNewModifier(caster, ability, "modifier_item_sphere_target", {duration = -1})
		end
	end
end

function ironbark_leathers_drop(keys)
	keys.caster:RemoveModifierByName("modifier_item_sphere_target")
end

function purge(keys)
	local caster = keys.caster
	
	--CustomPurge(unit, RemoveBuff, RemoveDebuff)
	CustomPurge(caster, true, true)
end

