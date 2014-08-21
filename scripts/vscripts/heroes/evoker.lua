function StaticDischarge(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false) -- only creeps targetted. change if you want others
-- create our applier if it's not already made.
	if Enfos.appliers[pid].StaticDischargeApplier == nil then
		Enfos.appliers[pid] = {StaticDischargeApplier = CreateItem('item_applier_static_discharge', nil, nil)} -- add it to the table
	end
	local applier = Enfos.appliers[pid].StaticDischargeApplier
	local target = nil
	local lightningBolt = nil
-- checks for valid units and execute the spell
	if #units > 0 then
		target = units[math.random(1,#units)]
		lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster) -- a bit bad right now
		ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2))) -- to make it look decent
		target:EmitSound("Hero_Zuus.ArcLightning.Target")	
		applier:ApplyDataDrivenModifier(caster, target, "modifier_evoker_static_discharge_debuff", {duration = 30})		
	end
end

function GarZeng(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local target = keys.target
	local damage = keys.damage
	local unitsHit = keys.units_hit
	unitsHit = unitsHit - 1
	local cfVec = caster:GetForwardVector()
	if Enfos.appliers[pid].GenericApplier == nil then
		Enfos.appliers[pid] = {GenericApplier = CreateItem('item_generic_applier', nil, nil)}
	end
	local applier = Enfos.appliers[pid].GenericApplier
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster) -- attach type 7 isn't good. fix later.
-- logic
	DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0) -- this is quick function to more quickly apply damage. see enfos.lua
	caster:EmitSound("Hero_ShadowShaman.EtherShock")
	target:EmitSound("Hero_ShadowShaman.EtherShock.Target")
	applier:ApplyDataDrivenModifier(caster, target, "modifier_skill_flag", {}) -- apply a flag to the main unit so that we don't double shock it
	ParticleManager:SetParticleControl(particle,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)))
-- we need to reduce the units table to only valid targets before we do skill processing so that. the unit is found here in case the main target was killed by the direct damage.
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 1, false)
	local inCone = {}
	--PrintTable(units)
	print (math.cos(45))
	print ("---")
	for k,v in pairs (units) do
		local highVar = cfVec:Dot((v:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
		local lowVar = math.cos(45) -- 45 degree cone. a complete guess if this is correct
		print (highVar .. "x")
		print (v:HasModifier("modifier_skill_flag"))
		if highVar > lowVar or v:HasModifier("modifier_skill_flag") then -- if the highVar is a higher number than the lowVar, it's in the cone.
			print (highVar .. "y")
			print (k)
			table.insert(inCone, v) -- remove the unit if it's not in the cone
		end
		PrintTable(inCone)
		print ("---")
	end
-- getting the correct behaviour 
	if #inCone < unitsHit then
		unitsHit = #inCone
	end
	for k,v in pairs(inCone) do
		if unitsHit <= 0 then
			return
		else
			local coneParticle = ParticleManager:CreateParticle("particles/inCone/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControl(coneParticle,1,Vector(v:GetAbsOrigin().x,v:GetAbsOrigin().y,v:GetAbsOrigin().z+((v:GetBoundingMaxs().z - v:GetBoundingMins().z)/2)))	
			v:EmitSound("Hero_ShadowShaman.EtherShock.Target")
			DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
			unitsHit = unitsHit - 1
		end
	end
	target:RemoveModifierByName("modifier_skill_flag")
end

function ChainLightning(keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	local damage = keys.damage
	local bounces = keys.bounces
	local units = nil
	local lightningBolt = nil
	local boltDummy = nil
	lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)))	
	DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
-- this timer is used for the bounces	
	Timers:CreateTimer(DoUniqueString("arcl"), {
		endTime = 0.2,
		callback = function()
-- unit selection and counting
			units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetOrigin(), caster, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, true) -- again, cast range not documented. these tooltips suck
			PrintTable(units)
-- end the spell if there are no valid targets
			if #units < 1 then
				return
			end
-- particle stuff. the bounding box stuff is so that the lightning shoots out of the middle. it still attaches to the feet so it's a bit weird but it's mostly fine. 
-- the particle must be created during the timer but before the target switch	
			targetVec = target:GetAbsOrigin()
			targetVec.z = target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)
			if boltDummy ~= nil then
				boltDummy:Destroy()
			end
			boltDummy = FastDummy(targetVec, DOTA_TEAM_NOTEAM)
			lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, boltDummy)
-- select a target randomly from the table and deal damage. while loop makes sure the target doesn't select itself.		
			local tTarget = units[math.random(1,#units)]
			while tTarget == target do
				tTarget = units[math.random(1,#units)]
			end
			target = tTarget
			DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
-- play the sound
			target:EmitSound("Hero_Zuus.ArcLightning.Target")
-- make the particle shoot to the target
			ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)))																				
-- decrement remaining spell bounces, reduce damage, and clear relevant tables
			bounces = bounces - 1
			damage = damage / 1.1
-- fire the timer again if spell bounces remain
			if bounces > 0 then
				return 0.2
			end
		end
	})
end

function BallLightning(keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local damage = keys.damage
	local duration = keys.duration * 4 -- multiplying by 4 since it's firing every 0.25
	local ball = FastDummy(AdjustZ(target, 128), DOTA_TEAM_NOTEAM) --AdjustZ is a function in enfos.lua
	local ballLightning = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, ball)
-- timer
	Timers:CreateTimer(DoUniqueString("blit"), {
		endTime = 0.25, -- guessing on the interval. it's not listed.
		callback = function()
			duration = duration - 1
			local units = FindUnitsInRadius(caster:GetTeamNumber(), ball:GetAbsOrigin(), caster, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
			if #units > 0 then
				tTarget = units[math.random(1,#units)]
				local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, ball)
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(tTarget:GetAbsOrigin().x,tTarget:GetAbsOrigin().y,tTarget:GetAbsOrigin().z+((tTarget:GetBoundingMaxs().z - tTarget:GetBoundingMins().z)/2)))
				tTarget:EmitSound("Hero_Zuus.ArcLightning.Target")	
				DealDamage(caster, tTarget, damage, DAMAGE_TYPE_MAGICAL, 0)
			end
			print (duration)
			if duration > 0 then
				return 0.25
			elseif duration <= 0 then
				ball:Destroy()
				return
			end
		end
	})
end

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

-- -- cc
	