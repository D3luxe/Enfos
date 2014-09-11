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