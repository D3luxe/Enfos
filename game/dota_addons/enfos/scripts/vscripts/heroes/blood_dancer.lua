function blood_dancer_magic_resistance(keys)
-- vars
	local caster = keys.caster
	local ability = keys.ability
	if ability ~= nil and ability:IsCooldownReady() and not caster:HasModifier("modifier_item_sphere_target") then
		caster:AddNewModifier(caster, ability, "modifier_item_sphere_target", {duration = -1})
	end
end

function blood_dancer_magic_resistance_thinker(keys)
-- checks to see if the sphere should be up
	local caster = keys.caster
	local ability = keys.ability
	if not caster:HasModifier("modifier_item_sphere_target") then
		if ability ~= nil and ability:IsCooldownReady() then
			caster:AddNewModifier(caster, ability, "modifier_item_sphere_target", {duration = -1})
		end
	end
end

--thx dotacraft
function wolverine_dance(keys)
    local caster = keys.caster
    local ability = keys.ability
    local damage = ability:GetAbilityDamage() * ability:GetSpecialValueFor("blade_fury_damage_tick")
    local radius = ability:GetSpecialValueFor("blade_fury_radius")
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
        
    for _,target in pairs(targets) do
        target:EmitSound("Hero_Juggernaut.BladeFury.Impact")
        ApplyDamage({victim = target, attacker = caster, damage = damage, ability = ability, damage_type = DAMAGE_TYPE_MAGICAL})
    end
end

--Stops the looping sound event
function wolverine_dance_stop(keys)
	local caster = keys.caster	
	caster:StopSound("Hero_Juggernaut.BladeFuryStart")
end