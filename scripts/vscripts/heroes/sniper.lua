function BurningGrenade(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local damage = keys.damage
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target, caster, keys.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
	for k,v in pairs(units) do
		DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
end