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