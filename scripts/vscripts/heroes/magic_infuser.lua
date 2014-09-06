function Empower_Armor(keys)
	local caster = keys.caster
	local manaCost = 30
	local casterMana = caster:GetMana()
	if casterMana >= manaCost then
		caster:SetMana(casterMana - manaCost)
		caster:FindAbilityByName("generic_enfos_empower_armor"):StartCooldown(30.0)
		--Heal caster
		local strength = caster:GetStrength()
		local healed = strength * 20

		caster:Heal(healed, keys.caster)

		--Play fx
		ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end
end

function MagicInfuserSpendMana(keys)
	local caster = keys.caster
	local manaCost = keys.manacost
	local casterMana = caster:GetMana()
	if casterMana >= manaCost then
		caster:SetMana(casterMana - manaCost)
	end
end
