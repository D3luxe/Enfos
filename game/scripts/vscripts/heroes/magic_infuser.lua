function Empower_Armor(keys)
	local caster = keys.caster
	local casterMana = caster:GetMana()
	local ability = caster:FindAbilityByName("generic_enfos_empower_armor")
	local manaCost = ability:GetManaCost(1)
	local cooldown = ability:GetCooldown(1)
	local cooldownRemaining = ability:GetCooldownTimeRemaining()
	local healMultiplier = ability:GetSpecialValueFor("heal_per_str")

	if casterMana >= manaCost and cooldownRemaining == 0 then
		caster:SetMana(casterMana - manaCost)
		caster:FindAbilityByName("generic_enfos_empower_armor"):StartCooldown(cooldown)
		--Heal caster
		local strength = caster:GetStrength()
		local healed = strength * healMultiplier

		caster:Heal(healed, keys.caster)

		--Play fx
		local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

		Timers:CreateTimer(DoUniqueString("destroyArmorParticle"), {
		endTime = 1,
		callback = function()
			if fx ~= nil then
				ParticleManager:DestroyParticle(fx, false)
			end
		end
		})

	end
end

function MagicInfuserSpendMana(keys)
	local caster = keys.caster
	local manaCost = keys.manacost
	local ability = keys.ability
	local radius = keys.radius
	
	local casterMana = caster:GetMana()
	if casterMana >= manaCost then
		caster:SetMana(casterMana - manaCost)
		ability:OnChannelFinish(false)
	end
end
