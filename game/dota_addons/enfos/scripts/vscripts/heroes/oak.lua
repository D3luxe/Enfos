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
	
function HardenedSkin(keys)
	local caster = keys.caster
	local ability = keys.ability
	print("before "..caster.strength)
	if ability:GetLevel() > 0 then
		if caster:GetModifierStackCount("modifier_oak_hardened_skin",caster) == 0 then
			caster.strength = caster.strength + ability:GetLevelSpecialValueFor("strength_bonus", ability:GetLevel()-1)
		else
			caster.strength = caster.strength + ability:GetLevelSpecialValueFor("strength_bonus", ability:GetLevel()-1)
			- ability:GetLevelSpecialValueFor("strength_bonus", caster:GetModifierStackCount("modifier_oak_hardened_skin",caster)-1)
		end
		--print("bah "..caster:GetModifierStackCount("modifier_oak_hardened_skin",caster))
		caster:SetModifierStackCount("modifier_oak_hardened_skin", caster, ability:GetLevel())
		--print("gah "..caster:GetModifierStackCount("modifier_oak_hardened_skin",caster))
	else
		caster.strength = caster.strength - ability:GetLevelSpecialValueFor("strength_bonus", caster:GetModifierStackCount("modifier_oak_hardened_skin",caster)-1)
		--[[if caster:HasModifier("modifier_oak_hardened_skin") then
			caster:RemoveModifierByName("modifier_oak_hardened_skin")
		end]]
		caster:SetModifierStackCount("modifier_oak_hardened_skin", caster, ability:GetLevel())
	end
	print("after "..caster.strength)
	Timers:CreateTimer(DoUniqueString("goddammitwouldyoujustworkalready"), {
		endTime = 0.1,
		callback = function()		
			--stat update
			local heroNetTable = {}
			heroNetTable[caster:GetPlayerID()] = {
				str = caster.strength}
			CustomNetTables:SetTableValue("hero_data_live","stats",heroNetTable)
		end
	})
	
end