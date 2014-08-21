function Heal(keys)
	keys.caster:GetPlayerOwner():GetAssignedHero():Heal(keys.heal_amount, keys.caster)
end