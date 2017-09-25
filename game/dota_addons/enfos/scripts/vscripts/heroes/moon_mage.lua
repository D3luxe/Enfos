function CancelAnimation(keys)
	local caster = keys.caster
	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
end

-- this doesn't have the little duration ball 
function StarlightSphereSummon(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local ball = CreateUnitByName("npc_starlight_sphere", caster:GetAbsOrigin(), true, caster:GetPlayerOwner(), caster, caster:GetPlayerOwnerID() ) 
	caster.sphere = ball
	--[[local findSphere = Entities:FindAllByClassnameWithin("npc_dota_base_additive", caster:GetAbsOrigin(), 300)
	for k,v in pairs(findSphere) do
		if v:GetUnitName() == "npc_starlight_sphere" then
			Enfos.starlightSphere[pid] = v
			break
		end
	end]]
	ball:SetControllableByPlayer(pid, true)
	ball:GetAbilityByIndex(0):SetLevel(1)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_ambient.vpcf", PATTACH_OVERHEAD_FOLLOW, ball)
	ball:EmitSound("Hero_Wisp.Spirits.Loop")
-- set the duration timer
	ball:AddNewModifier(caster, caster, "modifier_kill", {duration = keys.ability:GetSpecialValueFor("duration")})
end

function StarlightSphereDetonate(keys)
-- vars
	local caster = keys.caster
	local owner = caster:GetOwner()
	local pid = owner:GetPlayerID()
	local damage = keys.damage
	local unitsFullRadius = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), caster, keys.full_damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	local unitsReducedRadius = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), caster, keys.reduced_damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	caster.sphere = nil
-- particle(s)
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_illusory_orb_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, Enfos.starlightSphere[pid])
-- deal the damage in the full radius. because enemies in the inner radius are also in the outer radius, we need to deal reduced damage to inner units to make the total damage amount correct.
-- there are other ways to do this that would need only one instance of damage, but they would take a lot more code. this is much simpler. it can easily be changed if it becomes a problem.
	for k,v in pairs(unitsFullRadius) do
		DealDamage(caster, v, (damage/3)*2, DAMAGE_TYPE_MAGICAL, 0)
	end
	for k,v in pairs(unitsReducedRadius) do
		DealDamage(caster, v, damage/3, DAMAGE_TYPE_MAGICAL, 0)
	end
-- emit the detonation sound
	caster:EmitSound("Hero_Abaddon.DeathCoil.Target")
-- stop the first sound (probably not necessary)
	caster:StopSound("Hero_Wisp.Spirits.Loop")
	
	local partDummy = FastDummy(caster:GetAbsOrigin(), caster:GetTeamNumber())
	local explosion = ParticleManager:CreateParticle("particles/hero_moonmage/starlight_sphere_explode.vpcf", PATTACH_OVERHEAD_FOLLOW, partDummy)
	ParticleManager:SetParticleControl(explosion,3,AdjustZ(partDummy:GetAbsOrigin(),140))
	partDummy:ForceKill(false)
	
-- blow up the sphere and end the timer
	DelayDestroy(caster, 0.05)
-- start the spell's cooldown at detonation. if this is incorrect and the cooldown is supposed to start on sphere spawn, simply delete this line
	--caster:GetAbilityByIndex(1):StartCooldown(caster:GetAbilityByIndex(1):GetCooldown(-1))
end

function Moongate(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local target = keys.target_points[1]
	local thisSpell = caster:GetAbilityByIndex(3)
	local gate = FastDummy(AdjustZ(target, 32), caster:GetTeamNumber())
	local duration = keys.gate_duration
	local gateParticle = ParticleManager:CreateParticle("particles/hero_moonmage/moongate.vpcf", PATTACH_ABSORIGIN_FOLLOW, gate)
	ParticleManager:SetParticleControl(gateParticle,62,Vector(18,18,18)) -- umm, I kinda screwed up when I was making the control points. 0 is smallest, 36 is normal size, and 72 is biggest. don't ask why
-- create the thinker for the gate
	Timers:CreateTimer(DoUniqueString("mngt"), {
		endTime = 0.03,
		callback = function()
			if gate then
				local unitsDebuff = FindUnitsInRadius(caster:GetTeamNumber(), gate:GetOrigin(), caster, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
				local unitsTeleport = FindUnitsInRadius(caster:GetTeamNumber(), gate:GetOrigin(), caster, 175, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
				for k,v in pairs(unitsDebuff) do
					thisSpell:ApplyDataDrivenModifier(caster, v, "modifier_moon_mage_moongate_debuff", {duration = 10})
				end
				for k,v in pairs(unitsTeleport) do
					if Enfos.moonbeamActive[pid] ~= nil then
						v:SetAbsOrigin(Enfos.moonbeamActive[pid]:GetAbsOrigin())
						FindClearSpaceForUnit(v, Enfos.moonbeamActive[pid]:GetAbsOrigin(), true)
					end
					if Enfos.burnActive[pid] ~= nil then
						v:SetAbsOrigin(Enfos.burnActive[pid]:GetAbsOrigin())
						FindClearSpaceForUnit(v, Enfos.burnActive[pid]:GetAbsOrigin(), true)
					end
				end
				return 0.03
			else
				return
			end
		end
	})
-- create the lifespan for the gate
	Timers:CreateTimer(DoUniqueString("mgtm"), {
		endTime = 30,
		callback = function()		
			if gate then
				gate:Destroy()
				gate = nil
			end
		end
	})
end

function Burn(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	--local partDummy = FastDummy(AdjustZ(Enfos.moonbeamActive[pid]:GetAbsOrigin(), 128), caster:GetTeamNumber())
	if Enfos.moonbeamActive[pid] == nil then
		caster:GiveMana(keys.ability:GetManaCost(keys.ability:GetLevel() - 1))
		keys.ability:EndCooldown()
		print("INACTIVE MOON BEAM")
		return
	end
	local beamLoc = Enfos.moonbeamActive[pid]:GetAbsOrigin()
	if Enfos.moonbeamActive[pid] ~= nil then
		Enfos.moonbeamActive[pid]:Destroy()
		Enfos.moonbeamActive[pid] = nil
		Timers:RemoveTimer("moonbeam_timer" .. pid)
		Timers:RemoveTimer("burn_sound_timer" .. pid)
	end
	if Enfos.burnActive[pid] ~= nil then
		--StopSoundEvent("Hero_Phoenix.SunRay.Loop",Enfos.burnActive[pid])
		Enfos.burnActive[pid]:StopSound("Hero_Phoenix.SunRay.Loop")
		Enfos.burnActive[pid]:EmitSound("Hero_Phoenix.SunRay.Stop")
		ParticleManager:DestroyParticle(Enfos.burnFx[pid],true)
		Enfos.burnActive[pid]:ForceKill(false)
		--Enfos.burnActive[pid]:Destroy()
		Enfos.burnActive[pid] = nil
	end
	Enfos.burnActive[pid] = CreateUnitByName("npc_dummy_unit", beamLoc, true, caster, caster, caster:GetTeamNumber())
	Enfos.burnFx[pid] = ParticleManager:CreateParticle("particles/hero_moonmage/burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, Enfos.burnActive[pid])
	ParticleManager:SetParticleControl(Enfos.burnFx[pid],0,beamLoc)
	ParticleManager:SetParticleControl(Enfos.burnFx[pid],1,AdjustZ(beamLoc,-1536))
	Enfos.burnActive[pid]:SetAbsOrigin(beamLoc) -- CreateUnitByName uses only the x and y coordinates so we have to move it with SetAbsOrigin()
	Enfos.burnActive[pid]:GetAbilityByIndex(0):SetLevel(1)
	Enfos.burnActive[pid]:SetDayTimeVisionRange(250)
	Enfos.burnActive[pid]:SetNightTimeVisionRange(250)
	Enfos.burnActive[pid]:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	Enfos.burnActive[pid]:AddNewModifier(dummy, nil, "modifier_invulnerable", { duration = 9999})
	Enfos.burnActive[pid]:EmitSound("Hero_Phoenix.SunRay.Cast")
	--Enfos.burnActive[pid]:EmitSoundParams("Hero_Phoenix.SunRay.Loop",0,1,20.0)
	--StartSoundEvent("Hero_Phoenix.SunRay.Loop",Enfos.burnActive[pid])
	Enfos.burnActive[pid]:EmitSound("Hero_Phoenix.SunRay.Loop")
	--StartSoundEventFromPosition("Hero_Phoenix.SunRay.Loop",Enfos.burnActive[pid]:GetAbsOrigin())
	--EmitSoundOnLocationWithCaster(Enfos.burnActive[pid]:GetAbsOrigin(),"Hero_Phoenix.SunRay.Loop",caster)
	Enfos.burnActive[pid]:AddAbility("moon_mage_burn_dummy")
	Enfos.burnActive[pid]:FindAbilityByName("moon_mage_burn_dummy"):SetLevel(1)
	Enfos.burnActive[pid]:SetControllableByPlayer(caster:GetPlayerID(), true)

	--jesus wept
	Timers:CreateTimer("burn_sound_timer" .. pid, {
		endTime = 5.5,
		useGameTime = false,
		callback = function()
			Enfos.burnActive[pid]:StopSound("Hero_Phoenix.SunRay.Loop")
			Enfos.burnActive[pid]:EmitSound("Hero_Phoenix.SunRay.Loop")
			return 5.5
		end
	})
	
	--if GameRules.BurnNightTime then Timers:RemoveTimer(GameRules.BurnNightTime)
	--else GameRules.BurnStoredTime = GameRules:GetTimeOfDay() end
	
	--GameRules:SetTimeOfDay(0.75)
	GameRules:BeginTemporaryNight(20.0)
	Timers:CreateTimer("moonbeam_timer" .. pid, {
		endTime = 20,
		callback = function()
			Enfos.burnActive[pid]:StopSound("Hero_Phoenix.SunRay.Loop")
			Enfos.burnActive[pid]:EmitSound("Hero_Phoenix.SunRay.Stop")
			Timers:RemoveTimer("burn_sound_timer" .. pid)
			ParticleManager:DestroyParticle(Enfos.burnFx[pid],true)
			Enfos.burnActive[pid]:ForceKill(false)
			--Enfos.burnActive[pid]:Destroy()
			Enfos.burnActive[pid] = nil
		end
	})
	
	--GameRules.BurnNightTime = Timers:CreateTimer(20, function()		
			--GameRules:SetTimeOfDay(GameRules.BurnStoredTime)
		--end)
end

function BurnFX(keys)
	local caster = keys.caster
	local partDummy = FastDummy(caster:GetAbsOrigin(), caster:GetTeamNumber())
	--local explosion = ParticleManager:CreateParticle("particles/hero_moon_mage/jakiro_liquid_fire_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, partDummy)
	--partDummy:EmitSound("Hero_Jakiro.LiquidFire")Hero_Phoenix.SunRay.Cast
	partDummy:ForceKill(false)
end