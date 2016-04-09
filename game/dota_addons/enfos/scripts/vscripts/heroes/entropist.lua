function FistOfStone(keys)
	local radius = keys.particle_radius
	local target = keys.target_points[1]
	local dummy = FastDummy(target, DOTA_TEAM_NOTEAM)
	local particle = ParticleManager:CreateParticle("particles/hero_entropist/batrider_flamebreak_explosion_i.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl(particle,62,Vector(1,0,radius))
	dummy:EmitSound("Hero_EarthSpirit.RollingBoulder.Destroy")
	DelayDestroy(dummy, 0.5)
end

function RingOfSpears(keys)
	local radius = keys.radius
	local target = keys.target_points[1]
	local dummy = FastDummy(target, DOTA_TEAM_NOTEAM)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl(particle,1,Vector(radius,0,0))
	dummy:EmitSound("Hero_Leshrac.Split_Earth")
	DelayDestroy(dummy, 0.5)
end

function Tremor(keys)
	-- vars
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target_points[1]
	local slow = keys.slow
	local radius = keys.radius
	local tremorLevel = ability:GetLevel()
	Enfos.tremorDummy = FastDummy(target, caster:GetTeamNumber())
	Enfos.tremorDummy:AddAbility("entropist_tremor_proxy")
	local dummySpell = Enfos.tremorDummy:FindAbilityByName("entropist_tremor_proxy")
	dummySpell:SetLevel(tremorLevel)
	
	Timers:CreateTimer(DoUniqueString("tremor_fx"), {
		endTime = 0.03,
		callback = function()
		if Enfos.tremorDummy ~= 0 then 
			local tPart = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN_FOLLOW, Enfos.tremorDummy)
			EmitSoundOn("Hero_Brewmaster.ThunderClap", Enfos.tremorDummy)
		end
-- keep it going if you're still channeling
			if ability:IsChanneling() then
				return 0.5
			end
		end
	})
	
end

function TremorEnd(keys)
	Enfos.tremorDummy:Destroy()
	Enfos.tremorDummy = 0
end