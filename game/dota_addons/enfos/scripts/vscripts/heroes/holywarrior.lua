-- this DOES work
function TippingTheScales(keys)
-- vars
	local attacker = keys.attacker
	local reflectAmount = attacker:GetAverageTrueAttackDamage(attacker)
	local caster = keys.caster
	local percentReflected = keys.damage_reflected / 100
	--DealDamage(caster, attacker, reflectAmount * percentReflected, DAMAGE_TYPE_PURE, 0)
end