function throw_naptha(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local sDuration = ability:GetSpecialValueFor("duration")
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	for k,v in pairs(units) do
		ability:ApplyDataDrivenModifier(caster, v, "modifier_throw_naptha_debuff", {duration = sDuration})
	end
end

function mantle_of_flames(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1) / 10 -- applies ten times per second
	local cost = ability:GetLevelSpecialValueFor("mana_cost", ability:GetLevel() - 1)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	-- mana cost per second is easy now
	caster:SpendMana(cost, ability)
	for k,v in pairs(units) do
		DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
end

function dragons_breath(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sDuration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	if target:HasModifier("modifier_throw_naptha_debuff") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_breath_ignite", {duration = sDuration})
	end
end