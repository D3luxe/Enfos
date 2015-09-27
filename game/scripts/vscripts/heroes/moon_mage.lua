function CancelAnimation(keys)
	local caster = keys.caster
	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
end

-- this doesn't have the little duration ball 
function StarlightSphereSummon(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local findSphere = Entities:FindAllByClassnameWithin("npc_dota_base_additive", caster:GetAbsOrigin(), 300)
	for k,v in pairs(findSphere) do
		if v:GetUnitName() == "npc_starlight_sphere" then
			Enfos.starlightSphere[pid] = v
			break
		end
	end
	Enfos.starlightSphere[pid]:SetControllableByPlayer(pid, true)
	Enfos.starlightSphere[pid]:GetAbilityByIndex(0):SetLevel(1)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_ambient.vpcf", PATTACH_OVERHEAD_FOLLOW, Enfos.starlightSphere[pid])
	Enfos.starlightSphere[pid]:EmitSound("Hero_Wisp.Spirits.Loop")
-- switch the visible spells
	caster:GetAbilityByIndex(1):SetHidden(true)
	caster:GetAbilityByIndex(2):SetLevel(caster:GetAbilityByIndex(1):GetLevel()) -- mostly just for visual effect
	caster:GetAbilityByIndex(2):SetHidden(false)
-- set the duration timer
end

function StarlightSphereDetonate(keys)
-- vars
	local caster = keys.caster
	if not caster:IsHero() then
		caster = caster:GetOwner() -- since the sphere itself can cast this spell, we need to get the owner of the spell instead
	end
	local pid = caster:GetPlayerID()
	local damage = keys.damage
	local unitsFullRadius = FindUnitsInRadius(caster:GetTeamNumber(), Enfos.starlightSphere[pid]:GetOrigin(), caster, keys.full_damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	local unitsReducedRadius = FindUnitsInRadius(caster:GetTeamNumber(), Enfos.starlightSphere[pid]:GetOrigin(), caster, keys.reduced_damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
-- particle(s)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, Enfos.starlightSphere[pid])
-- deal the damage in the full radius. because enemies in the inner radius are also in the outer radius, we need to deal reduced damage to inner units to make the total damage amount correct.
-- there are other ways to do this that would need only one instance of damage, but they would take a lot more code. this is much simpler. it can easily be changed if it becomes a problem.
	for k,v in pairs(unitsFullRadius) do
		DealDamage(caster, v, damage*0.667, DAMAGE_TYPE_MAGICAL, 0)
	end
	for k,v in pairs(unitsReducedRadius) do
		DealDamage(caster, v, damage*0.333, DAMAGE_TYPE_MAGICAL, 0)
	end
-- switch the visible spells
	caster:GetAbilityByIndex(1):SetHidden(false)
	caster:GetAbilityByIndex(2):SetHidden(true)
-- emit the detonation sound
	Enfos.starlightSphere[pid]:EmitSound("Hero_Wisp.Spirits.Destroy")
-- stop the first sound (probably not necessary)
	Enfos.starlightSphere[pid]:StopSound("Hero_Wisp.Spirits.Loop")
-- blow up the sphere and end the timer
	DelayDestroy(Enfos.starlightSphere[pid], 0.05)
	Enfos.starlightSphere[pid] = nil
-- start the spell's cooldown at detonation. if this is incorrect and the cooldown is supposed to start on sphere spawn, simply delete this line
	caster:GetAbilityByIndex(1):StartCooldown(caster:GetAbilityByIndex(1):GetCooldown(-1))
end

function Moongate(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local target = keys.target_points[1]
	local thisSpell = caster:GetAbilityByIndex(3)
	local gate = FastDummy(AdjustZ(target, 32), caster:GetTeamNumber())
	local duration = keys.gate_duration
	local gateParticle = ParticleManager:CreateParticle("particles/hero_moon_mage/enigma_blackhole.vpcf", PATTACH_ABSORIGIN_FOLLOW, gate)
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
	local unit = CreateUnitByName("npc_dummy_unit", Enfos.moonbeamActive[pid]:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	local fx = ParticleManager:CreateParticle("particles/items_fx/aura_shivas.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	unit:SetAbsOrigin(Enfos.moonbeamActive[pid]:GetAbsOrigin()) -- CreateUnitByName uses only the x and y coordinates so we have to move it with SetAbsOrigin()
	unit:GetAbilityByIndex(0):SetLevel(1)
	unit:SetDayTimeVisionRange(250)
	unit:SetNightTimeVisionRange(250)
	unit:AddNewModifier(dummy, nil, "modifier_phased", { duration = 9999})
	unit:AddNewModifier(dummy, nil, "modifier_invulnerable", { duration = 9999})
	unit:EmitSound("Hero_Jakiro.LiquidFire")
	unit:AddAbility("moon_mage_burn_dummy")
	unit:FindAbilityByName("moon_mage_burn_dummy"):SetLevel(1)
	unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	
end

function BurnFX(keys)
	local caster = keys.caster
	local partDummy = FastDummy(caster:GetAbsOrigin(), caster:GetTeamNumber())
	local explosion = ParticleManager:CreateParticle("particles/hero_moon_mage/jakiro_liquid_fire_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, partDummy)
	partDummy:EmitSound("Hero_Jakiro.LiquidFire")
	partDummy:ForceKill(false)
end