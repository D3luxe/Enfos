function FistOfStone(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local caster_point = caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	
	--ripped chaos meteor code because i'm lazy. original at https://github.com/Pizzalol/SpellLibrary/blob/master/game/scripts/vscripts/heroes/hero_invoker/chaos_meteor.lua
	
	local caster_point_temp = Vector(caster_point.x, caster_point.y, 0)
	local target_point_temp = Vector(target_point.x, target_point.y, 0)
	
	local point_difference_normalized = (target_point_temp - caster_point_temp):Normalized()
	local velocity_per_second = point_difference_normalized * 300
	
	caster:EmitSound("Hero_EarthSpirit.RollingBoulder.Cast")
	
	--Create a particle effect consisting of the meteor falling from the sky and landing at the target point.
	local meteor_fly_original_point = (target_point - (velocity_per_second * 0.65)) + Vector (0, 0, 1000)  --Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
	local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/hero_entropist/fist_of_stone_fly.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, meteor_fly_original_point)
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, target_point)
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(0.65, 0, 0))
	
	Timers:CreateTimer({
		endTime = 0.65,
		callback = function()			
			local dummy = FastDummy(target_point, DOTA_TEAM_NOTEAM)
			local particle = ParticleManager:CreateParticle("particles/hero_entropist/fist_of_stone.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
			dummy:EmitSound("Hero_EarthSpirit.RollingBoulder.Destroy")
			Timers:CreateTimer({
				endTime = 0.03,
				callback = function()
					ParticleManager:DestroyParticle(particle,false)
					DelayDestroy(dummy, 0.2)
				end
			})
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
			local unitCount = table.getn(enemies)
			--failsafe
			if unitCount == 0 then return end
			for k,v in pairs(enemies) do
				DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
				ability:ApplyDataDrivenModifier(caster,v,"modifier_entropist_fist_of_stone_stun",{})
			end
		end
	})
	
	--[[local dummy = FastDummy(target_point, DOTA_TEAM_NOTEAM)
	local particle = ParticleManager:CreateParticle("particles/hero_entropist/fist_of_stone.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	--ParticleManager:SetParticleControl(particle,62,Vector(1,0,radius))
	dummy:EmitSound("Hero_EarthSpirit.RollingBoulder.Destroy")
	DelayDestroy(dummy, 0.5)]]
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