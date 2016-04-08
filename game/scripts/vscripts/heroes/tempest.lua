function zephyr (keys)
	local caster = keys.caster
	local radius = keys.radius
	local target = keys.target_points[1]

	local dummy = FastDummy(target, caster:GetTeamNumber())
	local particle = ParticleManager:CreateParticle("particles/hero_tempest/razor_rain_storm.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl(particle,62,Vector(radius/228,1,1))
	dummy:AddAbility("tempest_zephyr_proxy")
	local dummySpell = dummy:FindAbilityByName("tempest_zephyr_proxy")
-- logic
	dummySpell:SetLevel(1)


	DelayDestroy(dummy, 10)

	Timers:CreateTimer(DoUniqueString("zephyr"), {
		endTime = 1,
		callback = function()
			if dummy ~= nil then
				local units = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), caster, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 1, false)
				for k,v in pairs(units) do
					local maxHealth = v:GetMaxHealth()
					local healed = maxHealth * 0.02
					v:Heal(healed, caster)
				end
				return 1
			end
		end
	})
end

function paeldryths_wrath (keys)
	local caster = keys.caster
	local target = keys.target
	local targetPos = target:GetAbsOrigin()
	local damage = keys.damage 		--% damage
	local distance = keys.distance
	Timers:CreateTimer(DoUniqueString("paeldryths_wrath"), {
		endTime = 0.4,
		callback = function()
			-- Get all of the variables
		 	local targetPos2 = target:GetAbsOrigin() 
		 	local difference = targetPos - targetPos2
			difference = difference:Length2D()
			local targetHealth = target:GetHealth()
			local percentTravelled = difference / distance
			local percentDamageDealt = percentTravelled * damage

			local damageDealt = targetHealth * percentDamageDealt / 100
			damageDealt = math.floor(damageDealt)

			DealDamage(caster, target, damageDealt, DAMAGE_TYPE_MAGICAL, 0)
		end
	})
end

function burst (keys)
	--PrintTable(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = keys.damage
	local health = target:GetHealth()

	--Checks if there is an overkill, and sets the damage to be non-lethal if it is
	if damage > health then
		damage = health - 1
	end

	--Gets the owner for the tornado
	if caster:IsRealHero() == false then
		caster = caster:GetPlayerOwner():GetAssignedHero()
	end

	--Damage
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ability})
end

function burst_dummy(keys)
	local caster = keys.caster
	local radius = keys.radius
	local target = keys.target_points[1]
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()

	local dummy = FastDummy(target, caster:GetTeamNumber(), caster)
	dummy:AddAbility("tempest_burst_proxy")
	local dummySpell = dummy:FindAbilityByName("tempest_burst_proxy")
-- logic
	dummySpell:SetLevel(abilityLevel)

	--FX
	local particle = ParticleManager:CreateParticle("particles/neutral_fx/tornado_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)

	DelayDestroy(dummy, 30)
end

function vertigo (keys)
-- vars
	local caster = keys.caster
	local target = keys.target_points[1]
	local damage = keys.damage
	local radius = keys.radius
	local casterPos = caster:GetAbsOrigin()
	local fVec = caster:GetForwardVector()
	local spawnPosL = RotatePosition(Vector(0, 0, 0), QAngle(0, -15, 0), fVec)
	local spawnPosR = RotatePosition(Vector(0, 0, 0), QAngle(0, 15, 0), fVec)
	local slivers = 10
	local count = 0
	local thisSpell = caster:GetAbilityByIndex(3)
-- initial release timer
	Timers:CreateTimer(DoUniqueString("tempest"), {
		endTime = 0.03,
		callback = function()
-- create the units. give it some randomness
			local unit = FastDummy(casterPos - Vector((fVec.x * 400) * math.random(0.85,1.15), (fVec.y * 400) * math.random(0.85,1.15), fVec.z), caster:GetTeamNumber())
			thisSpell:ApplyDataDrivenModifier(caster, unit, "modifier_tempest_vertigo_applier", {})
			unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
-- set their movement
			unit:SetForwardVector(fVec)
			local movement = {
				UnitIndex = unit:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = casterPos + Vector(fVec.x * 400, fVec.y * 400, fVec.z),
				Queue = true
			}
			ExecuteOrderFromTable(movement)
-- apply particles
			local tPart = ParticleManager:CreateParticle("particles/hero_tempest/tornado_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
			-- ParticleManager:SetParticleControl(tPart, 1, Vector(450,0,0)) -- needed?
-- kill the guy when the time runs out
			Timers:CreateTimer(DoUniqueString("kltmp"), {
				endTime = 2.25,
				callback = function()
					unit:Destroy()
				end
			})
-- create the side tornadoes
			for i=0,3 do
-- this is math that makes them show up somewhat in a line. I'm repeating myself really badly here :/
				count = (count + 30) * 1.25
				spawnPosL = RotatePosition(Vector(0, 0, 0), QAngle(0, -10, 0), spawnPosL)
				spawnPosR = RotatePosition(Vector(0, 0, 0), QAngle(0, 10, 0), spawnPosR)
-- spawn the units. 
				local unitL = FastDummy(casterPos - Vector((spawnPosL.x * (400 + count)) * math.random(0.85,1.15), (spawnPosL.y * (400 + count)) * math.random(0.85,1.15), spawnPosL.z), caster:GetTeamNumber())
				thisSpell:ApplyDataDrivenModifier(caster, unitL, "modifier_tempest_vertigo_applier", {})
				unitL:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
				local unitR = FastDummy(casterPos - Vector((spawnPosR.x * (400 + count)) * math.random(0.85,1.15), (spawnPosR.y * (400 + count)) * math.random(0.85,1.15), spawnPosR.z), caster:GetTeamNumber())
				thisSpell:ApplyDataDrivenModifier(caster, unitR, "modifier_tempest_vertigo_applier", {})
				unitR:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
				local tPartL = ParticleManager:CreateParticle("particles/hero_tempest/tornado_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unitL)
				local tPartR = ParticleManager:CreateParticle("particles/hero_tempest/tornado_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, unitR)
				local movementL = {
					UnitIndex = unitL:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = casterPos + Vector(spawnPosR.x * (400 + count), spawnPosR.y * (400 + count), spawnPosL.z), --if I use spawnPosL, it crosses over. kinda weird
					Queue = true
				}
				ExecuteOrderFromTable(movementL)
				local movementR = {
					UnitIndex = unitR:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = casterPos + Vector(spawnPosL.x * (400 + count), spawnPosL.y * (400 + count), spawnPosR.z),
					Queue = true
				}
				ExecuteOrderFromTable(movementR)
-- kill them
				Timers:CreateTimer(DoUniqueString("kltmp2"), {
					endTime = 2.25,
					callback = function()
						unitL:Destroy()
						unitR:Destroy()
					end
				})
			end
-- reset these vars
			count = 0
			spawnPosL = RotatePosition(Vector(0, 0, 0), QAngle(0, -15, 0), fVec)
			spawnPosR = RotatePosition(Vector(0, 0, 0), QAngle(0, 15, 0), fVec)
-- keep it going if you're still channeling
			if thisSpell:IsChanneling() then
				return 0.5
			end
		end
	})
end

function vertigo_damage(keys)
	local target = keys.target
	local caster = keys.caster
	local thisSpell = caster:GetAbilityByIndex(3)
	if not target:HasModifier("modifier_tempest_vertigo_damage") then
		--print("Target hasn't recently been damaged, damaging")
		thisSpell:ApplyDataDrivenModifier(caster, target, "modifier_tempest_vertigo_damage", {})
	end
end