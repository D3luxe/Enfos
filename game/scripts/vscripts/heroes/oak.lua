function PoisonGas(keys) -- this handles the particle only.
-- vars
	local caster = keys.caster
	local target = keys.target
	local radius = keys.radius
	local dummy = FastDummy(target:GetAbsOrigin(), DOTA_TEAM_NOTEAM)
	local particle = ParticleManager:CreateParticle("particles/hero_oak/oak_poison_gas.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, 1, radius)) -- smoke cloud radius
	ParticleManager:SetParticleControl(particle, 62, Vector(radius, 0, 0)) -- the rest of the particle
	DelayDestroy(dummy, 1.0)
	
	
end

function RootageTrap(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local sphereCheck = magic_block_check(target)
	if sphereCheck then
		return
	end
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_oak_rootage_trap", {})
end
	