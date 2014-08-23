function FocusMoonbeam(keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local pid = caster:GetPlayerID()
-- checks for a previously cast moonbeam unit and, if it exists, destroys it and the timer tied to it. (is this correct behaviour?)
	if Enfos.moonbeamActive[pid] ~= nil then
		Enfos.moonbeamActive[pid]:Destroy()
		Timers:RemoveTimer("moonbeam_timer" .. pid)
	end
-- creates the moonbeam unit and sets a timer to destroy it after the duration expires
	Enfos.moonbeamActive[pid] = FastDummy(AdjustZ(target, 1536), caster:GetTeamNumber())
	Enfos.moonbeamActive[pid]:AddAbility("modspell_focus_moonbeam")
	Enfos.moonbeamActive[pid]:FindAbilityByName("modspell_focus_moonbeam"):SetLevel(1)
	Enfos.moonbeamActive[pid]:EmitSound("Hero_Luna.LucentBeam.Cast")
	local cPart = ParticleManager:CreateParticle("particles/hero_mentalist/luna_lucent_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, Enfos.moonbeamActive[pid])	
	ParticleManager:SetParticleControl(cPart,1,target)
	
	Timers:CreateTimer("moonbeam_timer" .. pid, {
		endTime = 300,
		callback = function()
			if Enfos.moonbeamActive[pid] ~= nil then
				Enfos.moonbeamActive[pid]:Destroy()
				Enfos.moonbeamActive[pid] = nil
			end
		end
	})
-- placeholder particle
end

