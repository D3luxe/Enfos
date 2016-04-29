function Heal(keys)
	keys.caster:Heal(keys.heal_amount, keys.caster)
end

function ReplenishMana(keys)
	keys.caster:GiveMana(keys.mana_amount)
end