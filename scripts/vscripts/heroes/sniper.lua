function TechniqueAcqRangeUp(keys)
	keys.caster:RemoveAbility("sniper_standard_technique")
	keys.caster:AddAbility("sniper_sniper_technique")
	keys.caster:SetAcquisitionRange(3600)
	keys.caster:FindAbilityByName("sniper_sniper_technique"):StartCooldown(30.0)
	keys.caster:FindAbilityByName("sniper_sniper_technique"):SetLevel(1) --[[Returns:void
	Sets the level of this ability.
	]]

end

function TechniqueAcqRangeDown(keys)
	keys.caster:RemoveModifierByName("modifier_sniper_technique")
	keys.caster:RemoveAbility("sniper_sniper_technique")
	keys.caster:AddAbility("sniper_standard_technique")
	keys.caster:SetAcquisitionRange(700)
	keys.caster:FindAbilityByName("sniper_standard_technique"):StartCooldown(30.0)
	keys.caster:FindAbilityByName("sniper_standard_technique"):SetLevel(1)
end

function TechniquePierce(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	local damage = caster:GetAverageTrueAttackDamage() -- this isn't perfect but it's good enough. damage ranges really aren't a meaningful factor
	local pid = caster:GetPlayerID()
	local splashCount = 0
	
	local applier = caster:GetAbilityByIndex(3)
-- apply the flag so it doesn't hit twice
	applier:ApplyDataDrivenModifier(caster, target, "modifier_skill_flag", {}) -- apply a flag to the main unit so that we don't double hit it
-- find valid units
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 3500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	local inCone = {}
	local a, b, c = GetLine(caster, target)
	for k,v in pairs (units) do
		local tDistToLine = GetDistanceToLine(v, a, b, c)
		if ((v:BoundingRadius2D() * 2) + 5 > tDistToLine) and not v:HasModifier("modifier_skill_flag") then -- giving the diamater an extra 5 to make it feel just a little better
			table.insert(inCone, v) -- add the unit if it's not in the cone
		end
	end
-- getting the correct behaviour 
	for k,v in pairs(inCone) do
		if splashCount < 1 then
			DealDamage(caster, v, damage, DAMAGE_TYPE_PHYSICAL, 0)
			splashCount = splashCount + 1
		end
	end
	target:RemoveModifierByName("modifier_skill_flag")
end

function FireAmmoRefund(keys)
-- vars
	local caster = keys.caster
	local spell = caster:GetAbilityByIndex(0)
	local cost = spell:GetManaCost(spell:GetLevel() - 1)
	caster:SetMana(caster:GetMana() + cost)
end

function FireAmmoCost(keys)
-- vars
	local caster = keys.caster
	local spell = caster:GetAbilityByIndex(0)
	local cost = spell:GetManaCost(spell:GetLevel())
	caster:SetMana(caster:GetMana() - cost)
-- turn it off if we don't have the mana
	if caster:GetMana() <= 0 then
		if spell:GetToggleState() then
			spell:ToggleAbility()
		end
	end
end
		

function BurningGrenade(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local damage = keys.damage
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target, caster, keys.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
	for k,v in pairs(units) do
		DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
end