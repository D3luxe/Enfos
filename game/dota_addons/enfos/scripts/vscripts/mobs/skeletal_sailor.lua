function Feedback(keys)
	local caster = keys.caster
	local target = keys.target
	local manaBurn = keys.ability:GetSpecialValueFor("mana_burn")
	target:SetMana(target:GetMana() - manaBurn)
	DealDamage(caster, target, manaBurn, DAMAGE_TYPE_MAGICAL, 0)
end