function Tingle( keys )
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability


        -- hit initial target
    local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
    local loc = target:GetAbsOrigin()
    ParticleManager:SetParticleControl(lightning, 0, loc + Vector(0, 0, 1000))
    ParticleManager:SetParticleControl(lightning, 1, loc)
    ParticleManager:SetParticleControl(lightning, 2, loc)
    EmitSoundOn("Hero_Leshrac.Lightning_Storm", target)

    itemTable = {}
    local maxCount = 5
 

   	for i = 0, maxCount do
		local _item = target:GetItemInSlot(i)
		if _item ~= nil then
			table.insert(itemTable, {slot = i, item = _item:GetName()})
			
		end
	end

	
	if #itemTable > 0 then 
		local randomSlot = RandomInt(1, #itemTable)

		local itemChosen = itemTable[randomSlot]
		local item = target:GetItemInSlot(itemChosen.slot)

		if item ~= nil then
	  		local pos = target:GetAbsOrigin()
	        local drop = target:DropItemAtPositionImmediate( item, pos)
	        local pos_launch = pos+RandomVector(RandomFloat(150,200))
	        item:LaunchLoot(false, 200, 0.75, pos_launch)
	        item.CanBePickedUp = 7

	        Timers:CreateTimer(DoUniqueString("itemPickupControl"), {
				endTime = 1,
				callback = function()
					if item.CanBePickedUp > 0 then
						item.CanBePickedUp = item.CanBePickedUp-1
						return 1
					else
						return
					end
				end
			})
		end
	end

 end

 function FortressOfIce(keys)
-- vars
	local caster = keys.caster
	local thisSpellLevel = caster:GetAbilityByIndex(0):GetLevel()
	local findUnits = Entities:FindAllByClassnameWithin("npc_dota_creature", caster:GetAbsOrigin(), 1000)
	local ability = keys.ability
-- logic
	print("Spawning unit")
	for k,v in pairs(findUnits) do
		if v:GetUnitName() == "npc_fortress_of_ice" and not v.summonerUnit then -- in case the cooldowns get refreshed, we don't want to upgrade existing units
			v.summonerUnit = true 	
			AddTypes(v, "modifier_armor_fortified", "modifier_attack_normal")
			v:SetPhysicalArmorBaseValue(keys.armour)
			v:SetMaxHealth(keys.health)
			v:SetBaseMaxHealth(keys.health)
			v:SetHealth(keys.health)
			v:GetAbilityByIndex(0):SetLevel(1)
		end
	end
end

function AddTypes(mob, armor, attack)
	local spawnedUnitIndex = mob
	local armorType = armor
	local attackType = attack

	local armorItem = CreateItem("item_armor_type_modifier", nil, nil) 
	armorItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, armorType, {})
	UTIL_RemoveImmediate(armorItem)
	armorItem = nil

	local attackItem = CreateItem("item_attack_type_modifier", nil, nil) 
	attackItem:ApplyDataDrivenModifier(spawnedUnitIndex, spawnedUnitIndex, attackType, {})
	UTIL_RemoveImmediate(attackItem)
	attackItem = nil
end

function BerserkersCall( keys )
	local caster = keys.caster
	local target = keys.target

	-- Clear the force attack target
	target:SetForceAttackTarget(nil)

	-- Give the attack order if the caster is alive
	if caster ~= nil then
		if caster:IsAlive() then
			local order = 
			{
				UnitIndex = target:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = caster:entindex()
			}

			ExecuteOrderFromTable(order)
		end

		-- Set the force attack target to be the caster
		target:SetForceAttackTarget(caster)
	end
end

-- Clears the force attack target upon expiration
function BerserkersCallEnd( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end

function fire_rain(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local impactRadius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local searchRadius = ability:GetSpecialValueFor("meteor_fall_area")

	caster.blastDummy = FastDummy(target, caster:GetTeamNumber())
	caster.blastDummy:EmitSound("Hero_Invoker.SunStrike.Ignite")
	local particle = ParticleManager:CreateParticle("particles/hero_warrior_mage/fire_rain_storm.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.blastDummy)
	ParticleManager:SetParticleControl(particle,62,Vector(impactRadius/228,1,1))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster.blastDummy:GetAbsOrigin(), caster, impactRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)
	for k,v in pairs(enemies) do
		DealDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL, 0)
	end
end

function fire_rain_end(keys)
local caster = keys.caster
	if caster.blastDummy ~= nil then
		caster.blastDummy:Destroy()
		caster.blastDummy = 0
	end
end