function StaticDischarge(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false) -- only creeps targetted. change if you want others
	local thisSpell = keys.ability
	local cost = thisSpell:GetLevelSpecialValueFor("mana_cost", thisSpell:GetLevel() - 1)
	local target = nil
	local lightningBolt = nil

	--Ensures Evoker has enough mana to zap, removes the modifier if he doesnt
	if cost > caster:GetMana() then
		caster:RemoveModifierByName("modifier_evoker_static_discharge")
	end

-- checks for valid units and execute the spell
	if #units > 0 then
		--Sees if any units in the area do not yet have the debuff and adds them to a new table
		local viableUnits = {}
		for i=1,#units do
			if units[i] ~= nil then
				if not units[i]:HasModifier("modifier_evoker_static_discharge_debuff") then
					table.insert(viableUnits, units[i])
				end
			end
		end

		--If a unit doesnt have the buff, then cast it on them
		if #viableUnits > 0 then
			target = viableUnits[math.random(1,#viableUnits)]
			lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_OVERHEAD_FOLLOW, caster) -- a bit bad right now
			ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2))) -- to make it look decent
			target:EmitSound("Hero_Zuus.ArcLightning.Target")	
			thisSpell:ApplyDataDrivenModifier(caster, target, "modifier_evoker_static_discharge_debuff", {duration = 30})	
			caster:SpendMana(cost, thisSpell)
		end
	end
end

function OnSpellStart(keys)
	keys.caster:FindAbilityByName("evoker_gar_zeng"):OnSpellStart()
end

function GarZeng(keys)
-- vars
	local caster = keys.caster
	local pid = caster:GetPlayerID()
	local target = keys.target
	local damage = keys.damage
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local start_radius = ability:GetLevelSpecialValueFor("start_radius", level )
	local end_radius = ability:GetLevelSpecialValueFor("end_radius", level )
	local end_distance = ability:GetLevelSpecialValueFor("end_distance", level )
	local targets = ability:GetLevelSpecialValueFor("units_hit", level )
	local AbilityDamageType = ability:GetAbilityDamageType()
	local particleName = "particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf"

	-- Make sure the main target is damaged
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = AbilityDamageType, ability = keys.ability})
	target:EmitSound("Hero_ShadowShaman.EtherShock.Target")

	local cone_units = GetEnemiesInCone( target, start_radius, end_radius, end_distance )
	--print("_________________________________________________________________")
	--PrintTable(cone_units)
	local targets_shocked = 1 --Is targets=extra targets or total?
	for _,unit in pairs(cone_units) do
		if targets_shocked < targets then
			if unit ~= caster and unit ~= target and unit:IsAlive() then
				-- Particle
				local origin = unit:GetAbsOrigin()
				local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))	
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
			
				-- Damage
				ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = AbilityDamageType, ability = keys.ability})

				-- Increment counter
				targets_shocked = targets_shocked + 1
				print(targets_shocked)
			end
		else
			break
		end
	end

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
	local failsafe = 10
	lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+((target:GetBoundingMaxs().z - target:GetBoundingMins().z)/2)))	
	DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
-- this timer is used for the bounces	
	Timers:CreateTimer(DoUniqueString("arcl"), {
		endTime = 0.2,
		callback = function()
-- unit selection and counting
			units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetOrigin(), caster, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, true) -- again, cast range not documented. these tooltips suck
			--PrintTable(units)
-- end the spell if there are no valid targets
			if #units < 1 then
				return
			end
			
			failsafe = 10
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
				--print(#units)
				--failsafe
				failsafe = failsafe - 1
				--print(failsafe)
				if failsafe == 0 then return end
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

function GetEnemiesInCone( unit, start_radius, end_radius, end_distance)
	local DEBUG = false
	
	-- Positions
	local fv = unit:GetForwardVector() * -1
	local origin = unit:GetAbsOrigin()

	local start_point = origin + fv * start_radius -- Position to find units with start_radius
	local end_point = origin + fv * (start_radius + end_distance) -- Position to find units with end_radius

	if DEBUG then
		DebugDrawCircle(start_point, Vector(255,0,0), 100, start_radius, true, 3)
		DebugDrawCircle(end_point, Vector(255,0,0), 100, end_radius, true, 3)
	end

	-- 1 medium circle should be enough as long as the mid_interval isn't too large
	local mid_interval = end_distance - start_radius - end_radius
	local mid_radius = (start_radius + end_radius) / 2
	local mid_point = origin + fv * mid_radius * 2
	
	if DEBUG then
		--print("There's a space of "..mid_interval.." between the circles at the cone edges")
		DebugDrawCircle(mid_point, Vector(0,255,0), 100, mid_radius, true, 3)
	end

	-- Find the units
	local team = unit:GetTeamNumber()
	local iTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local iFlag = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES
	local iOrder = FIND_ANY_ORDER

	local start_units = FindUnitsInRadius(team, start_point, nil, start_radius, iTeam, iType, iFlag, iOrder, false)
	local end_units = FindUnitsInRadius(team, end_point, nil, end_radius, iTeam, iType, iFlag, iOrder, false)
	local mid_units = FindUnitsInRadius(team, mid_point, nil, mid_radius, iTeam, iType, iFlag, iOrder, false)

	-- Join the tables
	local cone_units = {}
	for k,v in pairs(end_units) do
		table.insert(cone_units, v)
	end

	for k,v in pairs(start_units) do
		if not tableContains(cone_units, k) then
			table.insert(cone_units, v)
		end
	end	

	for k,v in pairs(mid_units) do
		if not tableContains(cone_units, k) then
			table.insert(cone_units, v)
		end
	end

	--DeepPrintTable(cone_units)
	return cone_units

end

-- Returns true if the element can be found on the list, false otherwise
function tableContains(list, element)
    if list == nil then return false end
    for i=1,#list do
        if list[i] == element then
            return true
        end
    end
    return false
end

function BallLightning(keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local damage = keys.damage

	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local bat = ability:GetLevelSpecialValueFor("base_attack_time", level )
	local splash_close = ability:GetLevelSpecialValueFor("splash_close", level )
	local splash_medium = ability:GetLevelSpecialValueFor("splash_medium", level )
	local splash_far = ability:GetLevelSpecialValueFor("splash_far", level )

	local duration = keys.duration * 1/bat -- Calculates attacks per second and adjusts the duration accordingly.
	local ball = FastDummy(AdjustZ(target, 128), DOTA_TEAM_NOTEAM) --AdjustZ is a function in enfos.lua
	local ballLightning = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, ball)
-- timer
	Timers:CreateTimer(DoUniqueString("blit"), {
		endTime = bat, -- guessing on the interval. it's not listed.
		callback = function()
			duration = duration - 1
			local units = FindUnitsInRadius(caster:GetTeamNumber(), ball:GetAbsOrigin(), caster, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
			if #units > 0 then
				--Deal main damage
				tTarget = units[math.random(1,#units)]
				local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, ball)
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(tTarget:GetAbsOrigin().x,tTarget:GetAbsOrigin().y,tTarget:GetAbsOrigin().z+((tTarget:GetBoundingMaxs().z - tTarget:GetBoundingMins().z)/2)))
				tTarget:EmitSound("Hero_Zuus.ArcLightning.Target")	
				DealDamage(caster, tTarget, damage, DAMAGE_TYPE_MAGICAL, 0)


				--Deal splash damage
				local close = FindUnitsInRadius(caster:GetTeamNumber(), tTarget:GetAbsOrigin(), caster, splash_close, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
				local medium = FindUnitsInRadius(caster:GetTeamNumber(), tTarget:GetAbsOrigin(), caster, splash_medium, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
				local far = FindUnitsInRadius(caster:GetTeamNumber(), tTarget:GetAbsOrigin(), caster, splash_far, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)

				--20% splash damage total
				if #far > 0 then
					for i=1, #far do
						DealDamage(caster, far[i], damage*0.2, DAMAGE_TYPE_MAGICAL, 0)
					end
				end


				--40% splash damage total
				if #medium > 0 then
					for i=1, #medium do
						DealDamage(caster, medium[i], damage*0.2, DAMAGE_TYPE_MAGICAL, 0)
					end
				end

				--100% splash damage total
				if #close > 0 then
					for i=1, #close do
						DealDamage(caster, close[i], damage*0.6, DAMAGE_TYPE_MAGICAL, 0)
					end
				end
			end
			--print (duration)
			if duration > 0 then
				return bat
			elseif duration <= 0 then
				ball:Destroy()
				return
			end
		end
	})
end