function zephyr (keys)
	local caster = keys.caster
	local radius = keys.radius
	local target = keys.target_points[1]

	local dummy = FastDummy(target, caster:GetTeamNumber())
	local particle = ParticleManager:CreateParticle("particles/hero_tempest/razor_rain_storm.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl(particle,62,Vector(radius/228,1,1))
	dummy:AddAbility("tempest_zephyr_proxy")
	local dummySpell = dummy:FindAbilityByName("tempest_zephyr_proxy")
-- logic
	dummySpell:SetLevel(1)


	DelayDestroy(dummy, 10)

	Timers:CreateTimer(DoUniqueString("zephyr"), {
		endTime = 1,
		callback = function()
			if dummy ~= nil then
				local units = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), caster, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 1, false)
				for k,v in pairs(units) do
					local maxHealth = v:GetMaxHealth()
					local healed = maxHealth * 0.02
					v:Heal(healed, caster)
				end
				return 1
			end
		end
	})
end

function paeldryths_wrath (keys)
	PrintTable(keys)
end