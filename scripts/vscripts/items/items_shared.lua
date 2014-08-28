function blink(keys)
	--PrintTable(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()

	local difference = point - casterPos

	if difference:Length2D() > keys.Range then
		point = casterPos + (point - casterPos):Normalized() * keys.Range
	end
	FindClearSpaceForUnit(caster, point, false)
	ParticleManager:CreateParticle("particles/econ/events/ti4/blink_dagger_start_ti4.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
end