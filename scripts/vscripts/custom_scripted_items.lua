function Heal(keys)
	keys.caster:GetPlayerOwner():GetAssignedHero():Heal(keys.heal_amount, keys.caster)
end

function ReplenishMana(keys)
	keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(keys.mana_amount)
end