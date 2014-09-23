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
	print("Bursting")
	--PrintTable(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = keys.damage
	local health = target:GetHealth()
	print(damage)
	print("Health: "..health)

	if damage > health then
		damage = health - 1
	end
	print(damage)

	DealDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL, 0)
end

function vertigo (keys)
-- vars
	local caster = keys.caster
	local target = keys.target
	local damage = keys.damage
	local radius = keys.radius
	local slivers = 10
	local count = 0
-- initial release timer
	Timers:CreateTimer(DoUniqueString("vertigo"), {
		endTime = 0.03,
		callback = function()
			count = count + 1
			local thisUnit = FastDummy(caster:GetAbsOrigin(), caster:GetTeamNumber())
			local movement = {}
			thisUnit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
			thisUnit:SetBaseMoveSpeed(200)
			ParticleManager:CreateParticle("particles/neutral_fx/tornado_ambient.vpcf", PATTACH_OVERHEAD_FOLLOW, thisUnit)
			local a, b, c = GetLine(caster, target)
			local vec = target:GetAbsOrigin()
			print(vec)
			print("Giving movement command")
			local order = {
				UnitIndex = thisUnit:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vec,
				Queue = true
			}
			ExecuteOrderFromTable(order)
			--if count < slivers then
			--	return 0.03
			--else
			--	count = 0
			--	return
			--end
			Timers:CreateTimer(DoUniqueString("vertDestroy"), {
				endTime = 10,
				callback = function()
					if thisUnit ~= nil then
						thisUnit:Destroy()
					end
				end
			})
		end
	})
end