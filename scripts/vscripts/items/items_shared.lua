function blink(keys)
	--PrintTable(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()

	local difference = point - casterPos

	if difference:Length2D() > keys.Range then
		point = casterPos + (point - casterPos):Normalized() * keys.Range
	end
	FindClearSpaceForUnit(caster, point, false)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	Timers:CreateTimer("blink_timer" .. pid, {
		endTime = 0.03, 	
		callback = function()
			ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		end
	})
end