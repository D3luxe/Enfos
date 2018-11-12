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

function sunstone(keys)
	local duration = keys.duration
	local info = {}
	info.isTrue = true
	Enfos.sunstone = GameRules:GetGameTime()+duration
	CustomGameEventManager:Send_ServerToAllClients( "sunstone_use", info )
	Timers:CreateTimer(duration,function()
		info.isTrue = false
		if Enfos.sunstone <= GameRules:GetGameTime() then CustomGameEventManager:Send_ServerToAllClients( "sunstone_use", info ) end
	end)
end

function lure(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.radius

	local targets = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), target, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, 1, false)
	for k,v in pairs(targets) do
		ability:ApplyDataDrivenModifier(target, v, "modifier_lure_pouch_target", {})
	end
end

function lure_on(keys)
	--lifted from https://github.com/Pizzalol/SpellLibrary/blob/master/game/scripts/vscripts/heroes/hero_axe/berserkers_call.lua
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	-- otherwise forces the target to sit and do nothing
	if caster:IsAlive() then
		local order = 
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
	else
		target:Stop()
	end

	-- Set the force attack target to be the caster
	target:SetForceAttackTarget(caster)
end

function lure_off(keys)
	local target = keys.target

	target:SetForceAttackTarget(nil)
end

function attribute_bonus_update(keys)
	local caster = keys.caster
	local attname = keys.attname
	local amount = keys.amount
	local gain = keys.gain
	--print(attname)
	if attname == "double_bonus" then
		--print(caster.agility_bonus)
		--print(caster.intellect_bonus)
		caster.agility_bonus = caster.agility_bonus + (amount * gain)
		caster.intellect_bonus = caster.intellect_bonus + (amount * gain)
		--print(caster.agility_bonus)
		--print(caster.intellect_bonus)
	elseif attname == "all_bonus" then
		--print(caster.strength_bonus)
		--print(caster.agility_bonus)
		--print(caster.intellect_bonus)
		caster.strength_bonus = caster.strength_bonus + (amount * gain)
		caster.agility_bonus = caster.agility_bonus + (amount * gain)
		caster.intellect_bonus = caster.intellect_bonus + (amount * gain)
		--print(caster.strength_bonus)
		--print(caster.agility_bonus)
		--print(caster.intellect_bonus)
	else
		--print(caster[attname])
		caster[attname] = caster[attname] + (amount * gain)
		--print(caster[attname])
	end
end